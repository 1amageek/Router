//
//  ContentView.swift
//  TransitionDemo
//
//  Created by nori on 2021/01/01.
//

import SwiftUI
import Router

struct AView: View {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        ZStack {
//            Color.green
            VStack(spacing: 16) {
                Button("/b push") {
                    navigator.push {
                        navigator.wrappedValue.path = "/b"
                    }
                }
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .foregroundColor(.gray)

                Button("/b pop") {
                    navigator.pop {
                        navigator.wrappedValue.path = "/b"
                    }
                }
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .foregroundColor(.gray)

            }

        }

    }
}

struct BView: View {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        ZStack {
//            Color.yellow
            VStack(spacing: 16) {
                Button("/a push") {
                    navigator.push {
                        navigator.wrappedValue.path = "/a"
                    }
                }
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .foregroundColor(.gray)

                Button("/a pop") {
                    navigator.pop {
                        navigator.wrappedValue.path = "/a"
                    }
                }
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .foregroundColor(.gray)
            }
        }

    }
}

struct ContentView: View {

    @State var isShow: Bool = false

    var body: some View {

        Router("/a") {
            Route("/a") { context in
                AView {
                    withAnimation(.easeIn(duration: 1)) {
                        self.isShow.toggle()
                    }
                }

            }
            Route("/b") { context in
                BView {
                    withAnimation(.easeIn(duration: 1)) {
                        self.isShow.toggle()
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
