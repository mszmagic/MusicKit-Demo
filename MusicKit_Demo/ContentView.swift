//
//  ContentView.swift
//  MusicKit_Demo
//
//  Created by Shunzhe on 2022/01/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Auth") {
                    AuthView()
                }
                NavigationLink("Subscription Information") {
                    SubscriptionInfoView()
                }
                NavigationLink("Search for music") {
                    SearchSongsView()
                }
                NavigationLink("Search for album") {
                    SearchAlbumView()
                }
            }
            .navigationTitle("MusicKit demo")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
