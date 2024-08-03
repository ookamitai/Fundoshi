//
//  ContentView.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI
import ServiceManagement

struct ContentView: View {
    @Binding var appConfig: AppConfig
    @State private var selectedItem: String? = "config"
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                Section("General") {
                    NavigationLink(value: "config") {
                        Label("Preferences", systemImage: "gear")
                    }
                    
                    NavigationLink(value: "about") {
                        Label("About", systemImage: "info.circle")
                    }
                }
            }
        } detail: {
            switch selectedItem {
            case "config":
                ConfigView(appConfig: $appConfig)
                    .navigationTitle("Preferences")
            case "about":
                AboutView(appConfig: $appConfig)
                    .navigationTitle("About")
            default:
                Text("Select an item")
            }
        }
    }
}
