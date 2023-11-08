//
//  EventsView.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI

struct EventsView: View {
    var body: some View {
        ZStack {
            VStack {
                MainNavBarView()
                
                EventsScrollView()
                
                Spacer()
            }
        }
    }
}

struct EventsScrollView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(0..<10, id:\.self) { _ in
                EventItemView()
            }
        }
    }
}

struct EventItemView: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: 80, height: 80)
                .foregroundStyle(.white)
                .padding(.leading, 24)
                .padding(.vertical)
            
            Spacer()
            
            Text("Lorum Ipsum")
                .font(.system(size: 24))
                .foregroundStyle(RizzColors.rizzWhite)
                .bold()
            
            Spacer()
            
            Text("Sep. 24")
                .foregroundStyle(RizzColors.rizzWhite)
                .padding(.trailing, 30)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background {
            RoundedRectangle(cornerRadius: 12.0)
                .frame(width: UIScreen.main.bounds.width - 40)
                .foregroundStyle(RizzColors.rizzMatteBlack)
        }
    }
}

#Preview {
    EventsView()
}
