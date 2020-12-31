//
//  Link.swift
//  
//
//  Created by nori on 2020/12/28.
//

import SwiftUI

public struct Link<Content> : View where Content : View {

    @Environment(\.routerPath) private var routerPath: Binding<String>

    public var to: String
    
    public var content: () -> Content
    
    public init(_ to: String, @ViewBuilder content: @escaping () -> Content) {
        self.to = to
        self.content = content
    }
    
    public var body: some View {
        Button(action: {
            self.routerPath.wrappedValue = self.to
        }) {
            self.content()
        }
    }
}

struct Link_Previews: PreviewProvider {
    static var previews: some View {
        Link("") {
            Text("foo")
        }
    }
}
