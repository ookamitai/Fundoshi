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
    @State private var appState = AppState()
    @AppStorage("timeString") private var timeString = "01:00"
    @AppStorage("appConfig") private var appConfig = AppConfig(isShowingMenuBarTime: true, launchAtLogin: false, enableNotification: true, playSound: true, useTranslucency: true, fontStyle: .rounded, flipAnimation: .top, detailWindowAlpha: 1, contextClickAction: .pause, history: [])
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) var dismissWindow
    
    var body: some Scene {
        MenuBarExtra {
             MenuView(timeString: $timeString, appState: $appState, appConfig: $appConfig)
                .introspectMenuBarExtraWindow { window in
                    window.animationBehavior = .utilityWindow
                }
        } label: {
            Image(systemName: appState.timerOn ? "clock.badge" : "clock")
            Text(appConfig.isShowingMenuBarTime ? timeString : "")
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $appState.isMenubarPresented) { statusItem in
            if let button = statusItem.button {
                let mouseHandlerView = MouseHandlerView(frame: button.frame)
                mouseHandlerView.onRightMouseDown = {
                    statusItem.button?.isHighlighted = true
                    if appConfig.contextClickAction == .pause {
                        appState.timerOn.toggle()
                    } else {
                        appState.isMenubarPresented = false
                        if !appState.isDetailWindowOpen {
                            appState.isDetailWindowOpen.toggle()
                            NSApp.activate(ignoringOtherApps: true)
                            openWindow(id: "details")
                            for window in NSApplication.shared.windows {
                                if window.title == "details" {
                                    window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
                                    window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
                                    window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
                                    window.level = .floating
                                    window.isMovableByWindowBackground = true
                                    window.alphaValue = appConfig.detailWindowAlpha
                                }
                            }
                        } else {
                            appState.isDetailWindowOpen.toggle()
                            dismissWindow(id: "details")
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
                        statusItem.button?.isHighlighted = false
                    }
                    
                }
                button.addSubview(mouseHandlerView)
            }
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
        }
        .windowResizability(.contentSize)
    }
}

