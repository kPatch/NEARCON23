//
//  CreateEventView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI
import Camera_SwiftUI
import Combine
import AVFoundation
import OpenAIKit

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

class UploadAssetViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var selectedAIImage: Image? = nil
}

struct UploadAssetView: View {
    @State private var isPresentingImagePicker: Bool = false
    @State private var isPresentingCameraView: Bool = false
    @State private var isPresentingAIGenerator: Bool = false
    
    @StateObject private var viewModel: UploadAssetViewModel = UploadAssetViewModel()
    
    var body: some View {
        ZStack {
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
            } else if let selectedImage = viewModel.selectedAIImage {
                selectedImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
            } else {
                RoundedRectangle(cornerRadius: 12.0)
                    .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
                    .foregroundStyle(RizzColors.rizzGray)
            }

            VStack(spacing: 10) {
                HStack {
                    Button {
                        isPresentingImagePicker.toggle()
                    } label: {
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
                    }
                    
                    Button {
                        isPresentingCameraView.toggle()
                    } label: {
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
                    }
                    
                    Button {
                        self.isPresentingAIGenerator = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18.0)
                                .frame(width: 60, height: 60)
                                .foregroundStyle(RizzColors.rizzLightGray)
                            
                            Image(systemName: "cpu")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(RizzColors.rizzWhite)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.leading, 100)
            .sheet(isPresented: $isPresentingImagePicker) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage)
            }
            .sheet(isPresented: $isPresentingCameraView) {
                ImagePicker(sourceType: .camera, selectedImage: $viewModel.selectedImage)
            }
            .sheet(isPresented: $isPresentingAIGenerator) {
                AIGeneratorView(returnedImage: $viewModel.selectedAIImage)
            }
        }
    }
}

struct AIGeneratorView: View {
    @State private var idea: String = ""
    @State private var image: Image? = nil
    
    @Binding var returnedImage: Image?
    
    @Environment(\.presentationMode) var mode
    
    func generateImage() async throws {
        let openAI = OpenAI(Configuration(organizationId: "MarcoDotIO", apiKey: openAIKey))
        let imageParameters = ImageParameters(prompt: self.idea, numberofImages: 1, resolution: .large, responseFormat: .base64Json)
        let imageResponse = try await openAI.createImage(parameters: imageParameters)
        self.image = Image(uiImage: try openAI.decodeBase64Image(imageResponse.data[0].image))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzMatteBlack)
                .ignoresSafeArea()
            
            VStack {
                ExtendedFieldView(text: $idea, name: "Image Idea")
                
                Button {
                    Task {
                        do {
                            try await self.generateImage()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
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
                            
                            Text("Generate Image")
                                .foregroundStyle(RizzColors.rizzWhite)
                                .font(.title)
                                .bold()
                                .padding(.bottom, 6)
                        }
                    }
                    .padding(.top)
                }
                
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                    
                    Button {
                        self.returnedImage = self.image
                        mode.wrappedValue.dismiss()
                    } label: {
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
                                
                                Text("Submit Image")
                                    .foregroundStyle(RizzColors.rizzWhite)
                                    .font(.title)
                                    .bold()
                                    .padding(.bottom, 6)
                            }
                        }
                        .padding(.top)
                    }
                    
                    Button {
                        Task {
                            do {
                                try await self.generateImage()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Regenerate")
                            .foregroundStyle(RizzColors.rizzWhite)
                            .font(.title3)
                            .bold()
                            .padding(.bottom, 6)
                    }
                }
            }
        }
    }
}

final class CameraModel: ObservableObject {
    let service = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        service.capturePhoto()
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var model = CameraModel()
    
    @State var currentZoomFactor: CGFloat = 1.0
    
    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
            dismiss()
        }, label: {
            Circle()
                .foregroundColor(.white)
                .frame(width: 80, height: 80, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
                        .frame(width: 65, height: 65, alignment: .center)
                )
        })
    }
    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Circle()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(
                    Image(systemName: "camera.rotate.fill")
                        .foregroundColor(.white))
        })
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { reader in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        CameraPreview(session: model.session)
                            .gesture(
                                DragGesture().onChanged({ (val) in
                                    //  Only accept vertical drag
                                    if abs(val.translation.height) > abs(val.translation.width) {
                                        //  Get the percentage of vertical screen space covered by drag
                                        let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                        //  Calculate new zoom factor
                                        let calc = currentZoomFactor + percentage
                                        //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                        let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                        //  Store the newly calculated zoom factor
                                        currentZoomFactor = zoomFactor
                                        //  Sets the zoom factor to the capture device session
                                        model.zoom(with: zoomFactor)
                                    }
                                })
                            )
                            .onAppear {
                                model.configure()
                            }
                            .alert(isPresented: $model.showAlertError, content: {
                                Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                    model.alertError.primaryAction?()
                                }))
                            })
                            .overlay(
                                Group {
                                    if model.willCapturePhoto {
                                        Color.black
                                    }
                                }
                            )
                            .animation(.easeInOut)
                        
                        
                        HStack {
                            Button(action: {
                                model.switchFlash()
                            }, label: {
                                Image(systemName: model.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
                                    .font(.system(size: 20, weight: .medium, design: .default))
                            })
                            .accentColor(model.isFlashOn ? .yellow : .white)
                            
                            Spacer()
                            
                            captureButton
                            
                            Spacer()
                            
                            flipCameraButton
                            
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
}
