//
//  FundoshiApp.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI

@main
struct FundoshiApp: App {
    @State private var timeString = "01:00"
    var body: some Scene {
        MenuBarExtra {
            MenuView(timeString: $timeString)
        } label: {
            Image(systemName: "clock.badge")
            Text(timeString)
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup {
            ContentView()
        }
        
        Window("details", id: "details") {
            SeperateWindow(timeString: $timeString)
                .frame(width: 175, height: 50)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
        .defaultPosition(.topTrailing)
    }
}
