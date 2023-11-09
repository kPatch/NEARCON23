//
//  MasonryGridView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI
import SwiftUIMasonry

struct MasonryGridView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var currentNFT: NonFungibleTokens? = nil
    
    var body: some View {
        ScrollView(.vertical) {
            VMasonry(columns: 2) {
                ForEach(authViewModel.nfts) { nft in
                    Button {
                        self.currentNFT = nft
                    } label: {
                        MasonryCardView(nft: nft)
                    }
                }
            }
            .padding(.bottom, 140)
            .sheet(item: $currentNFT) { nftDetail in
                NFTDetailView(nft: nftDetail)
            }
        }
        .refreshable {
            self.authViewModel.fetchNFTs()
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    MasonryGridView()
}
