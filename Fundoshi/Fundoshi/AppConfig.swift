//
//  AppConfig.swift
//  Fundoshi
//
//  Created by ookamitai on 8/3/24.
//

import Foundation
import SwiftUI

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

enum FontSytle {
    case noStyle, monospaced, rounded, serif
}

enum FlipAnimation {
    case top, bottom
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
