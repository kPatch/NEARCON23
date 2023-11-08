//
//  FeatureItemCarouselView.swift
//  RizApp
//
//  Created by Marcus Arnett on 9/22/23.
//

import SwiftUI

struct FeatureItemCarouselView: View {
    @State private var index = 0
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12.0)
                        .ignoresSafeArea()
                        .padding(.top, 10)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
                        .foregroundStyle(RizzColors.rizzGray)
                }
            }
            
            TabView(selection: $index) {
                ForEach(0..<4, id:\.self) { index in
                    if index < 3 {
                        FeatureItemView(feature: RizzOnboarding.features[index])
                    } else {
                        ConnectWalletFeatureView(feature: RizzOnboarding.features[index])
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
}

#Preview {
    FeatureItemCarouselView()
}
