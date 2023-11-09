import RealityKit
import ARKit
import SwiftUI

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var arViewModel: MainARViewModel
    @EnvironmentObject var multipeerSession: MultipeerSession
    
    let modelName = "NEARCONLogo"

    func makeUIView(context: Context) -> ARView {
        let arView = FocusARView(frame: .zero)
        arView.addCoaching()
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        if arViewModel.isCollaborationEnabled != arViewModel.currentCollabSetting {
            (uiView as! FocusARView).setupARView()
            arViewModel.currentCollabSetting = arViewModel.isCollaborationEnabled
        }
        
        if let receivedData = multipeerSession.receivedData {
            if let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: receivedData) {
                (uiView as! FocusARView).changeARView(worldMap: worldMap)
            }

            if let matrix = try? NSKeyedUnarchiver.unarchivedObject(ofClass: SIMD_float4x4_Wrapper.self, from: receivedData) {
                self.placeModel(transform: matrix.matrix, uiView: uiView)
            }

            DispatchQueue.main.async {
                self.multipeerSession.receivedData = nil
                self.multipeerSession.dataSenderPeerID = nil
            }
        }
        
        if let location = self.arViewModel.location {
            guard let hitTestResult = uiView.hitTest(location, types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane, .estimatedVerticalPlane]).first else {
                return
            }

            uiView.session.getCurrentWorldMap { worldMap, _ in
                guard let map = worldMap else { return }

                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true) else {
                    fatalError("can't encode anchor")
                }

                self.multipeerSession.sendToAllPeers(data)
            }

            self.placeModel(transform: hitTestResult.worldTransform, uiView: uiView)

            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: SIMD_float4x4_Wrapper(matrix: hitTestResult.worldTransform), requiringSecureCoding: true) else {
                fatalError("can't encode anchor")
            }
            self.multipeerSession.sendToAllPeers(data)
            
            DispatchQueue.main.async {
                self.arViewModel.location = nil
            }
        }

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
    
    func placeModel(transform: simd_float4x4, uiView: ARView) {
        let anchorEntity = AnchorEntity(world: transform)

        // Check if the file exists in the main bundle
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "usdz") else {
            fatalError("Failed to find tv_retro.usdz in app bundle.")
        }

        // Load the model entity
        guard let modelEntity = try? ModelEntity.loadModel(contentsOf: modelURL) else {
            fatalError("Failed to load tv_retro.usdz in app bundle.")
        }
        
        // Apply a scale transformation to make the logo 5 times smaller
        let scale: Float = 1.0 / 400.0 // Adjust this value as necessary
        modelEntity.scale = SIMD3<Float>(scale, scale, scale)

        // Add the AnchorEntity to the ARView's scene
        uiView.scene.addAnchor(anchorEntity)
        
        anchorEntity.addChild(modelEntity)
        uiView.scene.addAnchor(anchorEntity)
    }
}
