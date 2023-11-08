//
//  BigCardView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct BigCardView: View {
    let nft: NonFungibleTokens
    
    var body: some View {
        if nft.imageURL.contains("<svg") {
            SVGWebView(svgString: nft.imageURL)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
        } else if let url = URL(string: nft.imageURL) {
            AsyncImage(url: url) { image in
                image.image?.resizable().scaledToFit()
            }
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
        } else {
            RoundedRectangle(cornerRadius: 12.0)
                .foregroundStyle(RizzColors.rizzGray)
                .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
        }
    }
}
//
//#Preview {
//    BigCardView(image: "CoolCat1")
//}
