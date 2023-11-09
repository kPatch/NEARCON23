//
//  NFTCategoryView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NFTCategoryView: View {
    let names: [String] = ["Regular NFTs", "Music NFTs", "Movie NFTs", "AR NFTs"]
    let icons: [String] = ["square.grid.2x2.fill", "music.mic", "popcorn.fill", "arkit"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<4, id:\.self) { idx in
                    ZStack {
                        Capsule()
                            .foregroundStyle(RizzColors.rizzGreen)
                            .frame(height: 50)
                        
                        HStack {
                            Image(systemName: icons[idx])
                                .foregroundStyle(RizzColors.rizzMatteBlack)
                            
                            Text(names[idx])
                                .foregroundStyle(RizzColors.rizzMatteBlack)
                                .bold()
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.horizontal, 14)
        }
        .padding(.top, 4)
    }
}

#Preview {
    NFTCategoryView()
}
