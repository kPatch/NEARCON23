import SwiftUI

struct ArtPiecePickerView: View {
    @EnvironmentObject var arViewModel: MainARViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                Capsule()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 100)
                    .opacity(0.5)
            }

            VStack {
                Spacer()

                HStack {
                    Button {
                        self.arViewModel.isCollaborationEnabled.toggle()
                    } label: {
                        Image(self.arViewModel.isCollaborationEnabled ? "OnCollab" : "OffCollab")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }

                    Spacer()
                }
                .padding(.leading, 30)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(authViewModel.nfts) { nft in
                            Button {
                                if nft.asset != "" {
                                    self.arViewModel.nftConfirmedForPlacement = nft
                                    self.arViewModel.isShowingAdder = true
                                } else {
                                    ModelHelper.modelEntity(imageUrl: nft.imageURL) { entity in
                                        self.arViewModel.selectedPiece = entity
                                    }
                                    self.arViewModel.imageForNFTPlacement = nft.imageURL
                                    self.arViewModel.isShowingAdder = true
                                }
                            } label: {
                                ArtPiecePickerItemView(nft: nft.imageURL)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 100)
                .clipShape(Capsule())
            }
        }
    }
}

#Preview {
    ArtPiecePickerView()
}

struct ArtPiecePickerItemView: View {
    let nft: String
    
    var body: some View {
        if nft.contains("<svg") {
            SVGWebView(svgString: nft)
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .frame(width: 60, height: 60)
                .padding(.horizontal, 10)
        } else if let url = URL(string: nft) {
            AsyncImage(url: url) { image in
                image.image?.resizable().scaledToFit()
            }
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .frame(width: 60, height: 60)
                .padding(.horizontal, 10)
        } else {
            RoundedRectangle(cornerRadius: 12.0)
                .foregroundStyle(RizzColors.rizzGray)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12.0))
                .frame(width: 60, height: 60)
                .padding(.horizontal, 10)
        }
    }
}
