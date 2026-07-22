[English](./README.en.md) | [繁體中文](./README.md)

# [WWFileService](https://swiftpackageindex.com/William-Weng)

[![Swift-5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://developer.apple.com/swift/)
[![iOS-17.0+](https://img.shields.io/badge/iOS-17.0+-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWFileService)
![SwiftUI](https://img.shields.io/badge/SwiftUI-supported-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

輕量、偏實戰取向的檔案工具集合，從原本的資料夾掃描與檔案操作，進一步延伸到 **視訊 / 音訊資訊讀取**。`WWFileService` 以 `enum + static func` 設計，沒有共享狀態，適合直接整合到 App、Framework 或 Swift Package 裡，當成穩定的本地檔案基礎工具層。

現在除了常見的 `FileManager` 包裝之外，也能直接處理媒體檔常見需求，像是影片縮圖、影片長度 / 尺寸、音訊資訊等，讓「檔案掃描 → 列表建立 → 媒體資訊顯示」這條流程可以用同一套 API 完成。

![Example](https://github.com/user-attachments/assets/ca932723-39e0-4f38-854a-ddbdb7f70318)

## 🚀 [功能特色](https://peterpanswift.github.io/iphone-bezels/)

- Pure Foundation 風格為主，API 命名集中，整合成本低。
- `enum` 命名空間設計，沒有共享狀態，適合工具型套件。
- 支援第一層掃描與遞迴掃描兩種模式，可依情境選擇效能與範圍。
- 支援副檔名過濾，例如 `mp4`、`mov`、`m4v`、`mp3`、`m4a`。
- 支援 `FileServiceItem`，方便直接綁定清單 UI，顯示名稱、日期、大小等欄位。
- 新增視訊 / 音訊資訊取得能力，適合播放器、媒體庫、匯入流程與資源索引。
- 支援從影片擷取縮圖，方便快速建立預覽卡片或封面圖。

## 📦 API 功能表

### 資料夾 / 檔案掃描

| 名稱 | 回傳值 | 範圍 | 過濾 | 說明 |
|---|---|---|---|---|
| `folderUrls(at:skipsHiddenFiles:)` | `[URL]` | 第一層 | 只取資料夾 | 讀取指定資料夾底下的第一層子資料夾 URL，並排序。  |
| `folderNames(at:skipsHiddenFiles:)` | `[String]` | 第一層 | 只取資料夾 | 讀取指定資料夾底下的第一層子資料夾名稱，並排序。  |
| `fileUrls(at:allowedExtensions:skipsHiddenFiles:)` | `[URL]` | 第一層 | 一般檔案 + 副檔名 | 讀取指定資料夾底下符合副檔名條件的檔案 URL。  |
| `fileNames(at:allowedExtensions:skipsHiddenFiles:)` | `[String]` | 第一層 | 一般檔案 + 副檔名 | 讀取指定資料夾底下符合條件的檔名。  |
| `fileItem(at:allowedExtensions:skipsHiddenFiles:)` | `FileServiceItem?` | 單一檔案 | 一般檔案 + 副檔名 | 讀取指定檔案資訊；若符合條件則回傳 URL、建立時間與檔案大小。  |
| `fileItems(at:allowedExtensions:skipsHiddenFiles:)` | `[FileServiceItem]` | 第一層 | 一般檔案 + 副檔名 | 讀取指定資料夾底下符合條件的檔案資訊，適合直接餵給列表 UI。  |
| `allFileUrls(at:skipsHiddenFiles:)` | `[URL]` | 遞迴 | 一般檔案 | 遞迴掃描指定資料夾與所有子資料夾，回傳所有一般檔案 URL。  |
| `allFileItems(at:skipsHiddenFiles:)` | `[FileServiceItem]` | 遞迴 | 一般檔案 | 遞迴掃描指定資料夾與所有子資料夾，回傳所有一般檔案資訊。  |

### 檔案操作

| 名稱 | 回傳值 | 說明 |
|---|---|---|
| `fileExists(at:)` | `Bool` | 檢查指定路徑的檔案或資料夾是否存在。  |
| `createDirectory(at:withIntermediateDirectories:)` | `Void` | 建立資料夾。  |
| `write(_:to:)` | `Void` | 將 `Data` 寫入指定位置。  |
| `write(_:to:encoder:)` | `Void` | 將 `Encodable` 物件編碼後寫入 JSON 檔。  |
| `readData(from:)` | `Data` | 讀取指定檔案的原始資料。  |
| `read(_:from:decoder:)` | `T` | 讀取並解碼指定型別。  |
| `moveItem(at:to:)` | `Void` | 將檔案或資料夾移動到新位置。  |
| `renameItem(at:to:)` | `URL` | 重新命名檔案，並回傳新的 URL。  |
| `copyItem(at:to:)` | `Void` | 複製檔案到指定位置。  |
| `deleteItem(at:)` | `Void` | 刪除指定檔案或資料夾。  |

### 視訊

| 名稱 | 回傳值 | 說明 |
|---|---|---|
| `videoThumbnail(for:at:maximumSize:preferredTimescale:toleranceBefore:toleranceAfter:)` | `UIImage` | 從影片擷取指定時間點的縮圖，適合做列表封面、時間軸預覽與播放器預覽圖。  |
| `videoInformation(for:)` | `VideoInfo` | 取得影片資訊，例如長度與尺寸，方便顯示片長、解析度與版面比例。  |

### 音訊

| 名稱 | 回傳值 | 說明 |
|---|---|---|
| `audioInformation(for:)` | `AudioInformation` | 取得音訊檔案資訊，適合建立播放清單、顯示音訊 metadata 或匯入檢查。  |

## 🔍 使用定位

`WWFileService` 現在不只是「找檔案」而已，也很適合當作本地媒體 App 的基礎服務層。當需求包含影片列表、音樂清單、語音教材匯入、課程媒體管理時，可以先用掃描 API 找到檔案，再接著用媒體資訊 API 補齊 UI 所需欄位。

常見流程會像這樣：先用 `fileItems(...)` 或 `allFileItems(...)` 建立資料來源，再針對實際要顯示的影片呼叫 `videoInformation(for:)` / `videoThumbnail(...)`，或對音訊呼叫 `audioInformation(for:)`。這種拆法能讓列表掃描與媒體解析的責任分離，結構會更清楚。

## 🛠️ 函式細節

### `folderNames(at:skipsHiddenFiles:)`

讀取指定資料夾底下的第一層子資料夾名稱，不會往下遞迴。適合用在分類列表、章節入口或匯入來源分頁。

```swift
let names = try WWFileService.folderNames(
    at: folderURL,
    skipsHiddenFiles: true
)
```

### `fileItems(at:allowedExtensions:skipsHiddenFiles:)`

回傳 `FileServiceItem` 陣列，適合直接綁定列表畫面。當 UI 需要名稱、建立時間、檔案大小，又不想自己整理 `URLResourceValues` 時，這個 API 最省事。

```swift
let items = try WWFileService.fileItems(
    at: folderURL,
    allowedExtensions: ["mp4", "mov", "m4a", "mp3"],
    skipsHiddenFiles: true
)
```

### `allFileItems(at:skipsHiddenFiles:)`

遞迴掃描整個資料夾樹，回傳全部一般檔案資訊。適合做媒體庫索引、教材資料夾整理、離線資源搜尋或批次分析。

```swift
let items = try WWFileService.allFileItems(
    at: rootURL,
    skipsHiddenFiles: true
)
```

### `videoThumbnail(for:at:maximumSize:preferredTimescale:toleranceBefore:toleranceAfter:)`

從影片擷取縮圖，適合用在影片卡片、課程章節封面、播放器 seek 預覽圖。若需要控制縮圖畫質、取樣時間點或生成速度，這個 API 的參數彈性會很實用。

```swift
let image = try await WWFileService.videoThumbnail(
    for: videoURL,
    at: .zero,
    maximumSize: CGSize(width: 480, height: 270),
    preferredTimescale: 600,
    toleranceBefore: .zero,
    toleranceAfter: .zero
)
```

### `videoInformation(for:)`

讀取影片資訊，適合在 UI 上顯示片長、尺寸或後續推導比例。這對播放器列表、影片匯入檢查、影音教材管理都很常用。

```swift
let info = try await WWFileService.videoInformation(for: videoURL)

print(info.duration)
print(info.size)
```

### `audioInformation(for:)`

讀取音訊檔資訊，適合播放清單、語音教材、錄音管理與匯入檢查。當 App 需要先知道音訊長度或其他 metadata 再決定 UI 呈現時，這個 API 很直接。

```swift
let info = try await WWFileService.audioInformation(for: audioURL)
```

## 🧩 使用範例

### 建立影片列表並補上影片資訊

```swift
let rootURL = URL.documentsDirectory.appendingPathComponent("Videos", isDirectory: true)

let items = try WWFileService.fileItems(
    at: rootURL,
    allowedExtensions: ["mp4", "mov", "m4v"],
    skipsHiddenFiles: true
)

let details = try await withThrowingTaskGroup(of: (URL, VideoInfo).self) { group in
    for item in items {
        group.addTask {
            let info = try await WWFileService.videoInformation(for: item.url)
            return (item.url, info)
        }
    }

    var result: [(URL, VideoInfo)] = []

    for try await value in group {
        result.append(value)
    }

    return result
}
```

### 讀取音訊教材並建立播放清單

```swift
let audioFolderURL = URL.documentsDirectory.appendingPathComponent("Lessons", isDirectory: true)

let audios = try WWFileService.fileItems(
    at: audioFolderURL,
    allowedExtensions: ["mp3", "m4a", "wav"],
    skipsHiddenFiles: true
)

for item in audios {
    let info = try await WWFileService.audioInformation(for: item.url)
    print(item.url.lastPathComponent, info)
}
```

### 建立影片縮圖清單

```swift
let urls = try WWFileService.fileUrls(
    at: rootURL,
    allowedExtensions: ["mp4", "mov"],
    skipsHiddenFiles: true
)

for url in urls {
    let thumbnail = try await WWFileService.videoThumbnail(
        for: url,
        at: .seconds(1.0),
        maximumSize: CGSize(width: 320, height: 180)
    )

    print(thumbnail)
}
```

## ⚠️ 注意事項

- `folderNames(...)`、`fileUrls(...)`、`fileNames(...)`、`fileItems(...)` 都只處理第一層；`allFileUrls(...)`、`allFileItems(...)` 會遞迴掃描整個資料夾樹。
- `allowedExtensions` 會統一轉成小寫比對，所以 `MP4`、`Mp4`、`mp4` 都能正常處理。
- `allFileUrls(...)` / `allFileItems(...)` 只回傳一般檔案，不包含資料夾、symbolic link 與其他特殊檔案。
- 媒體資訊讀取建議放在真正需要顯示或分析的時機點，避免在大量掃描時一次解析全部影片 / 音訊，影響初始化體感。
- 如果你的列表 UI 同時需要檔案資訊與媒體資訊，建議把 `FileServiceItem` 當作基礎資料模型，再額外快取 `VideoInfo` / `AudioInformation`。

## ✅ 適用情境

- SwiftUI 影片列表與封面預覽
- 本地音樂 / Podcast / 錄音播放器
- 語言學習 App 的音訊教材管理
- Documents / Inbox 媒體匯入流程
- 離線影片課程管理
- 本地媒體索引與批次掃描
- 播放器前處理，例如片長、尺寸與縮圖建立
