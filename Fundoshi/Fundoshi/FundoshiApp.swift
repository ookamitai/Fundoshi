//
//  FundoshiApp.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI

@main
struct FundoshiApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("timeString") private var timeString = "01:00"
    @AppStorage("appConfig") private var appConfig = AppConfig(isShowingMenuBarTime: true, launchAtLogin: false, enableNotification: true, playSound: true)
    var body: some Scene {
        MenuBarExtra {
            MenuView(timeString: $timeString, appConfig: $appConfig)
        } label: {
            Image(systemName: "clock")
            Text(appConfig.isShowingMenuBarTime ? timeString : "")
        }
        .menuBarExtraStyle(.window)
        
        Window("details", id: "details") {
            SeperateWindow(timeString: $timeString)
                .frame(width: 175, height: 50)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.topTrailing)
        
        Window("config", id: "config") {
            ContentView(appConfig: $appConfig)
                .background(VisualEffectView().ignoresSafeArea())
                .frame(maxWidth: 500, maxHeight: 350)
        }
        .windowResizability(.contentSize)
    }
}
