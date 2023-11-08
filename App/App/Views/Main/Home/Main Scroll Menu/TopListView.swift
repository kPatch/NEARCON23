//
//  TopListView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct TopListView: View {
    @EnvironmentObject var appearenceViewModel: AppearenceViewModel
    
    @State private var isChangingGridMode: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(RizzColors.rizzWhite)
                    .frame(width: 25, height: 25)
                
                Text("My NFTs")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .bold()
                    .font(.system(size: 18))
            }
            .padding(.leading, 10)
            
            Spacer()
            
            switch appearenceViewModel.gridMode {
            case .collectorCluster:
                Button {
                    isChangingGridMode = true
                } label: {
                    ModalTagView(name: "Collectors Cluster", icon: "square.grid.2x2.fill", iconType: .sfSymbol)
                }
            case .playlist:
                Button {
                    isChangingGridMode = true
                } label: {
                    ModalTagView(name: "Playlist", icon: "Playlist", iconType: .asset)
                }
            case .bigCards:
                Button {
                    isChangingGridMode = true
                } label: {
                    ModalTagView(name: "Big Cards", icon: "BigCard", iconType: .asset)
                }
            case .masonry:
                Button {
                    isChangingGridMode = true
                } label: {
                    ModalTagView(name: "Masonry", icon: "Masonry", iconType: .asset)
                }
            }
        }
        .padding(.top, 24)
        .sheet(isPresented: $isChangingGridMode, content: {
            GridModeOptionsView()
                .presentationDetents([.fraction(0.4)])
        })
    }
}

struct ModalTagView: View {
    let name: String
    let icon: String
    let iconType: IconType
    
    var body: some View {
        HStack {
            Text(name)
                .bold()
                .font(.system(size: 18))
                .foregroundStyle(RizzColors.rizzWhite)
                .padding(.trailing, 16)
            
            switch iconType {
            case .sfSymbol:
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(RizzColors.rizzWhite)
                    .frame(width: 25, height: 25)
            case .asset:
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(RizzColors.rizzWhite)
                    .frame(width: 25, height: 25)
            }
        }
        .padding(.trailing, 10)
    }
}

struct ModelGridModeView: View {
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

#Preview {
    TopListView()
        .environmentObject(AppearenceViewModel.instance)
}
