//
//  ContentView.swift
//  Example
//
//  Created by William.Weng on 2026/7/16.
//

import SwiftUI
import WWFileService

struct ContentView: View {
    
    @State private var files: [URL] = []
    
    var body: some View {
        
        NavigationStack {
            List(files, id: \.self) { file in
                Text(file.lastPathComponent)
                    .padding(.vertical, 8)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    )
            }
            .listStyle(.plain)
            .navigationTitle("Files")
            .task {
                do {
                    files = try WWFileService.allFileUrls(
                        at: .documentsDirectory,
                        skipsHiddenFiles: true
                    )
                } catch {
                    files = []
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

