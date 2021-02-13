//
//  ContentView.swift
//  TransitionDemo
//
//  Created by nori on 2021/01/01.
//

import SwiftUI
import Router

struct Weather {
    var label: String
    var title: String
    var systemImage: String
}

class DataStore: ObservableObject {
    var data: [Weather] = [
        Weather(label: "sunny", title: "Sunny", systemImage: "sun.max"),
        Weather(label: "cloudy", title: "Cloudy", systemImage: "icloud"),
        Weather(label: "rainy", title: "Rainy", systemImage: "cloud.rain"),
        Weather(label: "snow", title: "Snow", systemImage: "snow")
    ]
}

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

            Section {
                Button(action: {
                    navigator.pop {
                        navigator.wrappedValue.path = "/account"
                    }
                }) {
                    Label("Account", systemImage: "person.fill")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Spacer()
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct DetailView: View {

    @Environment(\.navigator) private var navigator: Binding<Navigator>

    @EnvironmentObject var dataStore: DataStore

    @State var isShrink: Bool = false

    var label: String

    var weather: Weather? {
        return self.dataStore.data.filter({$0.label == self.label}).first
    }

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Image(systemName: self.weather!.systemImage)
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .scaleEffect(isShrink ? 0.8 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2))
                    .onTapGesture {
                        self.isShrink.toggle()
                    }
                Text(label)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
            }
            VStack {
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
                .padding()
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView: View {

    @State var isShow: Bool = false

    var body: some View {
        Router("/weather") {
            Route("/account") {
                AccountView()
            }
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
