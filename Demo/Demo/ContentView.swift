//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2020/12/28.
//

import SwiftUI
import Router

struct ContentView: View {
    var body: some View {
        Router {
            Route("/") {
                NavigationView {
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
            }
            Route("/foo") {
                NavigationView {
                    List {
                        Link("/") {
                            Text("/")
                        }
                        Link("/bar") {
                            Text("bar")
                        }
                    }
                    .navigationTitle("/foo")
                }
            }
            Route("/bar") {
                NavigationView {
                    List {
                        Link("/") {
                            Text("/")
                        }
                        Link("/foo") {
                            Text("foo")
                        }
                    }
                    .navigationTitle("/bar")
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
