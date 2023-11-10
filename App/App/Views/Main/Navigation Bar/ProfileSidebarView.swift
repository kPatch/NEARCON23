//
//  ProfileSidebarView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct ProfileSidebarView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var isShowingProfile: Bool = false
    
    var body: some View {
        HStack {
            Button {
                self.isShowingProfile = true
            } label: {
                Text(viewModel.owner ?? "Unknown")
                    .bold()
                    .foregroundStyle(.rizzWhite)
                
                Circle()
                    .frame(width: 50, height: 50)
                    .padding(.trailing)
            }
        }.sheet(isPresented: $isShowingProfile) {
            ProfileView().environmentObject(viewModel)
        }
    }
}

#Preview {
    ProfileSidebarView()
}
