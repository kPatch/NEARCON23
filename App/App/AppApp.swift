//
//  RizAppApp.swift
//  RizApp
//
//  Created by Marcus Arnett on 9/22/23.
//

import SwiftUI
import Firebase

@main
struct RizzAppApp: App {
    @State private var isOnSplashscreen = true
    
    @StateObject var authViewModel = AuthViewModel.instance
    @StateObject var appearenceViewModel = AppearenceViewModel.instance
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            if self.isOnSplashscreen {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                self.isOnSplashscreen = false
                            }
                        }
                    }
            } else {
                if authViewModel.privateKey != nil, authViewModel.owner != nil {
                    NavigationStack {
                        AppTabView()
                            .environmentObject(self.authViewModel)
                            .environmentObject(self.appearenceViewModel)
                    }
                } else {
                    PreviewFeaturesView()
                        .environmentObject(self.authViewModel)
                }
            }
        }
    }
}
