//
//  Model.swift
//  WWFileService
//
//  Created by William.Weng on 2026/7/16.
//

import Foundation

/// 單一檔案的基本資訊
public struct FileServiceItem: Identifiable, Hashable {
    
    public var id = UUID()
    
    public let url: URL                 // 檔案完整路徑
    public let createdDate: Date?       // 建立日期
    public let fileSize: Int64          // 檔案大小(byte)
}

/// 視訊檔案的資訊模型
public struct VideoInfo: Identifiable, Hashable {
    
    public var id = UUID()
    
    public let durationSeconds: Double  // 影片長度（秒）
    public let size: CGSize             // 影片原始寬高（像素）

}

/// 音訊檔案的資訊模型
public struct AudioInformation: Identifiable, Hashable {
    
    public var id = UUID()
    
    public let title: String?           // 音訊標題，可能來自檔案 metadata
    public let artist: String?          // 演出者名稱，可能來自檔案 metadata
    public let albumTitle: String?      // 專輯名稱，可能來自檔案 metadata
    public let durationSeconds: Double  // 音訊長度，單位為秒
    public let sampleRate: Double       // 取樣率，單位為 Hz
    public let channelCount: UInt32     // 聲道數，例如 1 代表單聲道、2 代表雙聲道
}
