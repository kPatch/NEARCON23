import SwiftUI
import RealityKit
import ARKit

struct MainARView: View {
    @StateObject private var arViewModel: MainARViewModel = MainARViewModel()
    @StateObject private var multipeerSession: MultipeerSession = MultipeerSession()

    @State private var isPlacementEnabled = false
    @State private var errorMessage: String = ""
    @State private var isShowingPopup: Bool = false
    @State private var arViewContainer = ARViewContainer()

    var body: some View {
        ZStack {
            arViewContainer
                .environmentObject(self.arViewModel)
                .environmentObject(self.multipeerSession)
                .ignoresSafeArea()

            if self.arViewModel.isShowingAdder {
                VStack {
                    Spacer()

                    ConfirmPlacementView()
                        .environmentObject(self.arViewModel)
                        .padding(.bottom, 40)
                }
            } else {
                VStack {
                    ArtPiecePickerView()
                        .environmentObject(self.arViewModel)
                }
            }
        }
        .alert("\(self.errorMessage)", isPresented: $isShowingPopup) {
            Button("OK", role: .cancel) {
                self.arViewModel.isShowingUploadSnapshotOverlay = false
                self.isShowingPopup = false
                self.errorMessage = ""
            }
        }
    }
}

#Preview {
    MainARView()
}
