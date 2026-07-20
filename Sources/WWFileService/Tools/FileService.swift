//
//  File.swift
//  WWFileService
//
//  Created by iOS on 2026/7/20.
//

import Foundation

public enum FileService {}

public extension FileService {
    
    static func exists(at url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
    
    // MARK: - Create / Write
    static func createDirectory(at url: URL, withIntermediateDirectories: Bool = true) throws {
        try FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: withIntermediateDirectories
        )
    }
    
    static func write(_ data: Data, to url: URL) throws {
        try data.write(to: url, options: [.atomic])
    }
    
    static func write<T: Encodable>(_ value: T, to url: URL, encoder: JSONEncoder = JSONEncoder()) throws {
        let data = try encoder.encode(value)
        try write(data, to: url)
    }
    
    // MARK: - Read
    static func readData(from url: URL) throws -> Data {
        try Data(contentsOf: url)
    }
    
    static func read<T: Decodable>(_ type: T.Type, from url: URL, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        let data = try readData(from: url)
        return try decoder.decode(T.self, from: data)
    }
    
    // MARK: - Update
    static func update(_ data: Data, at url: URL) throws {
        try write(data, to: url)
    }
    
    static func renameItem(at url: URL, to newName: String) throws -> URL {
        let newURL = url.deletingLastPathComponent().appendingPathComponent(newName)
        try FileManager.default.moveItem(at: url, to: newURL)
        return newURL
    }
    
    static func moveItem(at url: URL, to newURL: URL) throws {
        try FileManager.default.moveItem(at: url, to: newURL)
    }
    
    static func copyItem(at url: URL, to newURL: URL) throws {
        try FileManager.default.copyItem(at: url, to: newURL)
    }
    
    // MARK: - Delete
    static func deleteItem(at url: URL) throws {
        guard exists(at: url) else { return }
        try FileManager.default.removeItem(at: url)
    }
}
