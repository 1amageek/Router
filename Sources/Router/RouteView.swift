//
//  File.swift
//  
//
//  Created by nori on 2021/02/13.
//

import UIKit
import SwiftUI

struct RouteView<Content: View>: UIViewControllerRepresentable {

    typealias UIViewControllerType = UIHostingController<Content>

    let content: Content

    init(content: Content) {
        self.content = content
    }

    func makeUIViewController(context: Context) -> UIHostingController<Content> {
        return UIHostingController(rootView: content)
    }

    func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {

    }

}
