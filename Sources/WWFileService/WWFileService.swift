//
//  WWFileService.swift
//  WWFileService
//
//  Created by William.Weng on 2026/7/16.
//

import UIKit
import AVFoundation

/// 檔案相關功能大集合
public enum WWFileService {}

// MARK: - 公開API (資料夾)
public extension WWFileService {
    
    /// 取得指定資料夾底下「第一層子資料夾URL」
    ///
    /// - Parameters:
    ///   - folderURL: 目標資料夾
    ///   - skipsHiddenFiles: 是否略過隱藏檔
    /// - Returns: 子資料夾名稱陣列，已排序
    /// - Throws: 讀取失敗時往外拋錯
    static func folderUrls(at folderURL: URL, skipsHiddenFiles: Bool) throws -> [URL] {
        try FileManager.default.directories(at: folderURL, skipsHiddenFiles: skipsHiddenFiles)
    }
    
    /// 取得指定資料夾底下「第一層子資料夾名稱」
    ///
    /// - Parameters:
    ///   - folderURL: 目標資料夾
    ///   - skipsHiddenFiles: 是否略過隱藏檔
    /// - Returns: 子資料夾名稱陣列，已排序
    /// - Throws: 讀取失敗時往外拋錯
    static func folderNames(at folderURL: URL, skipsHiddenFiles: Bool) throws -> [String] {
        
        try FileManager.default.directories(at: folderURL, skipsHiddenFiles: skipsHiddenFiles)
            .map { $0.lastPathComponent }
    }
}

// MARK: - 公開API (檔案)
public extension WWFileService {
    
    /// 取得指定資料夾底下符合副檔名條件的檔案 URL。
    ///
    /// - Parameters:
    ///   - folderURL: 目標資料夾
    ///   - allowedExtensions: 允許的副檔名，例如 ["mp4", "mov"]
    ///   - skipsHiddenFiles: 是否略過隱藏檔
    /// - Returns: 符合條件的檔案 URL 陣列
    /// - Throws: 讀取失敗時往外拋錯
    static func fileUrls(at folderURL: URL, allowedExtensions: Set<String>, skipsHiddenFiles: Bool) throws -> [URL] {
        
        let keys: Set<URLResourceKey> = [.isRegularFileKey]
        let extensions = Set(allowedExtensions.map { $0.lowercased() })
        let urls = try FileManager.default.files(at: folderURL, keys: Array(keys), skipsHiddenFiles: skipsHiddenFiles)
        
        return urls.compactMap { url in
            
            guard extensions.contains(url.pathExtension.lowercased()),
                  let values = try? url.resourceValues(forKeys: keys),
                  values.isRegularFile == true
            else {
                return nil
            }
            
            return url
        }
    }
    
    /// 取得指定資料夾底下符合條件的檔名
    ///
    /// - Parameters:
    ///   - folderURL: 目標資料夾
    ///   - allowedExtensions: 允許副檔名
    ///   - skipsHiddenFiles: 是否略過隱藏檔
    /// - Returns: 檔名陣列
    /// - Throws: 讀取失敗時往外拋錯
    static func fileNames(at folderURL: URL, allowedExtensions: Set<String>, skipsHiddenFiles: Bool) throws -> [String] {
        
        try fileUrls(at: folderURL, allowedExtensions: allowedExtensions, skipsHiddenFiles: skipsHiddenFiles).map { url in
            url.lastPathComponent
        }
    }
    
    /// 取得指定資料夾底下符合條件的檔案資訊
    ///
    /// - Parameters:
    ///   - folderURL: 目標資料夾
    ///   - allowedExtensions: 允許副檔名
    ///   - skipsHiddenFiles: 是否略過隱藏檔
    /// - Returns: FileItem 陣列
    /// - Throws: 讀取失敗時往外拋錯
    static func fileItems(at folderURL: URL, allowedExtensions: Set<String>, skipsHiddenFiles: Bool) throws -> [FileServiceItem] {
        
        let keys: Set<URLResourceKey> = [.creationDateKey, .fileSizeKey, .isRegularFileKey]
        let extensions = Set(allowedExtensions.map { $0.lowercased() })
        let urls = try FileManager.default.files(at: folderURL, keys: Array(keys), skipsHiddenFiles: skipsHiddenFiles)
        
        return urls.compactMap { url in
            
            guard extensions.contains(url.pathExtension.lowercased()),
                  let values = try? url.resourceValues(forKeys: keys),
                  values.isRegularFile != false
            else {
                return nil
            }
            
            return .init(url: url, createdDate: values.creationDate, fileSize: Int64(values.fileSize ?? 0))
        }
    }
    
