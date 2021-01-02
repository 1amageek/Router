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
            Color.green
            VStack {
                Text("A").bold()
                Text("\(navigator.wrappedValue.path)")
                Button("/b") {
                    navigator.push {
                        navigator.wrappedValue.path = "/b"
                    }
                }.foregroundColor(.white)
                Button("/back") {
                    navigator.pop {
                        navigator.wrappedValue.path = "/b"
                    }
                }.foregroundColor(.white)

                NavigationLink("Navigation", destination: BView(action: {}))
                    .foregroundColor(.white)
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
            Color.yellow
//                .frame(width: UIScreen.main.bounds.width, height: 400, alignment: .center)

            VStack {
                Text("B").bold()
                Text("\(navigator.wrappedValue.path)")
                Button("/a") {
                    navigator.push {
                        navigator.wrappedValue.path = "/a"
                    }
                }.foregroundColor(.white)
                Button("/back") {
                    navigator.pop {
                        navigator.wrappedValue.path = "/a"
                    }
                }.foregroundColor(.white)

                NavigationLink("Navigation", destination: AView(action: {}))
                    .foregroundColor(.white)
            }
        }

    }
}

struct ContentView: View {

    @State var isShow: Bool = false

    var body: some View {

        Router("/a") {
            Route("/a") { context in
                NavigationView {
                    AView {
                        withAnimation(.easeIn(duration: 1)) {
                            self.isShow.toggle()
                        }
                    }
//                    .navigationTitle("a")
                }
            }
            Route("/b") { context in
                NavigationView {
                    BView {
                        withAnimation(.easeIn(duration: 1)) {
                            self.isShow.toggle()
                        }
                    }
//                    .navigationTitle("b")
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
