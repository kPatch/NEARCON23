//
//  HomeView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                // Nav Bar
                HomeNavBarView()
                
                // My NFTs
                MyNFTsView()
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppearenceViewModel.instance)
}
