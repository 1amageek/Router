//
//  SwiftUIView.swift
//  
//
//  Created by nori on 2020/12/28.
//

import SwiftUI

public struct Route<Content> : View where Content : View {

    @EnvironmentObject var controller: Controller

    public var path: String

    public var content: () -> Content

    public init(_ path: String, @ViewBuilder content: @escaping () -> Content) {
        self.path = path
        self.content = content
    }

    public var body: some View {
        if self.controller.path == self.path {
            self.content()
        } else {
            EmptyView()
        }
    }
}

struct Route_Previews: PreviewProvider {
    static var previews: some View {
        Route("/foo") {
            Text("test")
        }
    }
}
