//
//  MyNFTsView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct MyNFTsView: View {
    var body: some View {
        VStack {
            // Top List View
            TopListView()
            
            // Main Scroll View
            MainHomeScrollView()
        }
    }
}

#Preview {
    MyNFTsView()
}
