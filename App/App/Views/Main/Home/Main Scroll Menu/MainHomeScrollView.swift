//
//  MainHomeScrollView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct MainHomeScrollView: View {
    @EnvironmentObject var appearenceViewModel: AppearenceViewModel
    
    var body: some View {
        switch appearenceViewModel.gridMode {
        case .collectorCluster:
            CollectorClusterGridView()
        case .bigCards:
            BigCardGridView()
        case .playlist:
            PlaylistGridView()
        case .masonry:
            MasonryGridView()
        }
    }
}

#Preview {
    MainHomeScrollView()
        .environmentObject(AppearenceViewModel.instance)
}
