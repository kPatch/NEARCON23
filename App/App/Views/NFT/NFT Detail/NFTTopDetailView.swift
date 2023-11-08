//
//  NFTTopDetailView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NFTTopDetailView: View {
    var body: some View {
        HStack {
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 16, height: 16)
                            .padding(.top, 30)
                            .padding(.leading, 30)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("#7738")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(RizzColors.rizzWhite)
                            .padding(.leading, 15)
                        
                        HStack {
                            Text("Bored Ape Yacth Club")
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
                
                NFTPropertiesView()
                    .padding(.top, 10)
                
                Spacer()
            }
            .padding(.top, 20)
            .padding(.bottom, 8)
        }
    }
}

#Preview {
    NFTTopDetailView()
}
