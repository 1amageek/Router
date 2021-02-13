//
//  AccountView.swift
//  TransitionDemo
//
//  Created by nori on 2021/01/16.
//

import SwiftUI
import Router

struct AccountView: View {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        navigator.push {
                            navigator.wrappedValue.path = "/weather"
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                Spacer()
            }
            .padding()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
