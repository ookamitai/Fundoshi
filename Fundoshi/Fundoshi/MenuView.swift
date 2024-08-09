//
//  MenuView.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI
import AVKit
import CompactSlider

public struct CustomCompactSliderStyle: CompactSliderStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(
                configuration.isHovering || configuration.isDragging ? .primary : .primary.opacity(0.6)
            )
            .background(
                Color.accentColor.opacity(0.1)
            )
            .compactSliderSecondaryAppearance(
                progressShapeStyle: LinearGradient(
                    colors: [.accentColor.opacity(0.1), .accentColor.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                focusedProgressShapeStyle: LinearGradient(
                    colors: [.accentColor.opacity(0.2), .accentColor.opacity(0.4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .animation(.default, value: configuration.isHovering)
    }
}

public extension CompactSliderStyle where Self == CustomCompactSliderStyle {
    static var `custom`: CustomCompactSliderStyle { CustomCompactSliderStyle() }
}


struct MenuView: View {
    private func exitApp() {
        NSApplication.shared.terminate(self)
    }
    
    @State private var isHovering: Bool = false
    @State private var tmp: String = ""
    @AppStorage("setTime") private var setTime: Int = 60
    @AppStorage("timeSec") private var timeSec: Int = 60
    @State private var audioPlayer: AVAudioPlayer!
    @Binding var timeString: String
    @Binding var appState: AppState
    @State private var imageClockOpacity: Double = 0.05
    @State private var doubleHelper: Double = 0.0
    @State private var showCustomTime: Bool = false
    @Binding var appConfig: AppConfig
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // timer function
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    CompactSlider(value: $doubleHelper, in: 1...61, step: 1) {
                        Text("Time (mins)")
                        Spacer()
                        Text(doubleHelper <= 60.0 ? "\(Int(doubleHelper))" : "Custom")
                    }
                    .frame(maxWidth: showCustomTime ? 300 : .infinity)
                    .onChange(of: doubleHelper) { _, newValue in
                        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "tick", ofType: "caf")!))
                        audioPlayer.play()
                        if doubleHelper == 61.0 {
                            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "extra", ofType: "caf")!))
                            audioPlayer.play()
                            showCustomTime = true
                            return
                        } else {
                            showCustomTime = false
                        }
                        setTime = Int(newValue) * 60
                        if !appState.timerOn {
                            timeSec = Int(setTime)
                            timeString = buildString(secs: timeSec)
                        }
                    }
                    .onAppear {
                        doubleHelper = Double(setTime / 60)
                    }
                    .animation(.default, value: showCustomTime)
                    .compactSliderStyle(.custom)
                    
                    TextField("", text: $tmp)
                        .onChange(of: tmp) {
                            setTime = (Int(tmp) ?? 1) * 60
                            timeSec = setTime
                            timeString = buildString(secs: setTime)
                        }
                        .frame(width: showCustomTime ? 50 : 0)
                        .opacity(showCustomTime ? 1 : 0)
                        .animation(.default, value: showCustomTime)
                }
                HStack {
                    Button {
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                        appState.timerOn = true
                        if (appConfig.history.count >= 20) {
                            appConfig.history.remove(at: 0)
                        }
                        appConfig.history.append(timeSec)
                    } label: {
                        Image(systemName: "play")
                    }
                    .buttonStyle(.plain)
                    .disabled(appState.timerOn)
                    .opacity(appState.timerOn ? 0.5 : 1)
                    Spacer()
                        .frame(width: 10)
                    Button {
                        appState.timerOn.toggle()
                    } label: {
                        ZStack {
                            Image(systemName: "pause")
                        }
                    }
                    .buttonStyle(.plain)  
                    Spacer()
                        .frame(width: 10)
                    Button {
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                        appState.timerOn = false
                    } label: {
                        Image(systemName: "stop")
                    }
                    .buttonStyle(.plain)
                }
                .foregroundStyle(.secondary)
                .padding(1)
                Divider()
                HStack {
                    Button {
                        appState.timerOn = false
                        setTime = appConfig.preset[0] * 60
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                    } label: {
                        Text("\(appConfig.preset[0])min")
                    }
                    .buttonStyle(.plain)
                    Button {
                        appState.timerOn = false
                        setTime = appConfig.preset[1] * 60
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                    } label: {
                        Text("\(appConfig.preset[1])min")
                    }
                    .buttonStyle(.plain)
                    Button {
                        appState.timerOn = false
                        setTime = appConfig.preset[2] * 60
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                    } label: {
                        Text("\(appConfig.preset[2])min")
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Button {
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
                        
                    } label: {
                        Image(systemName: "macwindow.on.rectangle")
                    }
                    .buttonStyle(.plain)
                    Button {
                        appState.isMenubarPresented = false
                        NSApp.activate(ignoringOtherApps: true)
                        openWindow(id: "config")
                    } label: {
                        Image(systemName: "gear")
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(",", modifiers: [.command])
                }
                .foregroundStyle(.secondary)
                HStack {
                    Spacer()
                    VStack {
                        Text("\(timeString)")
                            .monospacedDigit()
                            .fontDesign(getStyle(appConfig.fontStyle))
                            .font(.system(size: appConfig.fontStyle == .monospaced ? 50 : 55))
                            .scaleEffect(isHovering ? CGSize(width: 1, height: 1) : CGSize(width: 0.9, height: 0.9) , anchor: .center)
                            .onHover(perform: { hovering in
                                withAnimation {
                                    isHovering = hovering
                                }
                            })
                            .onReceive(timer) { _ in
                                if appState.timerOn {
                                    if timeSec > 0 {
                                        if timeSec % 2 == 0 {
                                            imageClockOpacity = 0.1
                                        } else {
                                            imageClockOpacity = 0.05
                                        }
                                        timeSec -= 1
                                        timeString = buildString(secs: timeSec)
                                    } else {
                                        appState.timerOn = false
                                        timeSec = setTime
                                        timeString = buildString(secs: timeSec)
                                        if appConfig.playSound {
                                            audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "ding", ofType: "caf")!))
                                            audioPlayer.play()
                                        }
                                        // play sound
                                        if appConfig.enableNotification {
                                            notify(msg: String(localized: "Timer of \(buildString(secs: setTime)) ended."))
                                        }
                                    }
                                }
                            }
                        Text("of \(buildString(secs: setTime))")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                            .offset(y: -5)
                    }
                    .padding(.top, 5)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button {
                        NSApplication.shared.terminate(self)
                    } label: {
                        Image(systemName: "door.right.hand.open")
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.secondary)
                }
                
            }
            .frame(width: 300, height: 185)
            .padding(10)
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "clock")
                        .resizable()
                        .opacity(imageClockOpacity)
                        .frame(width: 150, height: 150)
                        .offset(x: 60, y: 60)
                        .blur(radius: 2)
                        .shadow(radius: 3)
                        .animation(.default, value: imageClockOpacity)
                }
            }
            .padding(5)
        }
    }
}

func buildString(secs: Int) -> String {
    var result = ""
    var cpsecs = secs
    let seconds = cpsecs % 60
    cpsecs -= seconds
    cpsecs /= 60
    let minutes = cpsecs % 60
    cpsecs -= minutes
    cpsecs /= 60
    let hours = cpsecs % 60
    if hours < 10 {
        if hours != 0 {
            result += "0\(hours):"
        }
    } else {
        result += "\(hours):"
    }
    if minutes < 10 {
        result += "0\(minutes):"
    } else {
        result += "\(minutes):"
    }
    if seconds < 10 {
        result += "0\(seconds)"
    } else {
        result += "\(seconds)"
    }
    
    return result
    
}
