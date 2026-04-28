package com.example.wallpaper_app

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.wallpaperapp/wallpaper"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setWallpaper" -> {
                    val imagePath = call.argument<String>("imagePath")
                    val target = call.argument<String>("target")
                    
                    if (imagePath == null || target == null) {
                        result.error("INVALID_ARGUMENT", "Image path and target are required", null)
                        return@setMethodCallHandler
                    }
                    
                    try {
                        val success = setWallpaper(imagePath, target)
                        result.success(success)
                    } catch (e: Exception) {
                        result.error("SET_WALLPAPER_ERROR", e.message, null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun setWallpaper(imagePath: String, target: String): Boolean {
        return try {
            val wallpaperManager = WallpaperManager.getInstance(applicationContext)
            val imageFile = File(imagePath)
            
            if (!imageFile.exists()) {
                return false
            }
            
            val bitmap = BitmapFactory.decodeFile(imagePath)
            if (bitmap == null) {
                return false
            }
            
            when (target) {
                "homeScreen" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                    } else {
                        wallpaperManager.setBitmap(bitmap)
                    }
                }
                "lockScreen" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                    } else {
                        // Lock screen wallpaper not supported on older versions
                        wallpaperManager.setBitmap(bitmap)
                    }
                }
                "both" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK)
                    } else {
                        wallpaperManager.setBitmap(bitmap)
                    }
                }
                else -> return false
            }
            
            bitmap.recycle()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
