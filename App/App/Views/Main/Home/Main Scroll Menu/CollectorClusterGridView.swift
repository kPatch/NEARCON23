//
//  CollectorClusterGridView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct CollectorClusterGridView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var currentDetailNFT: NonFungibleTokens?
    
    private let items = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    private let side = UIScreen.main.bounds.width / 4
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: items, spacing: 2) {
                ForEach(authViewModel.nfts) { nft in
                    if nft.imageURL.contains("<svg") {
                        Button {
                            self.currentDetailNFT = nft
                        } label: {
                            SVGWebView(svgString: nft.imageURL)
                                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                .frame(width: side, height: side)
                        }
                    } else if let url = URL(string: nft.imageURL) {
                        Button {
                            self.currentDetailNFT = nft
                        } label: {
                            AsyncImage(url: url) { image in
                                image.image?.resizable().scaledToFit()
                            }
                                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                .frame(width: side, height: side)
                        }
                    } else {
                        Button {
                            self.currentDetailNFT = nft
                        } label: {
                            RoundedRectangle(cornerRadius: 12.0)
                                .foregroundStyle(RizzColors.rizzGray)
                                .frame(width: side, height: side)
                        }
                    }
                }
            }
            .padding(.bottom, 140)
        }
        .sheet(item: $currentDetailNFT) { nftDetail in
            NFTDetailView(nft: nftDetail)
        }
        .refreshable {
            self.authViewModel.fetchNFTs()
        }
        .padding(.horizontal, 44)
    }
}
//
//#Preview {
//    CollectorClusterGridView()
//}
