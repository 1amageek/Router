//
//  Router.swift
//
//
//  Created by nori on 2020/12/28.
//

import SwiftUI

class Controller: ObservableObject {
    @Published var path: String = "/"

    func to(_ path: String) {
        self.path = path
    }
}

public struct Router<Content> : View where Content : View {

    @ObservedObject private var controller: Controller = Controller()

    public var content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        self.content().environmentObject(self.controller)
    }
}

struct Router_Previews: PreviewProvider {
    static var previews: some View {
        Router {
            Route("/") {
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
            Route("/foo") {
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
            Route("/bar") {
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
