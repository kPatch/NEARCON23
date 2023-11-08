//
//  PreviewFeaturesView.swift
//  RizApp
//
//  Created by Marcus Arnett on 9/22/23.
//

import SwiftUI

struct PreviewFeaturesView: View {
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .ignoresSafeArea()
            
            FeatureItemCarouselView()
        }
    }
}

#Preview {
    PreviewFeaturesView()
}
