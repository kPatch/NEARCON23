//
//  CreateEventView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct CreateEventView: View {
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
            }
        }
    }
}

#Preview {
    CreateEventView()
}

struct ExtendedFieldView: View {
    @Binding var text: String
    
    let name: String
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .foregroundStyle(RizzColors.rizzWhite)
                
                Spacer()
            }
            
            TextField(name, text: $text, axis: .vertical)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal, 30)
        .padding(.top)
    }
}

struct InputFieldView: View {
    @Binding var text: String
    
    let name: String
    
    var body: some View {
        VStack {
            HStack {
                Text(name)
                    .foregroundStyle(RizzColors.rizzWhite)
                
                Spacer()
            }
            
            TextField(name, text: $text)
                .textFieldStyle(.roundedBorder)
        }
        .padding(.horizontal, 30)
        .padding(.top)
    }
}

struct UploadAssetView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
                .foregroundStyle(RizzColors.rizzGray)
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 18.0)
                        .frame(width: 60, height: 60)
                        .foregroundStyle(RizzColors.rizzLightGray)
                    
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(RizzColors.rizzWhite)
                }
                
                Text("Upload Image, Video, Audio, or 3D Model")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .font(.system(size: 16))
                    .bold()
                
                Text("File types supported: JPG, PNG, GIF, SVG, MP4, WEBM, MP3, WAV, OGG, GLB, GLTF. Max size: 100 MB")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .font(.footnote)
                    .padding(.horizontal, 90)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 28)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 18.0)
                        .frame(width: 60, height: 60)
                        .foregroundStyle(RizzColors.rizzLightGray)
                    
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(RizzColors.rizzWhite)
                }
                
                Text("Use your camera")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .font(.system(size: 16))
                    .bold()
                
                Text("Use Kiyomi AR Features to create Outsanding content")
                    .foregroundStyle(RizzColors.rizzWhite)
                    .font(.footnote)
                    .padding(.horizontal, 90)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
