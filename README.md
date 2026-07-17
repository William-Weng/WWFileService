[English](./README.en.md) | [繁體中文](./README.md)

# [WWFileService](https://swiftpackageindex.com/William-Weng)

[![Swift-5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://developer.apple.com/swift/)
[![iOS-17.0+](https://img.shields.io/badge/iOS-17.0+-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWFileService)
![SwiftUI](https://img.shields.io/badge/SwiftUI-supported-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

輕量、純 `Foundation` 的檔案工具集合，專門整理「資料夾、檔案、遞迴掃描、檔案資訊」這幾種常見需求。`WWFileService` 以 `enum + static func` 設計，沒有共享狀態，呼叫簡單，也很適合放進 App、Framework 或 Swift Package 中重用。

它的核心目標是把 `FileManager` 常見但偏零散的操作，整理成一致、可讀、可維護的 API，包含：

- 讀取第一層子資料夾名稱
- 讀取第一層符合副檔名的檔案 URL / 檔名 / 檔案資訊
- 遞迴讀取整個目錄樹下的所有一般檔案 URL / 檔案資訊
- 支援略過隱藏檔案與隱藏資料夾

![Example](https://github.com/user-attachments/assets/ca932723-39e0-4f38-854a-ddbdb7f70318)

## 🚀 [功能特色](https://peterpanswift.github.io/iphone-bezels/)
- Pure Foundation，沒有額外依賴
- `enum` 命名空間設計，API 乾淨
- 支援第一層與遞迴兩種掃描模式
- 支援副檔名過濾，例如 `mp4`、`mov`、`m4v`
- 支援 `FileItem` 回傳，方便直接綁 UI
- 適合影片列表、檔案總管、媒體管理、匯入流程

## 📦 API 功能表

### 資料夾

| 名稱 | 回傳值 | 範圍 | 過濾 | 說明 |
|---|---|---|---|---|
| `folderUrls(at:skipsHiddenFiles:)` | `[URL]` | 第一層 | 只取資料夾 | 讀取指定資料夾底下的第一層子資料夾 URL，並排序。 |
| `folderNames(at:skipsHiddenFiles:)` | `[String]` | 第一層 | 只取資料夾 | 讀取指定資料夾底下的第一層子資料夾名稱，並排序。 |
| `fileUrls(at:allowedExtensions:skipsHiddenFiles:)` | `[URL]` | 第一層 | 一般檔案 + 副檔名 | 讀取指定資料夾底下符合副檔名條件的檔案 URL。 |
| `fileNames(at:allowedExtensions:skipsHiddenFiles:)` | `[String]` | 第一層 | 一般檔案 + 副檔名 | 讀取指定資料夾底下符合條件的檔名。 |
| `fileItems(at:allowedExtensions:skipsHiddenFiles:)` | `[FileServiceItem]` | 第一層 | 一般檔案 + 副檔名 | 讀取指定資料夾底下符合條件的檔案資訊，包含 URL、建立時間、檔案大小。 |
| `allFileUrls(at:skipsHiddenFiles:)` | `[URL]` | 遞迴 | 一般檔案 | 遞迴掃描指定資料夾與所有子資料夾，回傳所有一般檔案 URL。 |
| `allFileItems(at:skipsHiddenFiles:)` | `[FileServiceItem]` | 遞迴 | 一般檔案 | 遞迴掃描指定資料夾與所有子資料夾，回傳所有一般檔案資訊。 |

### 影片

| 名稱 | 回傳值  | 說明 |
|---|---|---|
| `videoThumbnail(for:at:maximumSize:preferredTimescale:toleranceBefore:toleranceAfter:)` | `UIImage` | 從影片取得縮圖。 |
| `videoInformation(for:)` | `UIImage` | 取得影片的長度與尺寸。 |

## 🔍 函式細節

### `folderNames(at:skipsHiddenFiles:)`

讀取指定資料夾底下的第一層子資料夾名稱，不會往下遞迴。適合用在「分類列表」、「資料夾分頁」、「目錄入口」這類 UI。

```swift
let names = try WWFileService.folderNames(
    at: folderURL,
    skipsHiddenFiles: true
)
```

### `fileUrls(at:allowedExtensions:skipsHiddenFiles:)`

讀取指定資料夾底下第一層符合副檔名條件的檔案 URL。這個 API 適合你已經只需要路徑，後續會自己處理 metadata 或播放器載入的情境。

```swift
let urls = try WWFileService.fileUrls(
    at: folderURL,
    allowedExtensions: ["mp4", "mov", "m4v"],
    skipsHiddenFiles: true
)
```

### `fileNames(at:allowedExtensions:skipsHiddenFiles:)`

這是 `fileUrls(...)` 的檔名版，直接回傳 `lastPathComponent`。如果 UI 只需要顯示名稱，不需要 URL 或 metadata，這個 API 最簡單。

```swift
let names = try WWFileService.fileNames(
    at: folderURL,
    allowedExtensions: ["mp4", "mov"],
    skipsHiddenFiles: true
)
```

### `fileItems(at:allowedExtensions:skipsHiddenFiles:)`

回傳自訂 `FileItem`，適合直接綁定列表畫面。通常 `FileItem` 會至少包含 `url`、`createdDate`、`fileSize`，因此很適合影片列表、下載列表、匯入頁面等需要顯示附加資訊的情境。

```swift
let items = try WWFileService.fileItems(
    at: folderURL,
    allowedExtensions: ["mp4", "mov"],
    skipsHiddenFiles: true
)
```

### `allFileUrls(at:skipsHiddenFiles:)`

遞迴掃描指定資料夾底下的所有子資料夾，回傳全部一般檔案 URL。適合做全目錄搜尋、媒體庫建立、批次處理等功能。

```swift
let urls = try WWFileService.allFileUrls(
    at: folderURL,
    skipsHiddenFiles: true
)
```

### `allFileItems(at:skipsHiddenFiles:)`

這是遞迴版的 `FileItem` API。當你要建立整個資料夾樹的檔案列表，並直接顯示時間、大小、排序資訊時，這個版本最方便。

```swift
let items = try WWFileService.allFileItems(
    at: folderURL,
    skipsHiddenFiles: true
)
```

## 🛠️ 使用範例

### 從 Documents 讀取影片

```swift
let documentsURL = URL.documentsDirectory

let videos = try WWFileService.fileItems(
    at: documentsURL,
    allowedExtensions: ["mp4", "mov", "m4v"],
    skipsHiddenFiles: true
)
```

### 遞迴讀取所有影片

```swift
let documentsURL = URL.documentsDirectory
let rootURL = documentsURL.appendingPathComponent("Videos", isDirectory: true)

let allVideos = try WWFileService.allFileItems(
    at: rootURL,
    skipsHiddenFiles: true
)
```

## ⚠️ 注意事項

- `folderNames(...)`、`fileUrls(...)`、`fileNames(...)`、`fileItems(...)` 都只處理**第一層**。
- `allFileUrls(...)`、`allFileItems(...)` 會做**遞迴掃描**。
- `allowedExtensions` 會統一轉小寫比對，因此 `MP4` 與 `mp4` 都能正確處理。
- `allFileUrls(...)` / `allFileItems(...)` 只回傳一般檔案，不包含資料夾、symbolic link 與其他特殊檔案。
- 如果要建立影片播放器列表，通常建議直接使用 `fileItems(...)` 或 `allFileItems(...)`，因為 UI 通常同時需要名稱、日期與大小。

## ✅ 適用情境

- SwiftUI 影片列表
- Documents / Inbox 檔案匯入
- 媒體管理器
- 本地檔案瀏覽器
- 批次檔案掃描
- 音訊 / 影片資源索引

