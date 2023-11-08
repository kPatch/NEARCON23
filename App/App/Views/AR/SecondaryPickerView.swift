import SwiftUI

struct SecondaryPickerView: View {
    @Environment(\.presentationMode) var mode
    
    let action: () -> Void
        
    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button { mode.wrappedValue.dismiss() } label: {
                      Image(systemName: "arrowshape.turn.up.backward.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                        .foregroundColor(RizzColors.rizzWhite)
                        .padding(.leading, 10)
                    }

                    Spacer()

                    Button { action() } label: {
                        Circle()
                            .frame(width: 65, height: 65)
                            .opacity(0.0)
                            .overlay {
                                Circle()
                                    .stroke(RizzColors.rizzWhite, lineWidth: 3.0)
                                    .frame(width: 65, height: 65)
                            }
                            .overlay {
                                Circle()
                                    .foregroundStyle(RizzColors.rizzRed)
                                    .frame(width: 50, height: 50)
                            }
                    }

                    Spacer()

                    Circle()
                        .frame(width: 65, height: 65)
                        .padding(.trailing, 10)
                        .opacity(0.0)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SecondaryPickerView() {
        print("Hello world")
    }
}
