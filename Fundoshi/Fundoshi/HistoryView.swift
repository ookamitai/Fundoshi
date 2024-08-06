//
//  HistoryView.swift
//  Fundoshi
//
//  Created by ookamitai on 8/6/24.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        List {
            Text("1")
                .onTapGesture {
                    print(1)
                }
            Text("2")
        }
    }
}

#Preview {
    HistoryView()
}