    /// 遞迴讀取指定資料夾底下所有一般檔案 URL（包含所有子資料夾）
    ///
    /// - Parameters:
    ///   - folderURL: 要掃描的根目錄
    ///   - skipsHiddenFiles: 是否略過隱藏檔案 / 隱藏資料夾
    /// - Returns: 該目錄以下所有「一般檔案」的 URL，並依檔名自然排序
    /// - Throws: 無法建立目錄列舉器時拋出錯誤
    static func allFileUrls(at folderURL: URL, skipsHiddenFiles: Bool) throws -> [URL] {
        try FileManager.default.allFileURLs(at: folderURL, skipsHiddenFiles: skipsHiddenFiles)
    }
    
    /// 遞迴讀取指定資料夾底下所有一般檔案資訊（包含所有子資料夾）
    ///
    /// - Parameters:
    ///   - folderURL: 要掃描的根目錄
    ///   - skipsHiddenFiles: 是否略過隱藏檔案 / 隱藏資料夾
    /// - Returns: 該目錄以下所有一般檔案的 FileItem，並依檔名自然排序
    /// - Throws: 無法建立目錄列舉器時拋出錯誤
    static func allFileItems(at folderURL: URL, skipsHiddenFiles: Bool) throws -> [FileServiceItem] {
        try FileManager.default.allFileItems(at: folderURL, skipsHiddenFiles: skipsHiddenFiles)
    }
}

// MARK: - 公開API (影片)
public extension WWFileService {
    
    /// 從影片取得縮圖
    /// - Parameters:
    ///   - url: 影片的 URL
    ///   - valueType: 影片時間的表示方式（秒數或 CMTime）
    ///   - maximumSize: 縮圖的最大尺寸
    ///   - preferredTimescale: 建立時間點時使用的 timeScale（預設為 600）
    ///   - toleranceBefore: 允許在指定時間點「之前」偏移的最大時間（預設為 .zero）
    ///   - toleranceAfter: 允許在指定時間點「之後」偏移的最大時間（預設為 .zero）
    /// - Returns: 對應時間點的縮圖
    static func videoThumbnail(for url: URL, at valueType: TimeValueType, maximumSize: CGSize, preferredTimescale: CMTimeScale = 600, toleranceBefore: CMTime = .zero, toleranceAfter: CMTime = .zero) async throws -> UIImage {
        
        let generator = VideoThumbnailGenerator(url: url, maximumSize: maximumSize, preferredTimescale: preferredTimescale, toleranceBefore: toleranceBefore, toleranceAfter: toleranceAfter)
                
        switch valueType {
        case .seconds(let seconds): return try await generator.thumbnail(at: seconds)
        case .time(let time): return try await generator.thumbnail(at: time)
        }
    }
    
    /// 取得影片的長度與尺寸
    /// - Parameter url: 影片的 URL
    /// - Returns: 影片長度（秒）與尺寸 (像素)
    static func videoInformation(for url: URL) async throws -> VideoInfo {
        
        let asset = AVURLAsset(url: url)
        try await asset.load(.duration)
        let tracks = try await asset.load(.tracks)
        
        guard let videoTrack = tracks.first(where: { $0.mediaType == .video }) else { throw VideoError.noVideoTrack }
        
        let naturalSize = try await videoTrack.load(.naturalSize)
        let preferredTransform = try await videoTrack.load(.preferredTransform)
        
        let correctedSize = naturalSize.applying(preferredTransform)
        let durationSeconds = CMTimeGetSeconds(asset.duration)
        
        return .init(durationSeconds: durationSeconds, size: correctedSize)
    }
}
