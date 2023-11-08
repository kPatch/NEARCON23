//
//  EventDetailView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct EventDetailView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzGray)
                .ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                
                Spacer()
            }

            ScrollView {
                VStack {
                    HStack {
                        Text("Lorum Ipsum")
                            .foregroundStyle(RizzColors.rizzWhite)
                            .font(.title)
                            .bold()
                            .padding([.top, .leading])
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                    
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Pharetra et ultrices neque ornare aenean. Tortor pretium viverra suspendisse potenti nullam ac. Commodo quis imperdiet massa tincidunt nunc pulvinar sapien et ligula. Pellentesque eu tincidunt tortor aliquam nulla facilisi cras fermentum. Tincidunt tortor aliquam nulla facilisi cras fermentum odio. Vestibulum sed arcu non odio. Eget nulla facilisi etiam dignissim diam quis enim lobortis. Porttitor leo a diam sollicitudin tempor id eu. Dui vivamus arcu felis bibendum ut. Nisl nunc mi ipsum faucibus. Viverra maecenas accumsan lacus vel facilisis volutpat. Tellus cras adipiscing enim eu turpis egestas pretium. Tortor pretium viverra suspendisse potenti nullam ac.")
                        .foregroundStyle(RizzColors.rizzWhite)
                        .padding(.horizontal, 30)
                        .padding(.top, 1)
                        .padding(.bottom, 40)
                }
                .background {
                    RoundedRectangle(cornerRadius: 12.0)
                        .frame(width: UIScreen.main.bounds.width)
                        .foregroundStyle(RizzColors.rizzGray)
                }
                .padding(.top, 320)
            }
        }
    }
}

#Preview {
    EventDetailView()
}
