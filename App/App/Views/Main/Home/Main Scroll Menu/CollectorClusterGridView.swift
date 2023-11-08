//
//  CollectorClusterGridView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct CollectorClusterGridView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    private let items = [
        GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())
    ]
    private let side = UIScreen.main.bounds.width / 4
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: items, spacing: 2) {
                ForEach(authViewModel.nfts) { nft in
                    if nft.imageURL.contains("<svg") {
                        SVGWebView(svgString: nft.imageURL)
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .frame(width: side, height: side)
                    } else if let url = URL(string: nft.imageURL) {
                        AsyncImage(url: url) { image in
                            image.image?.resizable().scaledToFit()
                        }
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .frame(width: side, height: side)
                    } else {
                        RoundedRectangle(cornerRadius: 12.0)
                            .foregroundStyle(RizzColors.rizzGray)
                            .frame(width: side, height: side)
                    }
                }
            }
            .padding(.bottom, 140)
        }
        .padding(.horizontal, 44)
    }
}
//
//#Preview {
//    CollectorClusterGridView()
//}
