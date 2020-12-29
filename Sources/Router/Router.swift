//
//  Router.swift
//
//
//  Created by nori on 2020/12/28.
//

import SwiftUI

class Controller: ObservableObject {
    
    @Published var path: String

    init(_ path: String) {
        self.path = path
    }

    func to(_ path: String) {
        self.path = path
    }
}

public struct Router<Content> : View where Content : View {

    @ObservedObject private var controller: Controller

    public var content: () -> Content

    public init(_ path: String = "/", @ViewBuilder content: @escaping () -> Content) {
        self.controller = Controller(path)
        self.content = content
    }

    public var body: some View {
        self.content().environmentObject(self.controller)
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
