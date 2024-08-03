//
//  SeperateWindow.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI

struct SeperateWindow: View {
    @Binding var timeString: String
    @State var isHovering: Bool = false
    var body: some View {
        ZStack {
            VisualEffectView()
                 .ignoresSafeArea()
            
            Text(timeString)
                .fontDesign(.rounded)
                .font(.system(size: 35))
                .shadow(radius: 10)
                .padding(5)
                .padding(.top, -25)
            /*
            Button {
                NSApplication.shared.keyWindow?.close()
            } label: {
                Text("close")
                    .opacity(isHovering ? 1 : 0.5)
                    .onHover { hovering in
                        withAnimation {
                            isHovering = hovering
                        }
                    }
            }
            .buttonStyle(.plain)
            .offset(x: -50, y: 30)
             */
        }
    }
}
