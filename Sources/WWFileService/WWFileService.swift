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

// MARK: - 公開 API (CRUD)
public extension WWFileService {
    
    /// 檢查指定路徑的檔案或資料夾是否存在
    /// - Parameter url: 要檢查的目標 URL
    /// - Returns: 若存在則回傳 `true`，否則回傳 `false`
    static func fileExists(at url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
    
    /// 建立資料夾
    /// - Parameters:
    ///   - url: 要建立的資料夾 URL
    ///   - withIntermediateDirectories: 是否自動建立中間層資料夾
    static func createDirectory(at url: URL, withIntermediateDirectories: Bool = true) throws {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: withIntermediateDirectories)
    }
    
    /// 將原始資料寫入指定位置
    /// - Parameters:
    ///   - data: 要寫入的資料
    ///   - url: 目的地 URL
    /// - Note: 使用 `.atomic` 可減少寫入過程中檔案損毀的風險
    static func write(_ data: Data, to url: URL) throws {
        try data.write(to: url, options: [.atomic])
    }
    
    /// 將可編碼物件編碼後寫入指定位置
    /// - Parameters:
    ///   - value: 要寫入的可編碼物件
    ///   - url: 目的地 URL
    ///   - encoder: JSON 編碼器，預設為 `JSONEncoder()`
    static func write<T: Encodable>(_ value: T, to url: URL, encoder: JSONEncoder = .init()) throws {
        let data = try encoder.encode(value)
        try write(data, to: url)
    }
    
    /// 從指定 URL 讀取原始資料
    ///
    /// - Parameter url: 檔案位置（通常為本地 file URL）
    /// - Returns: 讀取到的 `Data`
    /// - Throws: 當檔案不存在、無權限或讀取失敗時拋出錯誤
    static func readData(from url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
    
    /// 從指定 URL 讀取 JSON 並解碼成指定型別
    ///
    /// - Parameters:
    ///   - type: 目標解碼型別（需符合 `Decodable`）
    ///   - url: 檔案位置（通常為本地 JSON 檔）
    ///   - decoder: 自訂 `JSONDecoder`（預設為新的實例）
    /// - Returns: 解碼後的物件
    /// - Throws:
    ///   - 檔案讀取失敗（來自 `readData`）
    ///   - JSON 結構不符或解碼失敗
    ///
    /// - Note: 可透過傳入自訂 `decoder` 設定日期格式、key decoding strategy 等
    static func read<T: Decodable>(_ type: T.Type, from url: URL, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        let data = try readData(from: url)
        return try decoder.decode(T.self, from: data)
    }
    
    /// 將檔案從原位置移動到新位置
    /// - Parameters:
    ///   - url: 原始檔案 URL
    ///   - newURL: 新位置 URL
    static func moveItem(at url: URL, to newURL: URL) throws {
        try FileManager.default.moveItem(at: url, to: newURL)
    }
    
    /// 重新命名檔案
    /// - Parameters:
    ///   - url: 原始檔案 URL
    ///   - newName: 新檔名，需包含副檔名
    /// - Returns: 重新命名後的新 URL
    static func renameItem(at url: URL, to newName: String) throws -> URL {
        
        let newURL = url.deletingLastPathComponent().appendingPathComponent(newName)
        try moveItem(at: url, to: newURL)
        
        return newURL
    }
    
    /// 複製檔案到指定位置
    /// - Parameters:
    ///   - url: 原始檔案 URL
    ///   - newURL: 複製目的地 URL
    static func copyItem(at url: URL, to newURL: URL) throws {
        try FileManager.default.copyItem(at: url, to: newURL)
    }
    
    /// 刪除指定檔案或資料夾
    /// - Parameter url: 要刪除的目標 URL
    /// - Throws: `ServiceError.fileNotFound` 當目標不存在時
    static func deleteItem(at url: URL) throws {
        
        guard fileExists(at: url) else { throw ServiceError.fileNotFound }
        try FileManager.default.removeItem(at: url)
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
        
        guard let videoTrack = tracks.first(where: { $0.mediaType == .video }) else { throw ServiceError.noVideoTrack }
        
        let naturalSize = try await videoTrack.load(.naturalSize)
        let preferredTransform = try await videoTrack.load(.preferredTransform)
        
        let correctedSize = naturalSize.applying(preferredTransform)
        let durationSeconds = CMTimeGetSeconds(asset.duration)
        
        return .init(durationSeconds: durationSeconds, size: correctedSize)
    }
}
