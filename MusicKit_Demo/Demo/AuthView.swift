//
//  Auth.swift
//  MusicKit_Demo
//
//  Created by Shunzhe on 2022/01/22.
//

import SwiftUI
import MusicKit

struct AuthView: View {
    
    @State private var currentAuthStatus: MusicAuthorization.Status
    
    init() {
        _currentAuthStatus = .init(initialValue: MusicAuthorization.currentStatus)
    }
    
    var body: some View {
        Form {
            
            switch currentAuthStatus {
            case .notDetermined:
                Text("Authorization status not yet determined.")
            case .authorized:
                Text("Access granted")
            case .denied:
                Text("Access denied")
            case .restricted:
                Text("User cannot access MusicKit settings.")
            @unknown default:
                Text("Unknown case")
            }
            
            Button("Request authorization") {
                Task {
                    await MusicAuthorization.request()
                }
            }
            
            Button("Reload authorization status") {
                self.currentAuthStatus = MusicAuthorization.currentStatus
            }
            
        }
    }
    
}
