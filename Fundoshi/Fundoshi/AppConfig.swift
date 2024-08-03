//
//  AppConfig.swift
//  Fundoshi
//
//  Created by ookamitai on 8/3/24.
//

import Foundation

struct AppConfig {
    var isShowingMenuBarTime: Bool
    var launchAtLogin: Bool
    var enableNotification: Bool
    var playSound: Bool
}

extension AppConfig: Codable {
    enum CodingKeys: String, CodingKey {
        case isShowingMenuBarTime
        case launchAtLogin
        case enableNotification
        case playSound
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isShowingMenuBarTime, forKey: .isShowingMenuBarTime)
        try container.encode(launchAtLogin, forKey: .launchAtLogin)
        try container.encode(enableNotification, forKey: .enableNotification)
        try container.encode(playSound, forKey: .playSound)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isShowingMenuBarTime = try container.decode(Bool.self, forKey: .isShowingMenuBarTime)
        launchAtLogin = try container.decode(Bool.self, forKey: .launchAtLogin)
        enableNotification = try container.decode(Bool.self, forKey: .enableNotification)
        playSound = try container.decode(Bool.self, forKey: .playSound)
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
