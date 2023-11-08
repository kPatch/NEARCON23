import SwiftUI

struct ConfirmPlacementView: View {
    @EnvironmentObject var arViewModel: MainARViewModel

    var body: some View {
        HStack {
            Button {
                self.arViewModel.isShowingAdder = false
                self.arViewModel.resetPlacementParameters()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .foregroundColor(Color.red)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }

            Button {
                self.arViewModel.isShowingAdder = false
                self.arViewModel.modelConfirmedForPlacement = self.arViewModel.selectedPiece
                self.arViewModel.resetPlacementParameters()
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .foregroundColor(Color.green)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
}
