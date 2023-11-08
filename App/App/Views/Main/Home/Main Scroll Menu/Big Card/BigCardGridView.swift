//
//  BigCardGridView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct BigCardGridView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(authViewModel.nfts) { nft in
                BigCardView(nft: nft)
            }
            .padding(.bottom, 140)
        }
    }
}
#Preview {
    BigCardGridView()
}
