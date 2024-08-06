//
//  ConfigView.swift
//  Fundoshi
//
//  Created by ookamitai on 8/3/24.
//

import SwiftUI
import ServiceManagement

struct ConfigView: View {
    @Binding var appConfig: AppConfig
    @State private var isHovering = false
    @State private var isHoveringDangerZone = false
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack {
                                Divider()
                                    .frame(width: 10)
                            }
                            Text("Behavior")
                                .font(.subheadline.lowercaseSmallCaps())
                            VStack {
                                Divider()
                            }
                        }
                        Toggle(isOn: $appConfig.isShowingMenuBarTime) {
                            Text("Show time in menu bar")
                        }
                        Toggle(isOn: $appConfig.isShowingMenuBarTimerStatus) {
                            Text("Show timer status in menu bar")
                        }
                        Toggle(isOn: $appConfig.enableNotification) {
                            Text("Enable notification")
                        }
                        Toggle(isOn: $appConfig.playSound) {
                            Text("Play sound when timer ends")
                        }
                        Picker("Context click action", selection: $appConfig.contextClickAction) {
                            Text("Pause / Resume timer").tag(ContextClickAction.pause)
                            Text("Open / Close separate window").tag(ContextClickAction.openDetailWindow)
                        }
                        .frame(width: 350)
                        .padding(.bottom, 5)
                        HStack {
                            VStack {
                                Divider()
                                    .frame(width: 10)
                            }
                            Text("Appearance")
                                .font(.subheadline.lowercaseSmallCaps())
                            VStack {
                                Divider()
                            }
                        }
                        Toggle(isOn: $appConfig.useTranslucency) {
                            Text("Enable blur for separate window")
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Transparency value for seperate window")
                                HStack {
                                    Slider(value: $appConfig.detailWindowAlpha, in: 0.1...1)
                                        .frame(width: 200)
                                    Text("\(Int(appConfig.detailWindowAlpha * 100))%")
                                        .onChange(of: appConfig.detailWindowAlpha) {
                                            for window in NSApplication.shared.windows {
                                                if window.title == "details" {
                                                    window.alphaValue = appConfig.detailWindowAlpha
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        HStack {
                            Picker("Select flip animation", selection: $appConfig.flipAnimation) {
                                Text("Top").tag(FlipAnimation.top)
                                Text("Bottom").tag(FlipAnimation.bottom)
                            }
                            .frame(width: 250)
                        }
                        HStack {
                            Picker("Select font design", selection: $appConfig.fontStyle) {
                                Text("Default").tag(FontSytle.noStyle)
                                Text("Rounded").tag(FontSytle.rounded)
                                Text("Monospaced").tag(FontSytle.monospaced)
                                Text("Serif").tag(FontSytle.serif)
                            }
                            .frame(width: 250)
                        }
                        .padding(.bottom, 5)
                        HStack {
                            VStack {
                                Divider()
                                    .frame(width: 10)
                            }
                            Text("Misc")
                                .font(.subheadline.lowercaseSmallCaps())
                            VStack {
                                Divider()
                            }
                        }
                        Toggle(isOn: $appConfig.launchAtLogin) {
                            Text("Launch at login")
                        }
                        .onChange(of: appConfig.launchAtLogin) { _, newValue in
                            if newValue {
                                do {
                                    try SMAppService().register()
                                } catch {
                                    appConfig.launchAtLogin = false
                                }
                            } else {
                                do {
                                    try SMAppService().unregister()
                                } catch {
                                    appConfig.launchAtLogin = true
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(5)
                Spacer()
                    .frame(maxHeight: 30)
                HStack {
                    Button {
                        showingAlert = true
                    } label: {
                        Text("Reset saved settings")
                            .foregroundStyle(isHoveringDangerZone ? .red : .primary)
                    }
                    .animation(.default, value: isHoveringDangerZone)
                    .onHover { isHovering in
                        isHoveringDangerZone = isHovering
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Are you sure you want to reset ALL saved settings?"),
                              message: Text("This action cannot be undone."),
                              primaryButton: .destructive(Text("Reset")) {
                                    if let bundleID = Bundle.main.bundleIdentifier {
                                        UserDefaults.standard.removePersistentDomain(forName: bundleID)
                                    }
                                },
                              secondaryButton: .cancel()
                        )
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack {
                        Image(systemName: "gear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 256, height: 256)
                            .rotationEffect(isHovering ? Angle(degrees: 90) : Angle(degrees: 0), anchor: UnitPoint(x: 0.472, y: 0.51))
                            .offset(x: 75, y: 75)
                            .opacity(isHovering ? 0.1 : /* 0.05 */ 0)
                            .blur(radius: isHovering ? 7 : 10)
                            .animation(.default, value: isHovering)
                        Text("Preferences")
                            .font(.system(size: 30))
                            .fontWeight(.ultraLight)
                            .offset(x: isHovering ? 30 : 20, y: 85)
                            .opacity(isHovering ? 0.6 : /* 0.2 */ 0)
                            .blur(radius: isHovering ? 0 : 3)
                            .animation(.default, value: isHovering)
                    }
                }
            }
        }
        .onHover { isHovered in
            isHovering = isHovered
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var appConfig = AppConfig(isShowingMenuBarTime: true, launchAtLogin: false, enableNotification: true, playSound: true, useTranslucency: true, fontStyle: .rounded, flipAnimation: .top, detailWindowAlpha: 1, contextClickAction: .pause, history: [], isShowingMenuBarTimerStatus: true)
        
        var body: some View {
            ConfigView(appConfig: $appConfig)
        }
    }
    return PreviewWrapper()
}
