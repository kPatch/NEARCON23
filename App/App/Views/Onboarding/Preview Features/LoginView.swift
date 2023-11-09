//
//  ConnectWalletFeatureView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showEmailLogin: Bool = false
    @State private var isShowingLoginButtons: Bool = false
    @State private var isShownLoginButtons: Bool = false
    
    let feature: FeatureItem
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                ZStack {
                    Image("LoginLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 120)
                        .offset(y: -40)
                    
                    Text("See the Unseen – Where Your World Meets the Future")
                        .foregroundStyle(.rizzWhite)
                        .font(.system(size: 24))
                        .bold()
                        .padding(.top, 190)
                    
                    Text("Sign in using one of the methods below")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.rizzWhite)
                        .font(.system(size: 16))
                        .padding(.top, 310)
                        .padding(.horizontal, 30)
                }
                .offset(y: isShowingLoginButtons ? -290 : -30)
                .animation(.easeInOut, value: isShowingLoginButtons)
                
                if isShownLoginButtons {
                    ZStack {
                        Button {
                            self.showEmailLogin = true
                        } label: {
                            Text("Login Using Email")
                                .foregroundStyle(RizzColors.rizzGreen)
                                .font(.title2)
                                .bold()
                                .background {
                                    Capsule()
                                        .foregroundStyle(RizzColors.rizzWhite)
                                        .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                                        .overlay {
                                            Capsule()
                                                .stroke(RizzColors.rizzGreen, lineWidth: 5)
                                        }
                                }
                        }
                        
                        Button {
                            self.authViewModel.signInWithGoogle()
                        } label: {
                            Text("Login Using Google")
                                .foregroundStyle(RizzColors.rizzGreen)
                                .font(.title2)
                                .bold()
                                .background {
                                    Capsule()
                                        .foregroundStyle(RizzColors.rizzWhite)
                                        .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                                        .overlay {
                                            Capsule()
                                                .stroke(RizzColors.rizzGreen, lineWidth: 5)
                                        }
                                }
                        }
                        .offset(y: -70)
                    }
                    .offset(y: -160)
                    .animation(.easeInOut, value: isShownLoginButtons)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    self.isShowingLoginButtons = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                withAnimation {
                    self.isShownLoginButtons = true
                }
            }
        }
        .onDisappear {
            withAnimation {
                self.isShownLoginButtons = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    self.isShowingLoginButtons = false
                }
            }
        }
        .sheet(isPresented: $showEmailLogin) {
            EmailLoginView()
        }
        .sheet(isPresented: $authViewModel.isSigningUp) {
            CreateNearIDView()
        }
    }
}

#Preview {
    LoginView(feature: RizzOnboarding.features[3])
}

struct CreateNearIDView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var hasSubmitted: Bool = false
    
    @State private var nearId: String = ""
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(RizzColors.rizzMatteBlack)
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome to !")
                    .bold()
                    .font(.title)
                    .foregroundStyle(.green)
                
                InputFieldView(text: $nearId, name: "Enter your new NEAR ID")
                    .padding(.bottom, 30)
                
                Button {
                    self.hasSubmitted = true
                    viewModel.createNearID(id: self.nearId)
                } label: {
                    Text("LFG")
                        .foregroundStyle(RizzColors.rizzBlue)
                        .font(.title2)
                        .bold()
                        .background {
                            Capsule()
                                .foregroundStyle(RizzColors.rizzWhite)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                                .overlay {
                                    Capsule()
                                        .stroke(RizzColors.rizzBlue, lineWidth: 5)
                                }
                        }
                }
            }
        }
    }
}

struct EmailLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var logMessage: String?

    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            RizzColors.rizzGray
                .ignoresSafeArea()

            VStack {
                Text("Welcome to Web3")
                    .font(.system(size: 24))
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 20)

                VStack(spacing: 20) {
                  // Email field
                  CustomField(text: $email, placeholder: Text("Email"), imageName: "envelope", isSecure: false)
                  
                  // Password field
                  CustomField(text: $password, placeholder: Text("Password"), imageName: nil, isSecure: true)
                }
                
                // Sign in
                Button {
                    viewModel.login(withEmail: email, password: password) { logResult in
                        self.logMessage = logResult
                    }
                } label: {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(.rizzMatteBlack)
                        .clipShape(Capsule())
                        .padding()
                }
                .offset(y: 50)

                Spacer()

                // Sign up button
                NavigationLink(destination: EmptyView()
                    .navigationBarBackButtonHidden(true)) {
                        HStack {
                            Text("Don't have an account?")
                                .font(.system(size: 16))
                                .foregroundStyle(.rizzWhite)
                            
                            Text("Sign Up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.rizzWhite)
                        }
                    }
                    .padding(.bottom, 16)
                    .background {
                        Capsule()
                            .foregroundStyle(.rizzGray)
                            .opacity(0.5)
                            .padding(-14)
                            .offset(y: -8)
                    }
            }
            .padding(.top, 48)
        }
    }
}

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            
        }
    }
}

struct CustomField: View {
    @Binding var text: String
    
    let placeholder: Text
    let imageName: String?
    let isSecure: Bool

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .padding(.leading, 30)
            }
            
            HStack {
                Image(systemName: imageName ?? "lock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
            }
        }
        .padding()
        .background(.rizzWhite.opacity(0.15))
        .cornerRadius(10)
        .foregroundColor(.rizzWhite.opacity(0.15))
        .padding(.horizontal, 32)
    }
}
