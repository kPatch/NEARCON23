//
//  PlaylistCategoryHeaderView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct PlaylistCategoryHeaderView: View {
    let name: String
    let amount: Int
//    let icon: String
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Image("EthLogo")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                    
//                    Image(icon)
//                        .resizable()
//                        .scaledToFit()
//                        .clipShape(Circle())
//                        .frame(width: 50, height: 50)
                    
//                    Image("EthLogo")
//                        .resizable()
//                        .scaledToFit()
//                        .foregroundStyle(.white)
//                        .frame(width: 16, height: 16)
//                        .padding(.top, 30)
//                        .padding(.leading, 30)
                }
                
                Text(name)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(RizzColors.rizzWhite)
                    .padding(.leading, 15)
                
                Text(" (\(amount))")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Spacer()
            }
            .padding(.leading, 25)
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 2)
    }
}


//#Preview {
//    PlaylistCategoryHeaderView(name: "Cool Cats", amount: 99, icon: "CoolCatLogo")
//}
