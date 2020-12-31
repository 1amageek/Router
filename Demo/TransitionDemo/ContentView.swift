//
//  ContentView.swift
//  TransitionDemo
//
//  Created by nori on 2021/01/01.
//

import SwiftUI
import Router

struct AView: View {

    @Environment(\.routerPath) private var routerPath: Binding<String>

    var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        ZStack {
            Color.red
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)

            Button("/b") {
                withAnimation {
                    routerPath.wrappedValue = "/b"
                }
            }.foregroundColor(.white)
        }

    }
}

struct BView: View {

    @Environment(\.routerPath) private var routerPath: Binding<String>

    var action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        ZStack {
            Color.blue
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)

            Button("/a") {
                withAnimation {
                    routerPath.wrappedValue = "/a"
                }
            }.foregroundColor(.white)
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
            }.transition(.asymmetric(insertion: .slide, removal: .identity))
            Route("/b") { context in
                BView {
                    withAnimation(.easeIn(duration: 1)) {
                        self.isShow.toggle()
                    }
                }
            }.transition(.move(edge: .leading))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
