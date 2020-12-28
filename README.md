
# Router


## Usage

```swift
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
```
