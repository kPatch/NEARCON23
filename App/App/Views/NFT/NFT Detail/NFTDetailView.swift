//
//  NFTDetailView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NFTDetailView: View {
    let nft: NonFungibleTokens
    
    let side = UIScreen.main.bounds.width - 100

    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                ))

            ScrollView(showsIndicators: false) {
                VStack {
                    if nft.imageURL.contains("<svg") {
                        SVGWebView(svgString: nft.imageURL)
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .frame(minWidth: side, maxHeight: side)
                    } else if let url = URL(string: nft.imageURL) {
                        AsyncImage(url: url) { image in
                            image.image?.resizable().scaledToFit()
                        }
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .frame(minWidth: side, maxHeight: side)
                    } else {
                        RoundedRectangle(cornerRadius: 12.0)
                            .foregroundStyle(RizzColors.rizzGray)
                            .frame(width: side, height: side)
                    }

                    NFTDetailFeaturesView(nft: self.nft)

                    ZStack {
                        NFTTopDetailView(nft: self.nft)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 12.0)
                            .padding(.horizontal, 8)
                            .frame(width: UIScreen.main.bounds.width)
                            .foregroundStyle(RizzColors.rizzGray)
                    }
                }
            }
        }
    }
}

struct NFTDetailFeaturesView: View {
    let nft: NonFungibleTokens
    
    var body: some View {
        HStack {
            HStack {
                Capsule()
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: 110, height: 45)
                    .overlay {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                            
                            Text("Send")
                                .bold()
                        }
                    }
                
                Spacer()
                
                Capsule()
                    .foregroundStyle(RizzColors.rizzPink)
                    .frame(width: 110, height: 45)
                    .overlay {
                        HStack {
                            Image(systemName: "arkit")
                            
                            Text("AR it")
                                .bold()
                        }
                    }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
}
