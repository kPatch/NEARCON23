//
//  AppearenceViewModel.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import Foundation
import SwiftUI

class AppearenceViewModel: ObservableObject {
    static let instance = AppearenceViewModel()
    
    private init() {  }
    
    @Published var gridMode: HomeGridViewMode = .playlist
    @Published var isShowingActionMenu: Bool = false
}
