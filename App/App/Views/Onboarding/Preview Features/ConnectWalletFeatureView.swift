//
//  ConnectWalletFeatureView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct ConnectWalletFeatureView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let feature: FeatureItem
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    RoundedRectangle(cornerRadius: 12.0)
                        .frame(width: 75, height: 75)
                        .padding(.top, 400)
                    
                    Text(feature.title)
                        .foregroundStyle(RizzColors.rizzWhite)
                        .font(.title)
                        .bold()
                    
                    Text(feature.description)
                        .foregroundStyle(RizzColors.rizzWhite)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.horizontal, 30)
                }
            }
            
            Button {
                Task {
                    await self.authViewModel.connectWallet()
                }
            } label: {
                ZStack {
                    VStack {
                        Spacer()
                        
                        Capsule()
                            .foregroundStyle(RizzColors.rizzWhite)
                            .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            .overlay {
                                Capsule()
                                    .stroke(RizzColors.rizzBlue, lineWidth: 5)
                            }
                    }
                    VStack {
                        Spacer()
                        
                        Text("Connect Wallet")
                            .foregroundStyle(RizzColors.rizzBlue)
                            .font(.title)
                            .padding(.bottom, 6)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    ConnectWalletFeatureView(feature: RizzOnboarding.features[0])
}
