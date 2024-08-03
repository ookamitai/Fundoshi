//
//  MenuView.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI
import AVKit

struct MenuView: View {
    private func exitApp() {
        NSApplication.shared.terminate(self)
    }
    
    @State private var isHovering: Bool = false
    @State private var tmp: String = ""
    @AppStorage("setTime") private var setTime: Int = 60
    @AppStorage("timeSec") private var timeSec: Int = 60
    @State var audioPlayer: AVAudioPlayer!
    @Binding var timeString: String
    @State private var timerOn: Bool = false
    @State private var imageClockOpacity: Double = 0.05
    @State private var isDetailWindowOpen: Bool = false
    @Binding var appConfig: AppConfig
    @Environment(\.openWindow) var openWindow
    @Environment(\.dismissWindow) private var dismissWindow
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    // timer function
    
    var body: some View {
        ZStack {
            VStack {
                TextField("set duration (min)...", text: $tmp)
                    .onSubmit {
                        timerOn = false
                        setTime = (Int(tmp) ?? 1) * 60
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                    }
                HStack {
                    Button {
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                        timerOn = true
                    } label: {
                        Text("start")
                    }
                    .buttonStyle(.plain)
                    .disabled(timerOn)
                    .opacity(timerOn ? 0.5 : 1)
                    Button {
                        timerOn.toggle()
                    } label: {
                        Text(timerOn ? "pause" : "resume")
                    }
                    .buttonStyle(.plain)
                    Button {
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                        timerOn = false
                    } label: {
                        Text("end")
                    }
                    .buttonStyle(.plain)
                    ProgressView(value: Double(setTime - timeSec), total: Double(setTime))
                }
                .foregroundStyle(.secondary)
                Divider()
                HStack {
                    Button {
                        timerOn = false
                        setTime = 5 * 60
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                    } label: {
                        Text("5min")
                    }
                    .buttonStyle(.plain)
                    Button {
                        timerOn = false
                        setTime = 20 * 60
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                    } label: {
                        Text("20min")
                    }
                    .buttonStyle(.plain)
                    Button {
                        timerOn = false
                        setTime = 45 * 60
                        timeSec = setTime
                        timeString = buildString(secs: setTime)
                    } label: {
                        Text("45min")
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Button {
                        if !isDetailWindowOpen {
                            isDetailWindowOpen.toggle()
                            NSApp.activate(ignoringOtherApps: true)
                            openWindow(id: "details")
                            for window in NSApplication.shared.windows {
                                if window.title == "details" {
                                    window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
                                    window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
                                    window.standardWindowButton(NSWindow.ButtonType.closeButton)!.isHidden = true
                                    window.level = .floating
                                    window.isMovableByWindowBackground = true
                                }
                            }
                        } else {
                            isDetailWindowOpen.toggle()
                            dismissWindow(id: "details")
                        }
                        
                    } label: {
                        Text("seperate window")
                    }
                    .buttonStyle(.plain)
                }
                .foregroundStyle(.secondary)
                HStack {
                    /*
                    Toggle(isOn: $isShowingMenuBarTime) {
                        Text("show time in menu bar?")
                            .foregroundStyle(.secondary)
                    }
                     */
                    Spacer()
                    Button {
                        NSApp.activate(ignoringOtherApps: true)
                        openWindow(id: "config")
                    } label: {
                        Text("preferences")
                    }
                    .buttonStyle(.plain)
                    .keyboardShortcut(",", modifiers: [.command])
                }
                .foregroundStyle(.secondary)
                .offset(y: 1)
                Spacer()
                HStack(alignment: .bottom) {
                    HStack {
                        Text("fundoshi v1.3")
                            .foregroundStyle(.secondary)
                        Divider()
                        Button {
                            exitApp()
                        } label: {
                            Text("quit")
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(height: 15)
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("total: \(buildString(secs: setTime))")
                            .font(.system(size: 10))
                            .foregroundStyle(.secondary)
                            .offset(x: -3, y: 8)
                        Text("\(timeString)")
                            .fontDesign(.rounded)
                            .font(.system(size: isHovering ? 40 : 35))
                            .onHover(perform: { hovering in
                                withAnimation {
                                    isHovering = hovering
                                }
                            })
                            .offset(y: 5)
                            .onReceive(timer) { _ in
                                if timerOn {
                                    if timeSec > 0 {
                                        if timeSec % 2 == 0 {
                                            imageClockOpacity = 0.1
                                        } else {
                                            imageClockOpacity = 0.05
                                        }
                                        timeSec -= 1
                                        timeString = buildString(secs: timeSec)
                                    } else {
                                        timerOn = false
                                        timeSec = setTime
                                        timeString = buildString(secs: timeSec)
                                        if appConfig.playSound {
                                            audioPlayer.play()
                                        }
                                        // play sound
                                        if appConfig.enableNotification {
                                            notify(msg: "Timer of \(buildString(secs: setTime)) ended.")
                                        }
                                    }
                                }
                            }
                    }
                }
                
            }
            .frame(width: 300, height: 160)
            .padding(10)
            .onAppear {
                self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "ding", ofType: "mp3")!))
                // dangrous use of !, but the file won't be absent anyway
                // ding.mp4 was integrated into the app, so there shouldn't be a problem
            }
            
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
    
    private func buildString(secs: Int) -> String {
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
}
