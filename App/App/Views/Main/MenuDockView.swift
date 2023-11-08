//
//  FloatingActionButtonView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

enum IconType {
    case sfSymbol
    case asset
}

struct MenuDockView: View {
    @Binding var index: Int
    
    @State private var isShowingLabels: Bool = true
    @State private var isShowingActionMenu: Bool = false
    
    var body: some View {
        ZStack {
            if isShowingActionMenu {
                Rectangle()
                    .foregroundStyle(RizzColors.rizzMatteBlack.opacity(0.18))
                    .ignoresSafeArea()
            }
            
            VStack {
                HStack {
                    HStack {
                        Button {
                            index = 0
                        } label: {
                            VStack {
                                Image(systemName: "square.grid.3x3.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                                if isShowingLabels {
                                    Text("Collections")
                                }
                            }
                        }
                        .padding(.leading, 12)
                        .foregroundStyle(self.index == 0 ? RizzColors.rizzNeonBlue : RizzColors.rizzLightGray)
                        
                        Button {
                            index = 1
                        } label: {
                            VStack {
                                Image(systemName: "ticket.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                
                                if isShowingLabels {
                                    Text("Events")
                                }
                            }
                            .padding(.leading, 40)
                        }
                        .foregroundStyle(self.index == 1 ? RizzColors.rizzNeonBlue : RizzColors.rizzLightGray)
                    }
                    .padding(14)
                    .background {
                        Capsule()
                            .foregroundStyle(RizzColors.rizzGray)
                            .padding(.trailing, -10)
                    }
                    .padding(.leading, 28)
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    ActionButtonView(isShowingLabels: $isShowingLabels, isShowingButton: $isShowingActionMenu)
                }
                .padding(.top, 700)
            }
        }
    }
}

struct FloatingActionPreview: View {
    @State private var index: Int = 0
    
    var body: some View {
        MenuDockView(index: $index)
    }
}

struct ActionButtonView: View {
    @Binding var isShowingLabels: Bool
    @Binding var isShowingButton: Bool
    
    @State private var hasDisplayedARButton: Bool = false
    @State private var hasCreateEventButton: Bool = false
    @State private var hasMintNFTButton: Bool = false
    
    @State private var mintNFTPressed: Bool = false
    @State private var createEventPressed: Bool = false
    @State private var displayARPressed: Bool = false
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        ZStack {
            if hasMintNFTButton {
                Button {
                    mintNFTPressed.toggle()
                } label: {
                    SubActionButtonView(icon: "pickaxe", iconType: .asset)
                }
                    .offset(x: 0, y: -270)
                    .padding(.trailing)
                
                NavigationLink(
                    isActive: $mintNFTPressed,
                    destination: { HelloView() }, 
                    label: { }
                )
            }
            
            if hasCreateEventButton {
                Button {
                    createEventPressed.toggle()
                } label: {
                    SubActionButtonView(icon: "ticket.fill", iconType: .sfSymbol)
                }
                    .offset(x: 0, y: -185)
                    .padding(.trailing)
                
                NavigationLink(
                    isActive: $createEventPressed,
                    destination: { CreateEventView() },
                    label: { }
                )
            }
            
            if hasDisplayedARButton {
                Button {
                    displayARPressed.toggle()
                } label: {
                    SubActionButtonView(icon: "arkit", iconType: .sfSymbol)
                }
                    .offset(x: 0, y: -100)
                    .padding(.trailing)
                
                NavigationLink(
                    isActive: $displayARPressed,
                    destination: { MainARView().environmentObject(authVM) },
                    label: { }
                )
            }
            
            Button {
                withAnimation(.easeInOut) {
                    isShowingButton.toggle()
                }
                
                withAnimation(.easeInOut) {
                    isShowingLabels.toggle()
                }
                
                if !hasMintNFTButton {
                    withAnimation(.easeInOut) {
                        hasDisplayedARButton.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut) {
                            hasCreateEventButton.toggle()
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut) {
                            hasMintNFTButton.toggle()
                        }
                    }
                } else {
                    withAnimation(.easeInOut) {
                        hasMintNFTButton.toggle()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut) {
                            hasCreateEventButton.toggle()
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.easeInOut) {
                            hasDisplayedARButton.toggle()
                        }
                    }
                }
            } label: {
                Image("AddButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .padding(.trailing, 20)
            }
        }
    }
}

struct SubActionButtonView: View {
    let icon: String
    let iconType: IconType
    
    var body: some View {
        HStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [RizzColors.rizzPurple, RizzColors.rizzGreen]), startPoint: .leading, endPoint: .trailing)
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                
                switch iconType {
                case .sfSymbol:
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 19, height: 19)
                        .foregroundStyle(RizzColors.rizzWhite)
                case .asset:
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 19, height: 19)
                        .foregroundStyle(RizzColors.rizzWhite)
                }
            }
        }
    }
}

#Preview {
    FloatingActionPreview()
}

struct HelloView: View {
    var body: some View {
        Text("Hi")
    }
}
