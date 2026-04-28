import 'package:equatable/equatable.dart';

/// Status of a download operation
enum DownloadStatus { pending, downloading, completed, failed }

/// Represents the progress of a wallpaper download
class DownloadProgress extends Equatable {
  final String wallpaperId;
  final int bytesReceived;
  final int totalBytes;
  final DownloadStatus status;
  final String? errorMessage;

  const DownloadProgress({
    required this.wallpaperId,
    required this.bytesReceived,
    required this.totalBytes,
    required this.status,
    this.errorMessage,
  });

  /// Calculate download progress as a percentage (0.0 to 1.0)
  double get progress => totalBytes > 0 ? bytesReceived / totalBytes : 0.0;

  /// Calculate download progress as a percentage (0 to 100)
  int get progressPercentage => (progress * 100).round();

  /// Check if download is complete
  bool get isCompleted => status == DownloadStatus.completed;

  /// Check if download is in progress
  bool get isDownloading => status == DownloadStatus.downloading;

  /// Check if download has failed
  bool get isFailed => status == DownloadStatus.failed;

  /// Create a copy with updated fields
  DownloadProgress copyWith({
    String? wallpaperId,
    int? bytesReceived,
    int? totalBytes,
    DownloadStatus? status,
    String? errorMessage,
  }) {
    return DownloadProgress(
      wallpaperId: wallpaperId ?? this.wallpaperId,
      bytesReceived: bytesReceived ?? this.bytesReceived,
      totalBytes: totalBytes ?? this.totalBytes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    wallpaperId,
    bytesReceived,
    totalBytes,
    status,
    errorMessage,
  ];
}
