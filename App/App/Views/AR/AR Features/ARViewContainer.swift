import RealityKit
import ARKit
import SwiftUI
import Combine

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
        if let receivedData = multipeerSession.receivedData {
            if let worldMap = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: receivedData) {
                (uiView as! FocusARView).changeARView(worldMap: worldMap)
            }

            if let nft = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MultipeerNFT.self, from: receivedData) {
                print("RECEIVER: \(nft.model)")
                self.placeModel(transform: nft.transform.matrix, uiView: uiView, model: nft.model)
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
            
            DispatchQueue.main.async {
                Task {
                    let urlLink = "https://ipfs.io/ipfs/QmYW6WL7Pcq2jHVn8UNBAMk2CtFexb8mBaxqcmZsV3CBMZ"
                    guard let model = await self.downloadModel(model: urlLink) else { return }
                    self.placeModel(transform: hitTestResult.worldTransform, uiView: uiView, model: model)
                    print("SENDER: \(model)")

                    guard let data = try? NSKeyedArchiver.archivedData(withRootObject: MultipeerNFT(transform: SIMD_float4x4_Wrapper(matrix: hitTestResult.worldTransform), model: model), requiringSecureCoding: true) else {
                        fatalError("can't encode anchor")
                    }
                    self.multipeerSession.sendToAllPeers(data)
                }
                
                self.arViewModel.location = nil
            }
        }
        #endif
    }
    
    func downloadModel(model: String) async -> Data? {
        if let url = URL(string: model) {
            return await withCheckedContinuation { con in
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data else {
                        con.resume(returning: nil)
                        return
                    }
                    con.resume(returning: data)
                }.resume()
            }
        }
        
        return nil
    }
    
    func placeModel(transform: simd_float4x4, uiView: ARView, model: Data) {
        let anchorEntity = AnchorEntity(world: transform)
        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let usdzFileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("usdz")
        
        // Write the data to a temporary file
        do {
            try model.write(to: usdzFileURL)
            let modelEntity = try ModelEntity.loadModel(contentsOf: usdzFileURL)
            
            // Apply a scale transformation to make the logo 5 times smaller
            let scale: Float = 1.0 / 400.0 // Adjust this value as necessary
            modelEntity.scale = SIMD3<Float>(scale, scale, scale)

            // Add the AnchorEntity to the ARView's scene
            uiView.scene.addAnchor(anchorEntity)
            
            anchorEntity.addChild(modelEntity)
            uiView.scene.addAnchor(anchorEntity)
        } catch {
            print(error)
        }
    }

    func placeModel(transform: simd_float4x4, uiView: ARView, model: String) {
        let anchorEntity = AnchorEntity(world: transform)

        DispatchQueue.main.async {
            Task {
                guard let data: Data = await self.downloadModel(model: model)  else { return }
                
                let tempDirectoryURL = FileManager.default.temporaryDirectory
                let usdzFileURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("usdz")
                
                // Write the data to a temporary file
                do {
                    try data.write(to: usdzFileURL)
                    let modelEntity = try ModelEntity.loadModel(contentsOf: usdzFileURL)
                    
                    // Apply a scale transformation to make the logo 5 times smaller
                    let scale: Float = 1.0 / 400.0 // Adjust this value as necessary
                    modelEntity.scale = SIMD3<Float>(scale, scale, scale)

                    // Add the AnchorEntity to the ARView's scene
                    uiView.scene.addAnchor(anchorEntity)
                    
                    anchorEntity.addChild(modelEntity)
                    uiView.scene.addAnchor(anchorEntity)
                } catch {
                    print(error)
                }
            }
        }
    }
}
