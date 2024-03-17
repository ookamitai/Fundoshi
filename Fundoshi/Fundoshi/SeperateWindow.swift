//
//  SeperateWindow.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI

struct SeperateWindow: View {
    @Binding var timeString: String
    var body: some View {
        VStack {
            Text(timeString)
                .fontDesign(.rounded)
                .font(.system(size: 35))
                .shadow(radius: 10)
                .padding(10)
                .padding(.top, -15)
        }
    }
}
