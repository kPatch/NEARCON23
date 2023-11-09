//
//  PlaylistScrollView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct PlaylistScrollView: View {
    let nfts: [NonFungibleTokens]
    
    @State private var currentNFT: NonFungibleTokens? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(nfts) { nft in
                    if nft.imageURL.contains("<svg") {
                        Button {
                            self.currentNFT = nft
                        } label: {
                            SVGWebView(svgString: nft.imageURL)
                                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                .frame(width: 110, height: 110)
                        }
                    } else if let url = URL(string: nft.imageURL) {
                        Button {
                            self.currentNFT = nft
                        } label: {
                            AsyncImage(url: url) { image in
                                image.image?.resizable().scaledToFit()
                            }
                                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                                .frame(width: 110, height: 110)
                        }
                    } else {
                        Button {
                            self.currentNFT = nft
                        } label: {
                            RoundedRectangle(cornerRadius: 12.0)
                                .foregroundStyle(RizzColors.rizzGray)
                                .frame(width: 110, height: 110)
                        }
                    }
                }
            }
            .padding(.bottom)
            .padding(.horizontal, 22)
            .sheet(item: $currentNFT) { nftDetail in
                NFTDetailView(nft: nftDetail)
            }
        }
        .mask {
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: UIScreen.main.bounds.width - 20, height: 200)
        }
    }
}

//#Preview {
//    PlaylistScrollView(nfts: RizzOnboarding.discover[0].NFTs)
//}
