# Cache Manager Architecture

## Component Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│                  (UI Components, Pages)                      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ uses
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │         CacheRepository (Interface)                 │    │
│  │  - getCachedWallpaper(id): File?                   │    │
│  │  - cacheWallpaper(id, file): void                  │    │
│  │  - clearCache(): void                              │    │
│  │  - getCacheSize(): int                             │    │
│  │  - evictOldestIfNeeded(): void                     │    │
│  └────────────────────────────────────────────────────┘    │
└────────────────────────┬────────────────────────────────────┘
                         │
                         │ implements
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │      CacheRepositoryImpl (Implementation)          │    │
│  │                                                     │    │
│  │  Dependencies:                                      │    │
│  │  - CacheMetadataLocalDataSource                    │    │
│  │  - WallpaperCacheManager                           │    │
│  └──────────────┬──────────────────┬───────────────────┘    │
│                 │                  │                         │
│                 │                  │                         │
│     ┌───────────▼──────────┐  ┌───▼──────────────────┐     │
│     │ CacheMetadata        │  │ WallpaperCache       │     │
│     │ LocalDataSource      │  │ Manager              │     │
│     │                      │  │                      │     │
│     │ - Hive Box           │  │ - flutter_cache_     │     │
│     │ - Metadata CRUD      │  │   manager            │     │
│     │ - LRU tracking       │  │ - File operations    │     │
│     │                      │  │ - Size monitoring    │     │
│     └──────────────────────┘  └──────────────────────┘     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Caching a Wallpaper

```
User Action
    │
    ▼
UI calls cacheWallpaper(id, file)
    │
    ▼
CacheRepositoryImpl
    │
    ├─► Copy file to cache directory
    │
    ├─► Calculate file size
    │
    ├─► Create CachedWallpaperMetadata
    │   - wallpaperId
    │   - localPath
    │   - fileSizeBytes
    │   - cachedAt
    │   - lastAccessedAt
    │
    ├─► Save metadata to Hive
    │
    └─► Check cache size & evict if needed
        │
        ▼
    evictOldestIfNeeded()
        │
        ├─► Get all metadata
        │
        ├─► Sort by lastAccessedAt (oldest first)
        │
        ├─► Delete oldest files until under 500 MB
        │
        └─► Update metadata
```

### Retrieving a Cached Wallpaper

```
User Action
    │
    ▼
UI calls getCachedWallpaper(id)
    │
    ▼
CacheRepositoryImpl
    │
    ├─► Get metadata from Hive
    │
    ├─► Check if file exists
    │   │
    │   ├─► If not exists: Delete stale metadata, return null
    │   │
    │   └─► If exists: Continue
    │
    ├─► Update lastAccessedAt (LRU tracking)
    │
    └─► Return File
```

### LRU Eviction Process

```
Cache Size Check
    │
    ▼
Is cache > 500 MB?
    │
    ├─► No: Do nothing
    │
    └─► Yes: Start eviction
        │
        ▼
    Get all metadata from Hive
        │
        ▼
    Sort by lastAccessedAt (ascending)
        │
        ▼
    For each metadata (oldest first):
        │
        ├─► Delete file from disk
        │
        ├─► Delete metadata from Hive
        │
        ├─► Calculate freed space
        │
        └─► Is cache < 500 MB?
            │
            ├─► Yes: Stop eviction
            │
            └─► No: Continue to next file
```

## Storage Structure

### File System

```
/data/user/0/com.example.wallpaper_app/cache/
├── wallpaper_cache/              # Custom cache directory
│   ├── wallpaper_123.jpg
│   ├── wallpaper_456.png
│   └── wallpaper_789.jpg
│
└── libCachedImageData/           # flutter_cache_manager
    ├── [hash1].jpg
    ├── [hash2].png
    └── [hash3].jpg
```

### Hive Storage

```
cache_metadata.hive
├── wallpaper_123 → CachedWallpaperMetadata
│   ├── wallpaperId: "wallpaper_123"
│   ├── localPath: "/path/to/wallpaper_123.jpg"
│   ├── fileSizeBytes: 2048576
│   ├── cachedAt: 2024-01-15T10:30:00Z
│   └── lastAccessedAt: 2024-01-20T15:45:00Z
│
├── wallpaper_456 → CachedWallpaperMetadata
│   └── ...
│
└── wallpaper_789 → CachedWallpaperMetadata
    └── ...
```

## Provider Dependency Graph

```
┌─────────────────────────────────────┐
│      ProviderScope (main.dart)      │
│                                     │
│  Overrides:                         │
│  - cacheMetadataLocalDataSource     │
│    Provider                         │
└──────────────┬──────────────────────┘
               │
               │ provides
               ▼
┌─────────────────────────────────────┐
│   cacheRepositoryProvider           │
│                                     │
│   Dependencies:                     │
│   - cacheMetadataLocalDataSource    │
│   - wallpaperCacheManager           │
└─────────────────────────────────────┘
               │
               │ used by
               ▼
┌─────────────────────────────────────┐
│   UI Components / Use Cases         │
│   - Settings Page                   │
│   - Download Manager                │
│   - Browse Feature                  │
└─────────────────────────────────────┘
```

## Key Design Decisions

### 1. Dual Cache System

**Why?**
- `flutter_cache_manager`: Handles network image caching automatically for thumbnails
- Custom cache directory: Manages full-resolution downloaded wallpapers with metadata

**Benefits:**
- Separation of concerns
- Better control over eviction policy
- Metadata tracking for LRU

### 2. Hive for Metadata

**Why?**
- Fast key-value storage
- Type-safe with code generation
- Synchronous and asynchronous APIs
- No SQL overhead

**Benefits:**
- Quick metadata lookups
- Efficient LRU tracking
- Persistent across app restarts

### 3. LRU Eviction Policy

**Why?**
- Most recently used wallpapers are more likely to be accessed again
- Fair eviction strategy
- Predictable behavior

**Implementation:**
- Track `lastAccessedAt` on every read
- Sort by timestamp when evicting
- Delete oldest first

### 4. Automatic Eviction

**Why?**
- Prevents cache from growing unbounded
- No user intervention needed
- Transparent to user

**Trigger:**
- After every `cacheWallpaper()` call
- Can be manually triggered via `evictOldestIfNeeded()`

## Performance Considerations

### Cache Size Calculation
- **O(n)** where n = number of files
- Cached result could be added for optimization
- Trade-off: accuracy vs. performance

### LRU Eviction
- **O(n log n)** for sorting metadata
- **O(k)** for deleting k files
- Typically k << n, so acceptable performance

### Metadata Updates
- **O(1)** for Hive key-value operations
- Very fast, no performance concerns

## Error Handling

### File Operations
- Wrapped in try-catch blocks
- Graceful degradation on errors
- Stale metadata cleanup

### Cache Eviction
- Continues on individual file deletion errors
- Prevents infinite loops
- Logs errors for debugging

## Testing Strategy

### Unit Tests
- Mock CacheMetadataLocalDataSource
- Mock WallpaperCacheManager
- Test each method in isolation

### Integration Tests
- Use real file system (temp directory)
- Test full cache lifecycle
- Verify LRU eviction behavior

### Performance Tests
- Test with large cache sizes (>500 MB)
- Measure eviction time
- Verify memory usage
