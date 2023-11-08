//
//  NFTDetailView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct NFTDetailView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(Color(uiColor: UIImage(named: "BAYC1")!.averageColor!))
            
            ScrollView(showsIndicators: false) {
                VStack {
                    NFTDetailNavView()
                    
                    Image("BAYC1")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                        .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.width - 100)
                    
                    NFTDetailFeaturesView()
                    
                    ZStack {
                        NFTTopDetailView()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 12.0)
                            .padding(.horizontal, 8)
                            .frame(width: UIScreen.main.bounds.width)
                            .foregroundStyle(RizzColors.rizzGray)
                    }
                }
            }
        }
    }
}

struct NFTPropertyItemView: View {
    var body: some View {
        HStack {
            Text("Hat")
                .foregroundStyle(RizzColors.rizzWhite)
            
            Spacer()
            
            Text("Bayc Hat Black")
                .foregroundStyle(RizzColors.rizzWhite)
            
            Spacer()
            
            Text("1% have this trait")
                .font(.footnote)
                .foregroundStyle(RizzColors.rizzWhite)
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 6.0)
                .foregroundStyle(RizzColors.rizzGray)
        }
    }
}

struct NFTPropertiesView: View {
    var body: some View {
        VStack {
            HStack {
                Image("Properties")
                    .padding(.leading, 35)
                
                Text("Properties")
                    .bold()
                
                Spacer()
            }
            .padding(.top, 6)
            
            VStack {
                ForEach(0..<5, id:\.self) { _ in
                    NFTPropertyItemView()
                }
            }
            .padding(.horizontal, 30)
        }
        .background {
            RoundedRectangle(cornerRadius: 6.0)
                .frame(width: UIScreen.main.bounds.width - 50)
                .foregroundStyle(RizzColors.rizzLightGray)
                .overlay {
                    RoundedRectangle(cornerRadius: 12.0)
                        .stroke(RizzColors.rizzLightGray, lineWidth: 5.0)
                }
        }
    }
}

struct NFTDetailNavView: View {
    var body: some View {
        HStack {
            DetailButtonView(icon: "square.and.arrow.up")
            
            Spacer()
            
            DetailButtonView(icon: "ellipsis")
        }
        .padding(.horizontal)
    }
}

struct NFTDetailFeaturesView: View {
    var body: some View {
        HStack {
            DetailButtonView(icon: "arrow.up.left.and.arrow.down.right")
            
            Spacer()
            
            HStack {
                Capsule()
                    .foregroundStyle(RizzColors.rizzPink)
                    .frame(width: 110, height: 45)
                    .overlay {
                        HStack {
                            Image(systemName: "arkit")
                            
                            Text("AR it")
                                .bold()
                        }
                    }
                
                Capsule()
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(width: 110, height: 45)
                    .overlay {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                            
                            Text("Send")
                                .bold()
                        }
                    }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

struct DetailButtonView: View {
    let icon: String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color(uiColor: UIImage(named: "BAYC1")!.averageColorDarker!).opacity(0.5))
            
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color(uiColor: UIImage(named: "BAYC1")!.averageColorDarker!.contrastingColor).opacity(0.5))
        }
    }
}

#Preview {
    NFTDetailView()
}
