//
//  SplashScreenView.swift
//  RizApp
//
//  Created by Marcus Arnett on 9/22/23.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzBlack)
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Image("RIZZLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 275, height: 200)
                }
                    .padding(.bottom, 320)
                
                Text("OpenDive Technologies Copyright 2023")
                    .foregroundStyle(RizzColors.rizzWhite)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
