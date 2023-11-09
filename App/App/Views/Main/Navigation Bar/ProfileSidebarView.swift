//
//  ProfileSidebarView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct ProfileSidebarView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.owner ?? "Unknown")
                .bold()
                .foregroundStyle(.rizzWhite)
            
            Circle()
                .frame(width: 50, height: 50)
                .padding(.trailing)
        }
    }
}

#Preview {
    ProfileSidebarView()
}
