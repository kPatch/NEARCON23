//
//  MainNavBarView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct MainNavBarView: View {
    var body: some View {
        HStack {
            // Networks View
            NetworkView()
            
            Spacer()
            
            // Profile Sidebar View
            ProfileSidebarView()
        }
    }
}

#Preview {
    MainNavBarView()
}
