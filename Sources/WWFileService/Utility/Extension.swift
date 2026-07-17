//
//  extension.swift
//  WWFileService
//
//  Created by William.Weng on 2026/7/16.
//

import Foundation
import AVFoundation

// MARK: - FileManager
extension FileManager {
    
    /// 讀取指定資料夾第一層中「所有子資料夾」的 URL
    ///
    /// - Parameters:
    ///   - folderURL: 要讀取的目標資料夾
    ///   - skipsHiddenFiles: 是否略過隱藏檔案/資料夾
    /// - Returns: 該資料夾底下第一層的所有子資料夾 URL
    /// - Throws: 目錄不存在、無存取權限或讀取失敗時拋錯
    func directories(at folderURL: URL, skipsHiddenFiles: Bool) throws -> [URL] {
        
        let mask: DirectoryEnumerationOptions = skipsHiddenFiles ? [.skipsHiddenFiles] : []
        
        return try contentsOfDirectory(at: folderURL, includingPropertiesForKeys: [.isDirectoryKey], options: mask)
            .filter {
                $0.isDirectory == true
            }.sorted {
                $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
            }
    }
    
    /// 讀取指定資料夾第一層的所有項目 URL
    ///
    /// - Parameters:
    ///   - folderURL: 要讀取的目標資料夾
    ///   - keys: 預先想一起取回的 resource keys，例如建立時間、大小、是否為一般檔案
    ///   - skipsHiddenFiles: 是否略過隱藏檔
    /// - Returns: 該資料夾第一層所有項目的 URL
    /// - Throws: 讀取失敗時往外拋錯
    func files(at folderURL: URL, keys: [URLResourceKey]?, skipsHiddenFiles: Bool) throws -> [URL] {
        
        let mask: DirectoryEnumerationOptions = skipsHiddenFiles ? [.skipsHiddenFiles] : []
        return try contentsOfDirectory(at: folderURL, includingPropertiesForKeys: keys, options: mask)
            .sorted {
                $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
            }
    }
        
    /// 遞迴讀取指定資料夾底下所有一般檔案 URL（包含所有子資料夾）
    ///
    /// - Parameters:
    ///   - folderURL: 要掃描的根目錄
    ///   - skipsHiddenFiles: 是否略過隱藏檔案 / 隱藏資料夾
    /// - Returns: 該目錄以下所有「一般檔案」的 URL，並依檔名自然排序
    /// - Throws: 無法建立目錄列舉器時拋出錯誤
    func allFileURLs(at folderURL: URL, skipsHiddenFiles: Bool) throws -> [URL] {
        
        let keys: Set<URLResourceKey> = [.isRegularFileKey]
        let mask: FileManager.DirectoryEnumerationOptions = skipsHiddenFiles ? [.skipsHiddenFiles] : []
        
        guard let enumerator = enumerator(at: folderURL, includingPropertiesForKeys: Array(keys),options: mask) else { throw CocoaError(.fileReadUnknown) }
        
        return enumerator.compactMap { element in
            
            guard let url = element as? URL,
                  let values = try? url.resourceValues(forKeys: keys),
                  values.isRegularFile == true
            else {
                return nil
            }
            
            return url
        }.sorted {
            $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
        }
    }
    
    /// 遞迴讀取指定資料夾底下所有一般檔案資訊（包含所有子資料夾）
    ///
    /// - Parameters:
    ///   - folderURL: 要掃描的根目錄
    ///   - skipsHiddenFiles: 是否略過隱藏檔案 / 隱藏資料夾
    /// - Returns: 該目錄以下所有一般檔案的 FileItem，並依檔名自然排序
    /// - Throws: 無法建立目錄列舉器時拋出錯誤
    func allFileItems(at folderURL: URL, skipsHiddenFiles: Bool) throws -> [FileServiceItem] {
        
        let keys: Set<URLResourceKey> = [.isRegularFileKey, .creationDateKey, .fileSizeKey]
        let mask: DirectoryEnumerationOptions = skipsHiddenFiles ? [.skipsHiddenFiles] : []
        
        guard let enumerator = enumerator(at: folderURL, includingPropertiesForKeys: Array(keys), options: mask ) else { throw CocoaError(.fileReadUnknown) }
        
        return enumerator.compactMap { element in
            
            guard let url = element as? URL,
                  let values = try? url.resourceValues(forKeys: keys),
                  values.isRegularFile == true
            else {
                return nil
            }
            
            return .init(url: url, createdDate: values.creationDate, fileSize: Int64(values.fileSize ?? 0))
        }
        .sorted {
            $0.url.lastPathComponent.localizedStandardCompare($1.url.lastPathComponent) == .orderedAscending
        }
    }
}

// MARK: - URL
extension URL {
    
    /// 判斷目前 URL 指向的是否為資料夾
    /// - Returns:
    ///   - true：是資料夾
    ///   - false：不是資料夾
    ///   - nil：取值失敗或資源不存在
    var isDirectory: Bool?  {
        try? resourceValues(forKeys: [.isDirectoryKey]).isDirectory
    }
}

// MARK: - AVAssetImageGenerator
extension AVAssetImageGenerator {
    
    /// 建立 AVAssetImageGenerator
    /// - Parameters:
    ///   - url: 影片的 URL
    ///   - appliesPreferredTrackTransform: 是否套用影片軌道的 transform
    ///   - maximumSize: 縮圖的最大尺寸
    ///   - toleranceBefore: 允許在指定時間點「之前」偏移的最大時間
    ///   - toleranceAfter: 允許在指定時間點「之後」偏移的最大時間
    /// - Returns: 對應時間點的縮圖
    static func build(url: URL, appliesPreferredTrackTransform: Bool, maximumSize: CGSize, toleranceBefore: CMTime, toleranceAfter: CMTime) -> Self {
        
        let asset = AVURLAsset(url: url)
        let generator = Self(asset: asset)
        
        generator.appliesPreferredTrackTransform = appliesPreferredTrackTransform
        generator.maximumSize = maximumSize
        generator.requestedTimeToleranceBefore = toleranceBefore
        generator.requestedTimeToleranceAfter = toleranceAfter
        
        return generator
    }
}
