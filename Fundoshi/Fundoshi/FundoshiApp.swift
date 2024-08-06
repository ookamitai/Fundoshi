//
//  FundoshiApp.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI
import MenuBarExtraAccess

@main
struct FundoshiApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isMenubarPresented: Bool = false
    @AppStorage("timeString") private var timeString = "01:00"
    @AppStorage("appConfig") private var appConfig = AppConfig(isShowingMenuBarTime: true, launchAtLogin: false, enableNotification: true, playSound: true, useTranslucency: true, fontStyle: .rounded, flipAnimation: .top, detailWindowAlpha: 1)
    
    var body: some Scene {
        MenuBarExtra {
            MenuView(timeString: $timeString, appConfig: $appConfig, isMenubarPresented: $isMenubarPresented)
                .introspectMenuBarExtraWindow { window in
                    window.animationBehavior = .utilityWindow
                }
        } label: {
            Image(systemName: "clock")
            Text(appConfig.isShowingMenuBarTime ? timeString : "")
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isMenubarPresented) { statusItem in
        }
        
        Window("details", id: "details") {
            SeparateWindow(timeString: $timeString, appConfig: $appConfig)
                .frame(width: 175, height: 50)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultPosition(.topTrailing)
        
        Window("config", id: "config") {
            ContentView(appConfig: $appConfig)
                .background(VisualEffectView().ignoresSafeArea())
                .frame(maxWidth: 500, maxHeight: 350)
                .frame(minWidth: 450)
        }
        .windowResizability(.contentSize)
    }
}
