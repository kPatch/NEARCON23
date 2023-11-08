//
//  MasonryCardView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct MasonryCardView: View {
    let nft: NonFungibleTokens
    
    var body: some View {
        if nft.imageURL.contains("<svg") {
            SVGWebView(svgString: nft.imageURL)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .frame(maxWidth: 185, maxHeight: 350)
        } else if let url = URL(string: nft.imageURL) {
            AsyncImage(url: url) { image in
                image.image?.resizable().scaledToFit()
            }
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .frame(maxWidth: 185, maxHeight: 350)
        } else {
            RoundedRectangle(cornerRadius: 12.0)
                .foregroundStyle(RizzColors.rizzGray)
                .frame(maxWidth: 185, maxHeight: 350)
        }
    }
}

//
//#Preview {
//    MasonryCardView(image: "CoolCat1")
//}
