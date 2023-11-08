//
//  NFTCategoryView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NFTCategoryView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<3, id:\.self) { _ in
                    ZStack {
                        Capsule()
                            .foregroundStyle(RizzColors.rizzBlack)
                            .frame(height: 50)
                        
                        HStack {
                            Image(systemName: "square.grid.2x2.fill")
                                .foregroundStyle(RizzColors.rizzWhite)
                            
                            Text("Collections")
                                .foregroundStyle(RizzColors.rizzWhite)
                        }
                        .padding(.horizontal)
                    }
                        .overlay {
                            Capsule()
                                .stroke(RizzColors.rizzBlue, lineWidth: 5)
                        }
                        .padding(.horizontal, 2)
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
