import SwiftUI

struct AboutView: View {
    @State private var isHovering = false
    @State private var animateHeading = false
    @State private var animateVersion = false
    @State private var animateAuthor = false
    @State private var animateInfo = false
    @State private var animateQuit = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Fundoshi")
                                .font(.system(size: 30))
                                .fontWeight(.light)
                                .opacity(animateHeading ? 1 : 0)
                                .offset(x: animateHeading ? 0 : -10)
                                .task {
                                    try? await Task.sleep(nanoseconds: 0_100_000_000)
                                    animateHeading = true
                                }
                                .animation(.default, value: animateHeading)
                                .padding(.leading, 10)
                            Text("v1.3.3")
                                .font(.system(size: 15))
                                .fontWeight(.ultraLight)
                                .opacity(animateVersion ? 1 : 0)
                                .offset(y: 6)
                                .offset(x: animateVersion ? 0 : -10)
                                .task {
                                    try? await Task.sleep(nanoseconds: 0_150_000_000)
                                    animateVersion = true
                                }
                                .animation(.default, value: animateVersion)
                        }
                        HStack {
                            Spacer()
                                .frame(width: 100)
                            Text("by ookamitai")
                                .italic()
                                .font(.system(size: 15))
                                .fontWeight(.ultraLight)
                                .opacity(animateAuthor ? 1 : 0)
                                .offset(x: animateAuthor ? 0 : -10)
                                .task {
                                    try? await Task.sleep(nanoseconds: 0_200_000_000)
                                    animateAuthor = true
                                }
                                .animation(.default, value: animateAuthor)
                        }
                        Spacer()
                            .frame(height: 30)
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("Check out the [github repository](https://github.com/ookamitai/Fundoshi).")
                                .opacity(animateInfo ? 1 : 0)
                                .offset(x: animateInfo ? 0 : -10)
                                .task {
                                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                                    animateInfo = true
                                }
                                .animation(.default, value: animateInfo)
                        }
                        Spacer()
                        Button {
                            NSApplication.shared.terminate(self)
                        } label: {
                            Text("Quit")
                        }
                        .opacity(animateQuit ? 1 : 0)
                        .task {
                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                            animateQuit = true
                        }
                        .animation(.default, value: animateQuit)
                    }
                    Spacer()
                }
                .padding(5)
                Spacer()
            }
            .padding()
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    ZStack {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 256, height: 256)
                            .offset(x: 70, y: 80)
                            .opacity(isHovering ? 0.1 : /* 0.05 */ 0)
                            .blur(radius: isHovering ? 8 : 10)
                            .animation(.default, value: isHovering)
                        Text("About")
                            .font(.system(size: 30))
                            .fontWeight(.ultraLight)
                            .offset(x: isHovering ? 60 : 50, y: 85)
                            .opacity(isHovering ? 0.6 : /* 0.2 */ 0)
                            .blur(radius: isHovering ? 0 : 3)
                            .animation(.default, value: isHovering)
                    }
                }
            }
        }
        .onHover { isHovered in
            isHovering = isHovered
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        var body: some View {
            AboutView()
        }
    }
    return PreviewWrapper()
}
