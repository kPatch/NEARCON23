//
//  PlaylistGridView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct PlaylistGridView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(authViewModel.playlist.keys.map { String($0) }, id: \.self) { key in
                    PlaylistCategoryView(name: key, nfts: authViewModel.playlist[key]!)
                }
                .padding(.bottom, 140)
            }
        }
    }
}

//#Preview {
//    PlaylistGridView()
//}
