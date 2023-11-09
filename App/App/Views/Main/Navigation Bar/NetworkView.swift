//
//  NetworkView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NetworkView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: 155, height: 50)
                .foregroundStyle(RizzColors.rizzBlack)
            
            HStack {
                Image("NearIcon")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(RizzColors.rizzWhite)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                Text("\(viewModel.nfts.count) ")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .bold()
                
                Text("\(viewModel.nfts.count == 1 ? "NFT" : "NFTs")")
                    .foregroundStyle(RizzColors.rizzWhite)
            }
        }
        .padding(.leading)
    }
}

#Preview {
    NetworkView()
}
