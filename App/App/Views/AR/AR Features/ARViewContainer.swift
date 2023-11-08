import RealityKit
import ARKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var arViewModel: MainARViewModel

    static var arView: ARView?

    func makeUIView(context: Context) -> ARView {
        let arView = FocusARView(frame: .zero)
        arView.addCoaching()
        ARViewContainer.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        if let modelEntity = self.arViewModel.modelConfirmedForPlacement {
            let anchorEntity = AnchorEntity(plane: .any)
            let clonedEntity = modelEntity.clone(recursive: true)
            clonedEntity.generateCollisionShapes(recursive: true)
            uiView.installGestures([.all], for: clonedEntity)
            anchorEntity.addChild(clonedEntity)
            uiView.scene.addAnchor(anchorEntity)

            DispatchQueue.main.async {
                self.arViewModel.modelConfirmedForPlacement = nil
            }
        }
        #endif
    }
}
