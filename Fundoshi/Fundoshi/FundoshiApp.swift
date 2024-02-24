//
//  FundoshiApp.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI

@main
struct FundoshiApp: App {
    var body: some Scene {
        MenuBarExtra("Fundoshi", systemImage: "timer") {
            MenuView()
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup {
            ContentView()
        }
        
        Window("details", id: "details") {
            SeperateWindow()
        }
    }
}
