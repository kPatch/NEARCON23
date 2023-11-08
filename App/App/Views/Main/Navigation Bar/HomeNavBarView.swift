//
//  HomeNavBarView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct HomeNavBarView: View {
    var body: some View {
        VStack {
            // Main Nav Bar
            MainNavBarView()
            
            // NFT Category
            NFTCategoryView()
        }
    }
}

#Preview {
    HomeNavBarView()
}
