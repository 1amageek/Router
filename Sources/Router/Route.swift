//
//  Route.swift
//  
//
//  Created by nori on 2020/12/28.
//

import SwiftUI

public struct Context {

    public var path: String

    public var pattern: String

    init(pattern: String, path: String) {
        self.pattern = pattern
        self.path = path
    }

    public var paramaters: [String: String] { getParamaters(path: path, pattern: pattern) }

    public var isMatch: Bool {
        if path == pattern {
            return true
        }
        guard let matchPath: String = self.matchPath(path: path, pattern: pattern) else {
            return false
        }
        if matchPath.split(separator: "/").count == pattern.split(separator: "/").count &&
            matchPath.split(separator: "/").count == path.split(separator: "/").count {
            return true
        }
        return false
    }

    private func matchPath(path: String, pattern: String) -> String? {
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "\\{(\\S+?)\\}", options: [])
        let results: [NSTextCheckingResult] = regex.matches(in: pattern, options: [], range: NSRange(0..<pattern.count))
        let matchPattern: String = results
            .map { result -> String in
                let start = pattern.index(pattern.startIndex, offsetBy: result.range(at: 0).location)
                let end = pattern.index(start, offsetBy: result.range(at: 0).length)
                return String(pattern[start..<end])
            }
            .reduce(pattern) { (prev, current) -> String in
                return prev.replacingOccurrences(of: current, with: "(.+)")
            }
        let values: [String] = try! NSRegularExpression(pattern: matchPattern, options: [])
            .matches(in: path, options: [], range: NSRange(0..<path.count))
            .map({ result -> String  in
                let start = path.index(path.startIndex, offsetBy: result.range(at: 0).location)
                let end = path.index(start, offsetBy: result.range(at: 0).length)
                return String(path[start..<end])
            })
        return values.first
    }

    private func getParamaters(path: String, pattern: String) -> [String: String] {
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "\\{(\\S+?)\\}", options: [])
        let results: [NSTextCheckingResult] = regex.matches(in: pattern, options: [], range: NSRange(0..<pattern.count))
        let keys: [String] = results
            .map { result -> String in
                let start = pattern.index(pattern.startIndex, offsetBy: result.range(at: 1).location)
                let end = pattern.index(start, offsetBy: result.range(at: 1).length)
                return String(pattern[start..<end])
            }
        let matchPattern: String = results
            .map { result -> String in
                let start = pattern.index(pattern.startIndex, offsetBy: result.range(at: 0).location)
                let end = pattern.index(start, offsetBy: result.range(at: 0).length)
                return String(pattern[start..<end])
            }
            .reduce(pattern) { (prev, current) -> String in
                return prev.replacingOccurrences(of: current, with: "(.+)")
            }
        guard let values: [String] = try! NSRegularExpression(pattern: matchPattern, options: [])
                .matches(in: path, options: [], range: NSRange(0..<path.count))
                .map({ result -> [String]  in
                    return (0..<result.numberOfRanges)
                        .map { idx -> String in
                            let start = path.index(path.startIndex, offsetBy: result.range(at: idx).location)
                            let end = path.index(start, offsetBy: result.range(at: idx).length)
                            return String(path[start..<end])
                        }
                }).first else {
            return [:]
        }
        let _values: [String] = Array(values.dropFirst())
        var params: [String: String] = [:]
        for (index, key) in keys.enumerated() {
            params[key] = _values[index]
        }
        return params
    }
}

struct RouteModifier: ViewModifier {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    let path: String

    func body(content: Self.Content) -> some View {
        return content
            .transition(navigator.wrappedValue.transition)
            .id(navigator.wrappedValue.uuid.uuidString)
            .zIndex(Context(pattern: self.path, path: navigator.wrappedValue.path).isMatch ? navigator.wrappedValue.zIndex : 0)
            .onDisappear(perform: {
                navigator.wrappedValue.zIndex = 0
            })
    }
}

public struct Route<Content> : View where Content : View {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    private var path: String

    private var contentWithContext: ((Context) -> Content)!

    private var content: (() -> Content)!

    public init(_ path: String, @ViewBuilder content: @escaping (Context) -> Content) {
        self.path = path
        self.contentWithContext = content
    }

    public init(_ path: String, @ViewBuilder content: @escaping () -> Content) {
        self.path = path
        self.content = content
    }

    @ViewBuilder
    var _bodyWithContext: some View {
        if Context(pattern: self.path, path: navigator.wrappedValue.path).isMatch {
            self.contentWithContext(Context(pattern: self.path, path: navigator.wrappedValue.path))
                .modifier(RouteModifier(path: self.path))
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var _body: some View {
        if Context(pattern: self.path, path: navigator.wrappedValue.path).isMatch {
            self.content()
                .modifier(RouteModifier(path: self.path))
        } else {
            EmptyView()
        }
    }

    public var body: some View {
        if self.contentWithContext != nil {
            _bodyWithContext
        } else {
            _body
        }
    }
}

struct Route_Previews: PreviewProvider {
    static var previews: some View {
        Route("/foo") { context in
            Text("test")
        }
    }
}
