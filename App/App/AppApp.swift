//
//  RizAppApp.swift
//  RizApp
//
//  Created by Marcus Arnett on 9/22/23.
//

import SwiftUI

@main
struct RizzAppApp: App {
    @State private var isOnSplashscreen = true
    
    @StateObject var authViewModel = AuthViewModel.instance
    @StateObject var appearenceViewModel = AppearenceViewModel.instance
    
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
                if self.authViewModel.session != nil {
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
