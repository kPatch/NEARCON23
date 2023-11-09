//
//  BigCardGridView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct BigCardGridView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentDetailNFT: NonFungibleTokens?
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(authViewModel.nfts) { nft in
                Button {
                    self.currentDetailNFT = nft
                } label: {
                    BigCardView(nft: nft)
                }
            }
            .padding(.bottom, 140)
            .sheet(item: $currentDetailNFT) { nftDetail in
                NFTDetailView(nft: nftDetail)
            }
        }
    }
}
#Preview {
    BigCardGridView()
}
