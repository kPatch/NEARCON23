//
//  ProfileView.swift
//  App
//
//  Created by Marcus Arnett on 11/9/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var selectedTab: Int = 1
    
    var slice = UIScreen.main.bounds.width / 2
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [Color.green, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width)
                .offset(y: 150)
                .foregroundStyle(.rizzMatteBlack)
            
            ZStack {
                Circle()
                    .frame(width: 150, height: 150)
                    .offset(y: -230)
                    .foregroundStyle(.rizzWhite)
                
                Circle()
                    .frame(width: 145, height: 145)
                    .offset(y: -230)
                    .foregroundStyle(.rizzGreen)
                
                Text(self.viewModel.owner ?? "placerholder.near")
                    .bold()
                    .font(.title2)
                    .foregroundStyle(.rizzWhite)
                    .offset(y: -130)
                
                Capsule()
                    .frame(width: UIScreen.main.bounds.width - 20, height: 70)
                    .offset(y: -60)
                    .foregroundStyle(.rizzLightGray)
                
                Capsule()
                    .frame(width: UIScreen.main.bounds.width - 30, height: 60)
                    .offset(y: -60)
                    .foregroundStyle(.rizzGray)
                    .mask {
                        Rectangle()
                            .frame(width: 400, height: 400)
                            .opacity(0.9)
                            .offset(x: self.selectedTab == 1 ? slice : -slice, y: -60)
                    }

                HStack {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.rizzWhite)
                        .frame(width: 150, height: 50)
                        .offset(x: -55, y: -60)
                    
                    Text("Profile")
                        .foregroundStyle(.rizzWhite)
                        .frame(width: 150, height: 50)
                        .offset(x: -160, y: -60)
                }
                .onTapGesture {
                    withAnimation {
                        self.selectedTab = 1
                    }
                }
                
                HStack {
                    Image(systemName: "gear")
                        .foregroundStyle(.rizzWhite)
                        .frame(width: 150, height: 50)
                        .offset(x: 130, y: -60)
                    
                    Text("Settings")
                        .foregroundStyle(.rizzWhite)
                        .frame(width: 150, height: 50)
                        .offset(x: 30, y: -60)
                }
                .onTapGesture {
                    withAnimation {
                        self.selectedTab = 2
                    }
                }
            }
            
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: UIScreen.main.bounds.width, height: 300)
                .offset(y: 165)
                .foregroundStyle(.rizzLightGray)
            
            if selectedTab == 1 {
                AccountView()
            } else {
                SettingsView()
            }
        }
    }
}

struct AccountView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Text("About")
                .foregroundStyle(.rizzWhite)
                .bold()
                .font(.title2)
                .offset(x: -140, y: 35)
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16.0)
                        .frame(width: 170, height: 170)
                        .offset(x: -85, y: 50)
                        .foregroundStyle(.rizzMatteBlack)
                    
                    Image("NearLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .offset(x: -85, y: 30)
                    
                    Text("\(viewModel.amount.rounded(toPlaces: 3)) NEAR")
                        .bold()
                        .font(.title3)
                        .foregroundStyle(.rizzWhite)
                        .offset(x: -85, y: 100)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 16.0)
                        .frame(width: 170, height: 170)
                        .offset(x: -75, y: 50)
                        .foregroundStyle(.rizzMatteBlack)
                    
                    Image(systemName: "wallet.pass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75, height: 75)
                        .offset(x: -75, y: 30)
                        .foregroundStyle(.rizzWhite)
                    
                    Text("\(viewModel.nfts.count) \(viewModel.nfts.count == 1 ? "NFT" : "NFTs")")
                        .bold()
                        .font(.title2)
                        .foregroundStyle(.rizzWhite)
                        .offset(x: -75, y: 100)
                }
            }
            .offset(x: 80)
        }
        .offset(y: 100)
    }
}

struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        Button {
            self.viewModel.signout()
        } label: {
            Text("Logout")
                .foregroundStyle(RizzColors.rizzWhite)
                .font(.title2)
                .bold()
                .background {
                    Capsule()
                        .foregroundStyle(RizzColors.rizzMatteBlack)
                        .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                        .overlay {
                            Capsule()
                                .stroke(RizzColors.rizzGray, lineWidth: 5)
                        }
                }
        }
        .offset(y: 160)
    }
}

#Preview {
    ProfileView()
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
