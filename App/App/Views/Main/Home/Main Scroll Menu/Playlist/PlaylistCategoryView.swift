//
//  PlaylistCategoryView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct PlaylistCategoryView: View {
    let name: String
    let nfts: [NonFungibleTokens]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: UIScreen.main.bounds.width - 20, height: 200)
                .foregroundStyle(RizzColors.rizzLightGray)
            
            VStack {
                PlaylistCategoryHeaderView(name: name, amount: nfts.count)
                PlaylistScrollView(nfts: nfts)
            }
        }
        .padding(.vertical, 0.25)
    }
}

//#Preview {
//    PlaylistCategoryView(category: RizzOnboarding.discover[0])
//}
