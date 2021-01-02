//
//  Router.swift
//
//
//  Created by nori on 2020/12/28.
//

import SwiftUI

public struct Navigator {

    public var path: String

    public var transition: AnyTransition = .identity

    var zIndex: Double = 0

    var uuid: UUID = UUID()

    public init(_ path: String) {
        self.path = path
    }
}

public extension AnyTransition {

    struct NavigationViewModifier: ViewModifier {
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
    
    static var navigationTransition: AnyTransition {
        AnyTransition.modifier(
            active: NavigationViewModifier(opacity: 0.15, offset: CGSize(width: -UIScreen.main.bounds.width / 3, height: 0)),
            identity: NavigationViewModifier(opacity: 0, offset: .zero)
        )
    }
}

public extension Binding where Value == Navigator {

    func push<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        let insertion: AnyTransition = .move(edge: .trailing)
        let removal: AnyTransition = .navigationTransition
        let transition: AnyTransition = .asymmetric(insertion: insertion, removal: removal)
        self.wrappedValue.zIndex = 0
        self.wrappedValue.transition = transition
        self.wrappedValue.uuid = UUID()
        return try withAnimation(animation, body)
    }

    func pop<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
        let insertion: AnyTransition = .navigationTransition
        let removal: AnyTransition = .move(edge: .trailing)
        let transition: AnyTransition = .asymmetric(insertion: insertion, removal: removal)
        self.wrappedValue.zIndex = 1
        self.wrappedValue.transition = transition
        self.wrappedValue.uuid = UUID()
        return try withAnimation(animation, body)
    }
}

public struct NavigatorKey: EnvironmentKey {
    public static let defaultValue: Binding<Navigator> = .constant(Navigator("/"))
}

public extension EnvironmentValues {
    var navigator: Binding<Navigator> {
        get { self[NavigatorKey.self] }
        set { self[NavigatorKey.self] = newValue }
    }
}

public struct Router<Content> : View where Content : View {

    @State private var navigator: Navigator = Navigator("/")

    public var content: () -> Content

    public init(_ path: String = "/", @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self._navigator = State(initialValue: Navigator(path))
    }

    public var body: some View {
        self.content()
            .environment(\.navigator, self.$navigator)
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
