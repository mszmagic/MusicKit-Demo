//
//  SubscriptionInfoView.swift
//  MusicKit_Demo
//
//  Created by Shunzhe on 2022/01/22.
//

import SwiftUI
import MusicKit

struct SubscriptionInfoView: View {
    
    @State private var musicSubscription: MusicSubscription?
    @State private var showAppleMusicSubscriptionOfferView: Bool = false
    
    var body: some View {
        List {
            
            if let musicSubscription = musicSubscription {
                
                HStack {
                    Text("Can subscribe to Apple Music")
                    Spacer()
                    Image(systemName: musicSubscription.canBecomeSubscriber ? "checkmark.circle.fill" : "xmark")
                }
                
                if musicSubscription.canBecomeSubscriber {
                    Button("Promopt the user to subscribe to Apple Music") {
                        self.showAppleMusicSubscriptionOfferView = true
                    }
                    .musicSubscriptionOffer(isPresented: $showAppleMusicSubscriptionOfferView)
                }
                
                HStack {
                    Text("Can play content from Apple Music")
                    Spacer()
                    Image(systemName: musicSubscription.canPlayCatalogContent ? "checkmark.circle.fill" : "xmark")
                }
                
                if !musicSubscription.canBecomeSubscriber,
                   musicSubscription.canPlayCatalogContent {
                    Text("The user is already subscribed to Apple Music.")
                }
                
                HStack {
                    Text("Has iCloud music Library enabled")
                    Spacer()
                    Image(systemName: musicSubscription.hasCloudLibraryEnabled ? "checkmark.circle.fill" : "xmark")
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
