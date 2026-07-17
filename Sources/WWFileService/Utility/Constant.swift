//
//  Constant.swift
//  WWFileService
//
//  Created by William.Weng on 2026/7/17.
//

import AVFoundation

// 縮圖的時間單位分類
public enum TimeValueType {
    
    /// 使用秒數表示影片時間
    /// - Parameter seconds: 影片時間，單位為秒
    case seconds(_ seconds: Double)
    
    /// 使用 CMTime 表示影片時間
    /// - Parameter time: 影片時間點（`CMTime`）
    case time(_ time: CMTime)
}

// 處理影片時的相關錯誤
public enum VideoError: Error {
    
    /// 找不到影片軌道
    case noVideoTrack
}

// MARK: - LocalizedError (VideoError)
extension VideoError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .noVideoTrack: return "No video track"
        }
    }
}
