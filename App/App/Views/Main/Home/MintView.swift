//
//  MintView.swift
//  App
//
//  Created by Marcus Arnett on 11/9/23.
//

import SwiftUI

struct MintView: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var date = Date()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzMatteBlack)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                UploadAssetView()
                
                InputFieldView(text: $name, name: "Event Name")
                
                ExtendedFieldView(text: $description, name: "Event Description")
                
                DatePicker(
                    "Start Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .foregroundStyle(RizzColors.rizzWhite)
                .padding(.horizontal, 30)
                .padding(.top)
                
                ZStack {
                    VStack {
                        Spacer()
                        
                        Capsule()
                            .foregroundStyle(RizzColors.rizzMatteBlack)
                            .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                            .overlay {
                                Capsule()
                                    .stroke(RizzColors.rizzWhite, lineWidth: 5)
                            }
                    }
                    VStack {
                        Spacer()
                        
                        Text("Create Event")
                            .foregroundStyle(RizzColors.rizzWhite)
                            .font(.title)
                            .bold()
                            .padding(.bottom, 6)
                    }
                }
                .padding(.top)
                
                Text("Cancel")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 6)
            }
        }
    }
}

#Preview {
    MintView()
}
