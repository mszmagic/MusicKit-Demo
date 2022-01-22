//
//  SearchMusicView.swift
//  MusicKit_Demo
//
//  Created by Shunzhe on 2022/01/22.
//

import SwiftUI
import MusicKit

struct SearchMusicView: View {
    
    @State private var searchTerm: String = ""
    @State private var searchResultSongs: MusicItemCollection<Song> = []
    @State private var isPerformingSearch: Bool = false
    
    @State private var musicSubscription: MusicSubscription?
    private var resultLimit: Int = 5
    
    var body: some View {
        
        Form {
            
            Section {
                TextField("Search term", text: $searchTerm)
            }
            
            Button("Perform search") {
                Task {
                    /*
                     Here, we're searching for songs,
                     you can also modify the parameters to search for
                     artists, albums, or other types of data.
                     */
                    do {
                        let request = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                        self.isPerformingSearch = true
                        let response = try await request.response()
                        self.isPerformingSearch = false
                        self.searchResultSongs = response.songs
                    } catch {
                        print(error.localizedDescription)
                        fatalError("Error")
                        // Have you created a token? Please refer to https://developer.apple.com/documentation/musickit/using-automatic-token-generation-for-apple-music-api
                        // If you cannot find this app within the Identifiers' list, try to add any entitlement in the Xcode project window (like `iCloud` or `Push notification`) so that Xcode can automatically create a provisioning profile for this app.
                    }
                }
            }
            .disabled(!(musicSubscription?.canPlayCatalogContent ?? false) || isPerformingSearch)
            
            if isPerformingSearch {
                ProgressView()
            }
            
            ForEach(self.searchResultSongs) { song in
                HStack {
                    VStack {
                        Text(song.title)
                        Text("\(song.artistName) \(song.albumTitle ?? "")")
                        if let maximumWidth = song.artwork?.maximumWidth,
                           let maximumHeight = song.artwork?.maximumHeight,
                           let artworkURL = song.artwork?.url(width: maximumWidth, height: maximumHeight) {
                            AsyncImage(url: artworkURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            
        }
        .task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                self.musicSubscription = subscription
            }
        }
        
    }
    
}

struct SearchMusicView_Previews: PreviewProvider {
    static var previews: some View {
        SearchMusicView()
    }
}
