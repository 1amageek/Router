//
//  Router.swift
//
//
//  Created by nori on 2020/12/28.
//

import SwiftUI

public struct RouterKey: EnvironmentKey {

    public static let defaultValue: Binding<String> = .constant("/")
}

public extension EnvironmentValues {

    var routerPath: Binding<String> {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}

public struct Router<Content> : View where Content : View {

    @State private var routerPath: String = "/"

    public var content: () -> Content

    public init(_ path: String = "/", @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._routerPath = State(initialValue: path)
    }

    public var body: some View {
        self.content()
            .environment(\.routerPath, self.$routerPath)
    }
}

struct Router_Previews: PreviewProvider {
    static var previews: some View {
        Router {
            Route("/") { context in
                List {
                    Link("/foo") {
                        Text("foo")
                    }
                    Link("/bar") {
                        Text("bar")
                    }
                }
                .navigationTitle("/")
            }
            Route("/foo") { context in
                List {
                    Link("/foo") {
                        Text("foo")
                    }
                    Link("/bar") {
                        Text("bar")
                    }
                }
                .navigationTitle("/foo")
            }
            Route("/bar") { context in
                List {
                    Link("/foo") {
                        Text("foo")
                    }
                    Link("/bar") {
                        Text("bar")
                    }
                }
                .navigationTitle("/bar")
            }
            Route("/user/:uid") { context in
                List {
                    Link("/foo") {
                        Text("foo")
                    }
                    Link("/bar") {
                        Text("bar")
                    }
                }
                .navigationTitle("/bar")
            }
        }

    }
}
