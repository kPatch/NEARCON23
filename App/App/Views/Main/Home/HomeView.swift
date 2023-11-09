//
//  HomeView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    // Nav Bar
                    HomeNavBarView()
                    
                    // My NFTs
                    MyNFTsView()
                }
            }
        }
        .refreshable {
            self.viewModel.fetchNFTs()
        }
        .onAppear {
            self.viewModel.fetchNFTs()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppearenceViewModel.instance)
}
