//
//  FileItem.swift
//  WWFileService
//
//  Created by William.Weng on 2026/7/16.
//

import Foundation

/// 單一檔案的基本資訊
public struct FileItem: Identifiable {
    
    public var id = UUID()
    
    let url: URL            // 檔案完整路徑
    let createdDate: Date?  // 建立日期
    let fileSize: Int64     // 檔案大小(byte)
}
