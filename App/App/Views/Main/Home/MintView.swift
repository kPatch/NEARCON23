//
//  MintView.swift
//  App
//
//  Created by Marcus Arnett on 11/9/23.
//

import SwiftUI

struct MintView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var name: String = ""
    @State private var description: String = ""

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzMatteBlack)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                UploadAssetView()
                
                InputFieldView(text: $name, name: "NFT Name")
                
                ExtendedFieldView(text: $description, name: "NFT Description")
                
                Button {
                    viewModel.mintNFT(name: self.name, description: self.description)
                } label: {
                    ZStack {
                        VStack {
                            Spacer()
                            
                            Capsule()
                                .foregroundStyle(RizzColors.rizzMatteBlack)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                                .overlay {
                                    Capsule()
                                        .stroke(RizzColors.rizzWhite, lineWidth: 5)
                                }
                        }
                        VStack {
                            Spacer()
                            
                            Text("Mint NFT")
                                .foregroundStyle(RizzColors.rizzWhite)
                                .font(.title)
                                .bold()
                                .padding(.bottom, 6)
                        }
                    }
                    .padding(.top)
                }
                
                Text("Cancel")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 6)
            }
        }
    }
}

#Preview {
    MintView()
}
