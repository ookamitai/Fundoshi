//
//  AppConfig.swift
//  Fundoshi
//
//  Created by ookamitai on 8/3/24.
//

import Foundation
import SwiftUI
import Combine

func getStyle(_ fs: FontSytle) -> Font.Design {
    switch fs {
    case .noStyle:
        return .default
    case .monospaced:
        return .monospaced
    case .rounded:
        return .rounded
    case .serif:
        return .serif
    }
}

func arrayBuildString(_ h: [Int]) -> String {
    var s = ""
    for i in h {
        s += (String(i) + ",")
    }
    s.removeLast()
    return s
}

func arrayDissectString(_ s: String) -> [Int] {
    var r: [Int] = []
    for i in s.components(separatedBy: ",") {
        r.append(Int(i) ?? 0)
    }
    return r
}

enum FontSytle {
    case noStyle, monospaced, rounded, serif
}

enum FlipAnimation {
    case top, bottom
}

enum ContextClickAction {
    case pause, openDetailWindow
}

struct AppConfig {
    var isShowingMenuBarTime: Bool
    var launchAtLogin: Bool
    var enableNotification: Bool
    var playSound: Bool
    var useTranslucency: Bool
    var fontStyle: FontSytle
    var flipAnimation: FlipAnimation
    var detailWindowAlpha: CGFloat
    var contextClickAction: ContextClickAction
    var history: [Int]
    var isShowingMenuBarTimerStatus: Bool
    var preset: [Int]
}

extension AppConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case isShowingMenuBarTime
        case launchAtLogin
        case enableNotification
        case playSound
        case useTranslucency
        case fontStyle
        case flipAnimation
        case detailWindowAlpha
        case contextClickAction
        case history
        case isShowingMenuBarTimerStatus
        case preset
}
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isShowingMenuBarTime, forKey: .isShowingMenuBarTime)
        try container.encode(launchAtLogin, forKey: .launchAtLogin)
        try container.encode(enableNotification, forKey: .enableNotification)
        try container.encode(playSound, forKey: .playSound)
        try container.encode(useTranslucency, forKey: .useTranslucency)
        
        switch flipAnimation {
        case .top:
            try container.encode("top", forKey: .flipAnimation)
        case .bottom:
            try container.encode("bottom", forKey: .flipAnimation)
        }
        
        switch fontStyle {
        case .noStyle:
            try container.encode("noStyle", forKey: .fontStyle)
        case .monospaced:
            try container.encode("monospaced", forKey: .fontStyle)
        case .rounded:
            try container.encode("rounded", forKey: .fontStyle)
        case .serif:
            try container.encode("serif", forKey: .fontStyle)
        }
        
        try container.encode(detailWindowAlpha, forKey: .detailWindowAlpha)
        
        switch contextClickAction {
        case.pause:
            try container.encode("pause", forKey: .contextClickAction)
        case .openDetailWindow:
            try container.encode("detail", forKey: .contextClickAction)
        }
        
        try container.encode(arrayBuildString(history), forKey: .history)
        try container.encode(isShowingMenuBarTimerStatus, forKey: .isShowingMenuBarTimerStatus)
        try container.encode(arrayBuildString(preset), forKey: .preset)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isShowingMenuBarTime = try container.decode(Bool.self, forKey: .isShowingMenuBarTime)
        launchAtLogin = try container.decode(Bool.self, forKey: .launchAtLogin)
        enableNotification = try container.decode(Bool.self, forKey: .enableNotification)
        playSound = try container.decode(Bool.self, forKey: .playSound)
        useTranslucency = try container.decode(Bool.self, forKey: .useTranslucency)
        switch try container.decode(String.self, forKey: .fontStyle) {
        case "noStyle":
            fontStyle = .noStyle
        case "monospaced":
            fontStyle = .monospaced
        case "rounded":
            fontStyle = .rounded
        case "serif":
            fontStyle = .serif
        default:
            fontStyle = .rounded
        }
        switch try container.decode(String.self, forKey: .flipAnimation) {
        case "top":
            flipAnimation = .top
        case "bottom":
            flipAnimation = .bottom
        default:
            flipAnimation = .top
        }
        detailWindowAlpha = try container.decode(CGFloat.self, forKey: .detailWindowAlpha)
        switch try container.decode(String.self, forKey: .contextClickAction) {
        case "detail":
            contextClickAction = .openDetailWindow
        case "pause":
            contextClickAction = .pause
        default:
            contextClickAction = .pause
        }
        history = arrayDissectString(try container.decode(String.self, forKey: .history))
        isShowingMenuBarTimerStatus = try container.decode(Bool.self, forKey: .isShowingMenuBarTimerStatus)
        preset = arrayDissectString(try container.decode(String.self, forKey: .preset))
    }
}

extension AppConfig: RawRepresentable {
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let decoded = try? JSONDecoder().decode(AppConfig.self, from: data) else {
            return nil
        }
        self = decoded
    }

    var rawValue: String {
        guard
            let data = try? JSONEncoder().encode(self),
            let jsonString = String(data: data, encoding: .utf8) else {
            return ""
        }
        return jsonString
    }
}
