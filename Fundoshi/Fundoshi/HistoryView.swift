//
//  HistoryView.swift
//  Fundoshi
//
//  Created by ookamitai on 8/6/24.
//

import SwiftUI

struct HistoryView: View {
    @Binding var appConfig: AppConfig
    var body: some View {
        List {
            ForEach(Array(appConfig.history.enumerated()), id: \.offset) { (index, value) in
                HistoryCard(index: index, secs: value)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var appConfig = AppConfig(isShowingMenuBarTime: true, launchAtLogin: false, enableNotification: true, playSound: true, useTranslucency: true, fontStyle: .rounded, flipAnimation: .top, detailWindowAlpha: 1, contextClickAction: .pause, history: [])
        
        var body: some View {
            HistoryView(appConfig: $appConfig)
        }
    }
    return PreviewWrapper()
}
