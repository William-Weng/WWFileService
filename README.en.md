[English](./README.en.md) | [繁體中文](./README.md)

# [WWFileService](https://swiftpackageindex.com/William-Weng)

[![Swift-5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://developer.apple.com/swift/)
[![iOS-17.0+](https://img.shields.io/badge/iOS-17.0+-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWFileService)
![SwiftUI](https://img.shields.io/badge/SwiftUI-supported-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

A lightweight, practical file utility set that goes beyond folder scanning and file operations to include **video and audio information**. `WWFileService` uses an `enum + static func` design with no shared state, making it a good fit for apps, frameworks, and Swift packages as a reusable file service layer. [file:1]

In addition to wrapping common `FileManager` tasks, it can also handle media-oriented workflows such as thumbnail generation, video duration and size lookup, and audio metadata access. That makes it easier to cover the full flow from file scanning to list presentation and media details with one consistent API. [file:1]

![Example](https://github.com/user-attachments/assets/ca932723-39e0-4f38-854a-ddbdb7f70318)

## 🚀 [Features](https://peterpanswift.github.io/iphone-bezels/)

- Pure Foundation-oriented design with a compact API surface. [file:1]
- `enum` namespace style, so there is no shared state and integration stays simple. [file:1]
- Supports both first-level scanning and recursive scanning, letting you balance scope and performance. [file:1]
- Supports extension filtering, such as `mp4`, `mov`, `m4v`, `mp3`, and `m4a`. [file:1]
- Supports `FileServiceItem`, which is convenient for binding directly to list-based UIs. [file:1]
- Adds video and audio metadata access for players, media libraries, import flows, and asset indexing. [file:1]
- Supports extracting thumbnails from videos, which is useful for preview cards and cover images. [file:1]

## API Overview

### Folder and file scanning

| Name | Return Value | Scope | Filter | Description |
|---|---|---|---|---|
| `folderUrls(at:skipsHiddenFiles:)` | `[URL]` | First level | Folders only | Returns the first-level subfolder URLs under the given folder, sorted. [file:1] |
| `folderNames(at:skipsHiddenFiles:)` | `[String]` | First level | Folders only | Returns the first-level subfolder names under the given folder, sorted. [file:1] |
| `fileUrls(at:allowedExtensions:skipsHiddenFiles:)` | `[URL]` | First level | Regular files + extensions | Returns file URLs that match the allowed extensions under the given folder. [file:1] |
| `fileNames(at:allowedExtensions:skipsHiddenFiles:)` | `[String]` | First level | Regular files + extensions | Returns file names that match the allowed extensions under the given folder. [file:1] |
| `fileItem(at:allowedExtensions:skipsHiddenFiles:)` | `FileServiceItem?` | Single file | Regular files + extensions | Returns file metadata for a single file; if it matches the filter, it returns the URL, creation date, and file size, otherwise `nil`. [file:1] |
| `fileItems(at:allowedExtensions:skipsHiddenFiles:)` | `[FileServiceItem]` | First level | Regular files + extensions | Returns matching file metadata under the given folder, which is ideal for list UIs. [file:1] |
| `allFileUrls(at:skipsHiddenFiles:)` | `[URL]` | Recursive | Regular files | Recursively scans the given folder and all subfolders, returning all regular file URLs. [file:1] |
| `allFileItems(at:skipsHiddenFiles:)` | `[FileServiceItem]` | Recursive | Regular files | Recursively scans the given folder and all subfolders, returning metadata for all regular files. [file:1] |

### File operations

| Name | Return Value | Description |
|---|---|---|
| `fileExists(at:)` | `Bool` | Checks whether a file or folder exists at the given path. [file:1] |
| `createDirectory(at:withIntermediateDirectories:)` | `Void` | Creates a folder. [file:1] |
| `write(_:to:)` | `Void` | Writes `Data` to the specified destination. [file:1] |
| `write(_:to:encoder:)` | `Void` | Encodes an `Encodable` value and writes it as JSON. [file:1] |
| `readData(from:)` | `Data` | Reads raw data from a file. [file:1] |
| `read(_:from:decoder:)` | `T` | Reads and decodes a value of the specified type. [file:1] |
| `moveItem(at:to:)` | `Void` | Moves a file or folder to a new location. [file:1] |
| `renameItem(at:to:)` | `URL` | Renames a file and returns the new URL. [file:1] |
| `copyItem(at:to:)` | `Void` | Copies a file to the destination. [file:1] |
| `deleteItem(at:)` | `Void` | Deletes the specified file or folder. [file:1] |

### Video

| Name | Return Value | Description |
|---|---|---|
| `videoThumbnail(for:at:maximumSize:preferredTimescale:toleranceBefore:toleranceAfter:)` | `UIImage` | Generates a thumbnail from a video at a specific time, useful for previews, timeline cards, and poster images. [file:1] |
| `videoInformation(for:)` | `VideoInfo` | Returns video information such as duration and size, which is useful for displaying runtime and resolution-related details. [file:1] |

### Audio

| Name | Return Value | Description |
|---|---|---|
| `audioInformation(for:)` | `AudioInformation` | Returns audio file information, which is useful for playlists, metadata display, and import checks. [file:1] |

## Use Cases

`WWFileService` is no longer just a file finder; it is also a practical foundation for local media apps. When your workflow includes video lists, music collections, voice lesson imports, media library management, or offline assets, you can scan files first and then enrich the UI with media metadata. [file:1]

A common flow is to build a data source with `fileItems(...)` or `allFileItems(...)`, then fetch `videoInformation(for:)` / `videoThumbnail(...)` for videos, or `audioInformation(for:)` for audio. This separation keeps file discovery and media parsing responsibilities clear and easy to maintain. [file:1]

## Function Details

### `folderNames(at:skipsHiddenFiles:)`

Reads the first-level subfolder names under the specified folder without recursion. It is suitable for category lists, folder tabs, or directory entry screens.

```swift
let names = try WWFileService.folderNames(
    at: folderURL,
    skipsHiddenFiles: true
)
```

### `fileItems(at:allowedExtensions:skipsHiddenFiles:)`

Returns an array of `FileServiceItem` values that can be bound directly to a list view. When your UI needs file name, creation date, and file size without manually collecting `URLResourceValues`, this is the most convenient API. [file:1]

```swift
let items = try WWFileService.fileItems(
    at: folderURL,
    allowedExtensions: ["mp4", "mov", "m4a", "mp3"],
    skipsHiddenFiles: true
)
```

### `allFileItems(at:skipsHiddenFiles:)`

Recursively scans the entire folder tree and returns metadata for all regular files. It is a good fit for media libraries, lesson folder organization, offline search, or batch analysis. [file:1]

```swift
let items = try WWFileService.allFileItems(
    at: rootURL,
    skipsHiddenFiles: true
)
```

### `videoThumbnail(for:at:maximumSize:preferredTimescale:toleranceBefore:toleranceAfter:)`

Generates a thumbnail from a video, which is useful for video cards, course chapter covers, and player preview frames. If you need control over image quality, sampling position, or generation speed, this API is flexible enough to help. [file:1]

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

Reads video information such as duration and size, which makes it easier to present runtime or infer layout ratios in the UI. It is especially useful for player lists, media import checks, and video-based learning apps. [file:1]

```swift
let info = try await WWFileService.videoInformation(for: videoURL)

print(info.duration)
print(info.size)
```

### `audioInformation(for:)`

Reads audio file information, which is useful for playlists, voice lessons, recording management, and import validation. When your app needs audio metadata before deciding how to present content, this API keeps the flow simple. [file:1]

```swift
let info = try await WWFileService.audioInformation(for: audioURL)
```

## Examples

### Build a video list with metadata

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

### Read audio lessons and build a playlist

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

### Build a thumbnail gallery

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

## Notes

- `folderNames(...)`, `fileUrls(...)`, `fileNames(...)`, and `fileItems(...)` only handle the first level; `allFileUrls(...)` and `allFileItems(...)` recursively scan the entire folder tree. [file:1]
- `allowedExtensions` is normalized to lowercase before matching, so `MP4`, `Mp4`, and `mp4` all work correctly. [file:1]
- `allFileUrls(...)` and `allFileItems(...)` return only regular files, not folders, symbolic links, or other special file types. [file:1]
- For media-heavy screens, it is usually better to use `fileItems(...)` or `allFileItems(...)` as the base model and cache `VideoInfo` / `AudioInformation` separately.

## Suitable For

- SwiftUI video lists and thumbnail previews
- Local music, podcast, and voice recording players
- Audio lesson management for language learning apps
- Documents / Inbox media import flows
- Offline video course management
- Local media indexing and batch scanning
- Player preprocessing for duration, dimensions, and thumbnail generation
