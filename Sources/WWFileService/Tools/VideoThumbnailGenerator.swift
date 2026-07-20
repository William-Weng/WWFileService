//
//  VideoThumbnailGenerator.swift
//  WWFileService
//
//  Created by William.Weng on 2026/7/17.
//

import AVFoundation
import UIKit

/// 負責從影片 URL 產生縮圖的 Utility
struct VideoThumbnailGenerator {
    
    let generator: AVAssetImageGenerator
    let preferredTimescale: CMTimeScale
    
    /// 建立影片縮圖產生器
    /// - Parameters:
    ///   - url: 影片的 URL
    ///   - appliesPreferredTrackTransform: 是否套用影片軌道的 transform（預設為 true）
    ///   - maximumSize: 縮圖的最大尺寸
    ///   - preferredTimescale: 建立時間點時使用的 timeScale
    ///   - toleranceBefore: 允許在指定時間點「之前」偏移的最大時間
    ///   - toleranceAfter: 允許在指定時間點「之後」偏移的最大時間
    init(url: URL, appliesPreferredTrackTransform: Bool = true, maximumSize: CGSize, preferredTimescale: CMTimeScale, toleranceBefore: CMTime, toleranceAfter: CMTime) {
        
        self.preferredTimescale = preferredTimescale
        self.generator = .build(url: url, appliesPreferredTrackTransform: appliesPreferredTrackTransform, maximumSize: maximumSize, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter)
    }
}

// MARK: 公開API（同步）
extension VideoThumbnailGenerator {
    
    /// 取得指定秒數的縮圖（同步）
    /// - Parameter seconds: 影片時間，單位為秒
    /// - Returns: 對應時間點的縮圖
    func thumbnail(at seconds: Double) throws -> UIImage {
        let time = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
        return try thumbnail(at: time)
    }
    
    /// 取得指定時間點的縮圖（同步）
    /// - Parameter time: 影片時間點（`CMTime`）
    /// - Returns: 對應時間點的縮圖
    func thumbnail(at time: CMTime) throws -> UIImage {
        let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
        return UIImage(cgImage: cgImage)
    }
}

// MARK: 公開API（非同步）
extension VideoThumbnailGenerator {
    
    /// 取得指定秒數的縮圖（非同步）
    /// - Parameter seconds: 影片時間，單位為秒
    /// - Returns: 對應時間點的縮圖
    func thumbnail(at seconds: Double) async throws -> UIImage {
        
        let time = CMTime(seconds: seconds, preferredTimescale: preferredTimescale)
        return try await thumbnail(at: time)
    }
    
    /// 取得指定時間點的縮圖（非同步）
    /// - Parameter time: 影片時間點（`CMTime`）
    /// - Returns: 對應時間點的縮圖
    func thumbnail(at time: CMTime) async throws -> UIImage {
                
        return try await withCheckedThrowingContinuation { continuation in
            
            Task.detached {
                
                do {
                    let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
                    let image = UIImage(cgImage: cgImage)
                    continuation.resume(returning: image)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
