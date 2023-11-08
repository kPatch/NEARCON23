//
//  NetworkView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NetworkView: View {
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: 155, height: 50)
                .foregroundStyle(RizzColors.rizzBlack)
            
            HStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(RizzColors.rizzWhite)
                    .frame(width: 30, height: 30)
                
                Text("153 ")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .bold()
                
                Text("NFTs")
                    .foregroundStyle(RizzColors.rizzWhite)
            }
        }
        .padding(.leading)
    }
}

#Preview {
    NetworkView()
}
