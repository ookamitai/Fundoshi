//
//  SeparateWindow.swift
//  Fundoshi
//
//  Created by ookamitai on 2/24/24.
//

import SwiftUI

struct SeparateWindow: View {
    @Binding var timeString: String
    @State var isHovering: Bool = false
    @Binding var appConfig: AppConfig
    
    var body: some View {
        ZStack {
            VisualEffectView()
                 .ignoresSafeArea()
                 .opacity(appConfig.useTranslucency ? 1 : 0)
            
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text(timeString)
                        .monospacedDigit()
                        .fontDesign(getStyle(appConfig.fontStyle))
                        .contentTransition(.numericText(countsDown: appConfig.flipAnimation == .top)).transaction { t in
                            t.animation = .default
                        }
                        .contentTransition(.symbolEffect)
                        .font(.system(size: appConfig.fontStyle == .monospaced ? 30 : 35))
                        .scaleEffect(isHovering ? CGSize(width: 1, height: 1) : CGSize(width: 0.9, height: 0.9) , anchor: .center)
                        .shadow(radius: 10)
                        .padding(5)
                        .padding(.top, -25)
                        .onHover { hovering in
                            isHovering = hovering
                        }
                        .animation(.default, value: isHovering)
                    Spacer()
                }
                Spacer()
            }
            .drawingGroup(opaque: true)
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
