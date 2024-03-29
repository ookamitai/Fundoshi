//
//  MenuView.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI
import AVKit

struct MenuView: View {
    @State private var isHovering: Bool = false
    @State private var tmp: String = ""
    @State private var setTime: Int = 60
    @State private var timeSec: Int = 60
    @State var audioPlayer: AVAudioPlayer!
    @Binding var timeString: String
    @State private var timerOn: Bool = false
    @Environment(\.openWindow) var openWindow
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
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
                    timeSec = setTime
                    timeString = buildString(secs: setTime)
                    timerOn = false
                } label: {
                    Text("end")
                }
                .buttonStyle(.plain)
                Button {
                    timerOn.toggle()
                } label: {
                    Text(timerOn ? "pause" : "resume")
                }
                .buttonStyle(.plain)
                ProgressView(value: Double(setTime - timeSec), total: Double(setTime))
            }
            .foregroundStyle(.secondary)
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
            }
            .foregroundStyle(.secondary)
            HStack {
                Button {
                    openWindow(id: "details")
                    for window in NSApplication.shared.windows {
                        if window.title == "details" {
                            window.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isHidden = true
                            window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.isHidden = true
                            window.level = .floating
                        }
                    }
                } label: {
                    Text("seperate window")
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .foregroundStyle(.secondary)
            Spacer()
            HStack(alignment: .bottom) {
                HStack {
                    Text("fundoshi v1.2")
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
                                timeSec -= 1
                                timeString = buildString(secs: timeSec)
                            } else {
                                timerOn = false
                                timeSec = setTime
                                timeString = buildString(secs: timeSec)
                                audioPlayer.play()
                                // play sound
                            }
                        }
                    }
            }
        }
        .frame(width: 300, height: 140)
        .padding(10)
        .onAppear {
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "ding", ofType: "mp3")!))
        }
    }
    
    private func exitApp() {
        NSApplication.shared.terminate(self)
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

