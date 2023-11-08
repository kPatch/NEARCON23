//
//  FeatureItemView.swift
//  RizApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct FeatureItemView: View {
    let feature: FeatureItem
    
    var body: some View {
        ZStack {
            VStack {
                Image(feature.icon)
                    .frame(width: 128, height: 128)
                    .padding(.top, 200)
                
                Spacer()
            }
            
            VStack {
                Text(feature.title)
                    .foregroundStyle(RizzColors.rizzWhite)
                    .font(.title)
                    .bold()
                    .padding(.top, 380)
                
                Text(feature.description)
                    .foregroundStyle(RizzColors.rizzWhite)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
                    .font(.headline)
                    .padding(.horizontal, 30)
            }
            .padding(.top, 20)
        }
    }
}

#Preview {
    FeatureItemView(feature: RizzOnboarding.features[0])
}
