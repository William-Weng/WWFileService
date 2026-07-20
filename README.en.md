[English](./README.en.md) | [繁體中文](./README.md)

# [WWFileService](https://swiftpackageindex.com/William-Weng)

[![Swift-5.10+](https://img.shields.io/badge/Swift-5.10+-orange.svg)](https://developer.apple.com/swift/)
[![iOS-17.0+](https://img.shields.io/badge/iOS-17.0+-pink.svg?style=flat)](https://developer.apple.com/swift/)
![TAG](https://img.shields.io/github/v/tag/William-Weng/WWFileService)
![SwiftUI](https://img.shields.io/badge/SwiftUI-supported-green.svg)
![SPM](https://img.shields.io/badge/SPM-supported-brightgreen.svg)
[![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

A lightweight, pure `Foundation` file utility collection focused on common needs such as folders, files, recursive scanning, and file metadata. `WWFileService` is designed as an `enum + static func` namespace, with no shared state, making it simple to call and easy to reuse in apps, frameworks, or Swift Packages.

Its main goal is to turn the scattered `FileManager` APIs into a consistent, readable, and maintainable interface, including:

- Reading first-level subfolder names.
- Reading first-level file URLs, names, and file metadata filtered by extension.
- Recursively reading all regular files under a directory tree.
- Supporting hidden file / hidden folder skipping.

![Example](https://github.com/user-attachments/assets/ca932723-39e0-4f38-854a-ddbdb7f70318)

## 🚀 [Features](https://peterpanswift.github.io/iphone-bezels/)

- Pure Foundation, no extra dependencies.
- Clean namespace design with `enum`.
- Supports both first-level and recursive scanning.
- Supports extension filtering, such as `mp4`, `mov`, and `m4v`.
- Supports returning `FileItem`, which is convenient for direct UI binding.
- Great for video lists, file explorers, media managers, and import flows.

## 📦 API Overview

### Folders

| Name | Return | Depth | Filter | Description |
|---|---|---|---|---|
| `folderUrls(at:skipsHiddenFiles:)` | `[URL]` | First level | Folders only | Reads the first-level subfolder URLs under the given folder and sorts them. |
| `folderNames(at:skipsHiddenFiles:)` | `[String]` | First level | Folders only | Reads the first-level subfolder names under the given folder and sorts them. |
| `fileUrls(at:allowedExtensions:skipsHiddenFiles:)` | `[URL]` | First level | Regular files + extensions | Reads file URLs under the given folder that match the given extensions. |
| `fileNames(at:allowedExtensions:skipsHiddenFiles:)` | `[String]` | First level | Regular files + extensions | Reads file names under the given folder that match the given extensions. |
| `fileItems(at:allowedExtensions:skipsHiddenFiles:)` | `[FileServiceItem]` | First level | Regular files + extensions | Reads file info under the given folder that match the given extensions, including URL, creation date, and file size. |
| `allFileUrls(at:skipsHiddenFiles:)` | `[URL]` | Recursive | Regular files | Recursively scans the given folder and all subfolders, returning all regular file URLs. |
| `allFileItems(at:skipsHiddenFiles:)` | `[FileServiceItem]` | Recursive | Regular files | Recursively scans the given folder and all subfolders, returning all regular file info. |

### Video

| Name | Return | Description |
|---|---|---|
| `videoThumbnail(for:at:maximumSize:preferredTimescale:toleranceBefore:toleranceAfter:)` | `UIImage` | Generates a thumbnail image from a video at a specific time. |
| `videoInformation(for:)` | `VideoInfo` | Retrieves the video duration and its original size. |

### CRUD
| Name | Return | Description |
|---|---|---|
| `fileExists(at:)` | `Bool` | Checks whether a file or folder exists at the specified URL. |
| `createDirectory(at:withIntermediateDirectories:)` | `Void` | Creates a directory at the specified URL. |
| `write(_:to:)` | `Void` | Writes raw `Data` to the specified location. |
| `write(_:to:encoder:)` | `Void` | Encodes an `Encodable` value and writes it as JSON. |
| `readData(from:)` | `Data` | Reads raw data from the specified file. |
| `read(_:from:decoder:)` | `T` | Reads and decodes a value of the specified type. |
| `moveItem(at:to:)` | `Void` | Moves a file or folder to a new location. |
| `renameItem(at:to:)` | `URL` | Renames a file and returns the new URL. |
| `copyItem(at:to:)` | `Void` | Copies a file to the specified destination. |
| `deleteItem(at:)` | `Void` | Deletes the specified file or folder. |

## 🔍 Function Details

### `folderNames(at:skipsHiddenFiles:)`

Reads the first-level subfolder names under the specified directory without recursion. This is useful for category lists, folder pages, or directory entry UIs.

```swift
let names = try WWFileService.folderNames(
    at: folderURL,
    skipsHiddenFiles: true
)
```

### `fileUrls(at:allowedExtensions:skipsHiddenFiles:)`

Reads first-level file URLs that match the allowed extensions. This API is useful when you only need URLs and plan to handle metadata or player loading later.

```swift
let urls = try WWFileService.fileUrls(
    at: folderURL,
    allowedExtensions: ["mp4", "mov", "m4v"],
    skipsHiddenFiles: true
)
```

### `fileNames(at:allowedExtensions:skipsHiddenFiles:)`

This is the name-based version of `fileUrls(...)`, returning `lastPathComponent` directly. If your UI only needs to display names and does not need URLs or metadata, this is the simplest API.

```swift
let names = try WWFileService.fileNames(
    at: folderURL,
    allowedExtensions: ["mp4", "mov"],
    skipsHiddenFiles: true
)
```

### `fileItems(at:allowedExtensions:skipsHiddenFiles:)`

Returns custom `FileItem` values, which are ideal for directly binding to list views. A `FileItem` typically contains at least `url`, `createdDate`, and `fileSize`, making it a good fit for video lists, download lists, and import screens.

```swift
let items = try WWFileService.fileItems(
    at: folderURL,
    allowedExtensions: ["mp4", "mov"],
    skipsHiddenFiles: true
)
```

### `allFileUrls(at:skipsHiddenFiles:)`

Recursively scans the specified directory and all of its subdirectories, returning all regular file URLs. This is useful for full-directory search, media library building, and batch processing.

```swift
let urls = try WWFileService.allFileUrls(
    at: folderURL,
    skipsHiddenFiles: true
)
```

### `allFileItems(at:skipsHiddenFiles:)`

This is the recursive `FileItem` API. If you want to build a file list for an entire directory tree and display time, size, and sorting information, this version is the most convenient.

```swift
let items = try WWFileService.allFileItems(
    at: folderURL,
    skipsHiddenFiles: true
)
```

## 🛠️ Usage Example

### Read videos from Documents

```swift
let documentsURL = URL.documentsDirectory

let videos = try WWFileService.fileItems(
    at: documentsURL,
    allowedExtensions: ["mp4", "mov", "m4v"],
    skipsHiddenFiles: true
)
```

### Read all videos recursively

```swift
let documentsURL = URL.documentsDirectory
let rootURL = documentsURL.appendingPathComponent("Videos", isDirectory: true)

let allVideos = try WWFileService.allFileItems(
    at: rootURL,
    skipsHiddenFiles: true
)
```

## ⚠️ Notes

- `folderNames(...)`, `fileUrls(...)`, `fileNames(...)`, and `fileItems(...)` all operate on the **first level only**.
- `allFileUrls(...)` and `allFileItems(...)` perform **recursive scanning**.
- `allowedExtensions` is normalized to lowercase for comparison, so both `MP4` and `mp4` work correctly.
- `allFileUrls(...)` / `allFileItems(...)` return only regular files, not folders, symbolic links, or other special file types.
- If you are building a video player list, it is usually best to use `fileItems(...)` or `allFileItems(...)`, since the UI often needs names, dates, and sizes together.

## ✅ Best Use Cases

- SwiftUI video lists
- Documents / Inbox file import
- Media managers
- Local file browsers
- Batch file scanning
- Audio / video asset indexing
