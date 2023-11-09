//
//  NFTTopDetailView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NFTTopDetailView: View {
    let nft: NonFungibleTokens
    
    var body: some View {
        HStack {
            VStack {
                HStack {
                    ZStack {
                        if let organization = nft.organization, let url = URL(string: organization) {
                            AsyncImage(url: url) { image in
                                image.image?.resizable().scaledToFit()
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        } else {
                            Image("DefaultOrg")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        }

                        Image("NearIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .padding(.top, 30)
                            .padding(.leading, 30)
                    }

                    VStack(alignment: .leading) {
                        Text(nft.name)
                            .font(.title2)
                            .bold()
                            .foregroundStyle(RizzColors.rizzWhite)
                            .padding(.leading, 15)

                        HStack {
                            Text(nft.collectionName)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(RizzColors.rizzWhite)
                                .padding(.leading, 15)

                            Image(systemName: "checkmark.seal.fill")
                        }
                    }

                    Spacer()
                }
                .padding(.leading, 25)
                
                Text(nft.description)
                    .foregroundStyle(RizzColors.rizzWhite)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                    .padding(.top, 30)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 8)
        }
    }
}
