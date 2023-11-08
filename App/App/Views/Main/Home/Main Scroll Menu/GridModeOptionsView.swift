//
//  GridModeOptionsView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/24/23.
//

import SwiftUI

struct GridModeOptionsView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var appearenceViewModel: AppearenceViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzGray)
                .ignoresSafeArea()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("VIEW NFT AS")
                        .bold()
                        .foregroundStyle(.gray)
                        .padding(.leading, 26)
                    
                    Button {
                        appearenceViewModel.gridMode = .collectorCluster
                        dismiss()
                    } label: {
                        ModeItemView(icon: "square.grid.2x2.fill", name: "Collectors Cluster", iconType: .sfSymbol)
                    }
                    
                    Button {
                        appearenceViewModel.gridMode = .playlist
                        dismiss()
                    } label: {
                        ModeItemView(icon: "Playlist", name: "Playlist", iconType: .asset)
                    }
                    
                    Button {
                        appearenceViewModel.gridMode = .bigCards
                        dismiss()
                    } label: {
                        ModeItemView(icon: "BigCard", name: "Big Cards", iconType: .asset)
                    }
                    
                    Button {
                        appearenceViewModel.gridMode = .masonry
                        dismiss()
                    } label: {
                        ModeItemView(icon: "Masonry", name: "Masonry", iconType: .asset)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct ModeItemView: View {
    let icon: String
    let name: String
    let iconType: IconType
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width + 10, height: 50)
                .foregroundStyle(RizzColors.rizzBlack)
            
            HStack {
                switch iconType {
                case .sfSymbol:
                    Image(systemName: "square.grid.2x2.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(RizzColors.rizzLightGray)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 24)
                case .asset:
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(RizzColors.rizzLightGray)
                        .frame(width: 20, height: 20)
                        .padding(.leading, 24)
                }
                
                Text(name)
                    .foregroundStyle(RizzColors.rizzWhite)
                    .padding(.leading, 16)
                
                Spacer()
            }
        }
    }
}

#Preview {
    GridModeOptionsView()
        .environmentObject(AppearenceViewModel.instance)
}
