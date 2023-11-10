//
//  MintView.swift
//  App
//
//  Created by Marcus Arnett on 11/9/23.
//

import SwiftUI

struct MintView: View {
    @Environment(\.presentationMode) private var mode
    
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var name: String = ""
    @State private var description: String = ""
    @State private var hasCompleted: Bool? = nil

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzMatteBlack)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                UploadAssetView().environmentObject(viewModel)

                InputFieldView(text: $name, name: "NFT Name")

                ExtendedFieldView(text: $description, name: "NFT Description")

                Button {
                    self.hasCompleted = viewModel.mintNFT(name: self.name, description: self.description)
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
                
                Button {
                    self.mode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(RizzColors.rizzWhite)
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 6)
                }
            }
        }
        .onChange(of: self.hasCompleted) { _, newValue in
            if let newValue, newValue {
                self.mode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    MintView()
}
