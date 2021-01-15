
![SwiftUI Router](router.png "SwiftUI Router")

# Router

Router is a library that assists with SwiftUI view transitions.

## Installation

```swift
.package(name: "Router", url: "git@github.com:1amageek/Router.git", .upToNextMajor(from: "0.2.0")),
```

## Usage

### Router
The `Router` specifies the View to be navigated.
The argument of `Router` is the Path of the first View to be displayed. By default, `/` is specified.

### Route
`Route` will show the View of the Path specified in the argument.
Path has placeholders and the parameters can be accessed from context.

```swift
import SwiftUI
import Router

struct ContentView: View {

    @State var isShow: Bool = false

    var body: some View {
        Router("/weather") {
            Route("/weather") { 
                ListView()
            }
            Route("/weather/{weatherLabel}") { context in
                DetailView(label: context.paramaters["weatherLabel"]!)
            }
        }
        .environmentObject(DataStore())
    }
}
```

### Navigator

It transitions between screens by giving `Navigator` a path.
You can specify the transition animation. In the example below, we call the push animation.

```swift
struct ListView: View {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    @EnvironmentObject var dataStore: DataStore

    var body: some View {

        List {
            Section(header:
                        Text("Weather")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .padding()
            ) {
                ForEach(dataStore.data, id: \.label) { data in
                    Button(action: {
                        navigator.push {
                            navigator.wrappedValue.path = "/weather/\(data.label)"
                        }
                    }) {
                        Label(data.title, systemImage: data.systemImage)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                        Spacer()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}
```

Navigator is defined as an environment, so it can be called from anywhere.

```swift
struct DetailView: View {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    @EnvironmentObject var dataStore: DataStore

    var label: String

    var weather: Weather? {
        return self.dataStore.data.filter({$0.label == self.label}).first
    }

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Image(systemName: self.weather!.systemImage)
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                Text(label)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
            }
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        navigator.pop {
                            navigator.wrappedValue.path = "/weather"
                        }
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}
```

## Custom Transition Animation

To customize the transition animations, you must first extend AnyTransition.

```swift
public extension AnyTransition {

    struct NavigationFrontModifier: ViewModifier {
        let offset: CGSize
        public func body(content: Content) -> some View {
            ZStack {
                Color(UIColor.systemBackground)
                content
            }
            .offset(offset)
        }
    }

    static var navigationFront: AnyTransition {
        AnyTransition.modifier(
            active: NavigationFrontModifier(offset: CGSize(width: UIScreen.main.bounds.width, height: 0)),
            identity: NavigationFrontModifier(offset: .zero)
        )
    }

    struct NavigationBackModifier: ViewModifier {
        let opacity: Double
        let offset: CGSize
        public func body(content: Content) -> some View {
            ZStack {
                content
                    .offset(offset)
                Color.black.opacity(opacity)
            }
        }
    }
    
    static var navigationBack: AnyTransition {
        AnyTransition.modifier(
            active: NavigationBackModifier(opacity: 0.17, offset: CGSize(width: -UIScreen.main.bounds.width / 3, height: 0)),
            identity: NavigationBackModifier(opacity: 0, offset: .zero)
        )
    }
}
```

Next, we will extend Binding<Navigator>.

```swift
public extension Binding where Value == Navigator {

    func push<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        let insertion: AnyTransition = .navigationFront
        let removal: AnyTransition = .navigationBack
        let transition: AnyTransition = .asymmetric(insertion: insertion, removal: removal)
        self.wrappedValue.zIndex = 0
        self.wrappedValue.transition = transition
        self.wrappedValue.uuid = UUID()
        return try withAnimation(animation, body)
    }

    func pop<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        let insertion: AnyTransition = .navigationBack
        let removal: AnyTransition = .navigationFront
        let transition: AnyTransition = .asymmetric(insertion: insertion, removal: removal)
        self.wrappedValue.zIndex = 1
        self.wrappedValue.transition = transition
        self.wrappedValue.uuid = UUID()
        return try withAnimation(animation, body)
    }
}
```

It can be called as follows

```swift
navigator.push {
    navigator.wrappedValue.path = "/weather/\(data.label)"
}

navigator.pop {
    navigator.wrappedValue.path = "/weather"
}
```
