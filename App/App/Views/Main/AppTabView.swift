//
//  AppTabView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct AppTabView: View {
    @State private var index: Int = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzMatteBlack)
                .ignoresSafeArea()
            
            if index == 0 {
                HomeView()
            } else if index == 1 {
                EventsView()
            }
            
            MenuDockView(index: $index)
        }
    }
}

#Preview {
    AppTabView()
        .environmentObject(AppearenceViewModel.instance)
}
