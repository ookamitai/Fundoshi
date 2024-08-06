//
//  HistoryCard.swift
//  Fundoshi
//
//  Created by ookamitai on 8/6/24.
//

import SwiftUI

struct HistoryCard: View {
    @State var index: Int
    @State var secs: Int
    var body: some View {
        HStack {
            VStack {
                Text("Entry #\(index)")
                    .font(.system(.caption).lowercaseSmallCaps())
                    .foregroundStyle(.secondary)
                Text("\(buildString(secs: secs))")
                    .font(.title) 
            }
            Spacer()
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            HistoryCard(index: 3, secs: 996)
        }
    }
    return PreviewWrapper()
}
