//
//  ContentView.swift
//  Demo
//
//  Created by nori on 2020/12/28.
//

import SwiftUI
import Router

struct ContentView: View {

    struct User: Identifiable {
        var id: String
        var name: String
    }

    var data: [User] = [
        User(id: "000", name: "foo"),
        User(id: "001", name: "bar"),
        User(id: "002", name: "baz")
    ]

    func findUser(uid: String) -> User? {
        print("WWWW", uid)
        return self.data.filter { $0.id == uid }.first
    }

    var body: some View {
        Router("/users") {
            Route("/users") { context in
                NavigationView {
                    List(data) { user in
                        Link("/users/\(user.id)") {
                            HStack {
                                Text("\(user.name)").bold()
                                Spacer()
                                Text("id: \(user.id)")
                            }
                        }
                    }
                    .navigationTitle("Users")
                }
            }
            Route("/users/{uid}") { context in
                NavigationView {
                    VStack {
                        VStack {
                            Color.gray
                                .clipShape(Circle())
                                .frame(width: 100, height: 100, alignment: .center)
                            HStack {
                                Text("ID")
                                Text(context.paramaters["uid"]!)
                            }

                            if let user = findUser(uid: context.paramaters["uid"]!) {
                                Text(user.name).bold()
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .navigationTitle("User - \(context.paramaters["uid"] ?? "")")
                    .navigationBarItems(leading: Link("/users") {
                        Text("Back")
                    })
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
