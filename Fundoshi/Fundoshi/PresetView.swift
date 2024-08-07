//
//  PresetView.swift
//  Fundoshi
//
//  Created by ookamitai on 8/7/24.
//

import SwiftUI

struct PresetView: View {
    @Binding var appConfig: AppConfig
    @State private var t1: String = ""
    @State private var t2: String = ""
    @State private var t3: String = ""
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Divider()
                                .frame(width: 10)
                        }
                        Text("Edit")
                            .font(.subheadline.lowercaseSmallCaps())
                        VStack {
                            Divider()
                        }
                    }
                    HStack {
                        TextField("Preset #1", text: $t1)
                            .onSubmit {
                                appConfig.preset[0] = Int(t1) ?? appConfig.preset[0]
                            }
                            .frame(width: 100)
                        Text("(\(appConfig.preset[0]))")
                            .font(.title3)
                    }
                    HStack {
                        TextField("Preset #2", text: $t2)
                            .onSubmit {
                                appConfig.preset[1] = Int(t1) ?? appConfig.preset[1]
                            }
                            .frame(width: 100)
                        Text("(\(appConfig.preset[1]))")
                            .font(.title3)
                    }
                    HStack {
                        TextField("Preset #3", text: $t3)
                            .onSubmit {
                                appConfig.preset[2] = Int(t1) ?? appConfig.preset[2]
                            }
                            .frame(width: 100)
                        Text("(\(appConfig.preset[2]))")
                            .font(.title3)
                    }
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
}
