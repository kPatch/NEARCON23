import RealityKit
import ARKit
import SwiftUI
import Combine
import simd

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
                self.placeModel(transform: nft.transform.matrix, uiView: uiView, model: nft.model)
            }

            DispatchQueue.main.async {
                self.multipeerSession.receivedData = nil
                self.multipeerSession.dataSenderPeerID = nil
            }
        }

        if let nft = arViewModel.nftConfirmedForPlacement {
            uiView.session.getCurrentWorldMap { worldMap, _ in
                guard let map = worldMap else { return }

                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true) else {
                    fatalError("can't encode anchor")
                }

                self.multipeerSession.sendToAllPeers(data)
            }
            
            let anchor = AnchorEntity(plane: .any)
            
            DispatchQueue.main.async {
                Task {
//                    let urlLink = "https://ipfs.io/ipfs/QmYW6WL7Pcq2jHVn8UNBAMk2CtFexb8mBaxqcmZsV3CBMZ"
                    guard let model = await self.downloadModel(model: nft.asset) else { return }
                    self.placeModel(anchorEntity: anchor, uiView: uiView, data: model) { matrix in
                        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: MultipeerNFT(transform: SIMD_float4x4_Wrapper(matrix: matrix), model: model), requiringSecureCoding: true) else {
                            fatalError("can't encode anchor")
                        }
                        self.multipeerSession.sendToAllPeers(data)
                    }
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

    func placeModel(anchorEntity: AnchorEntity, uiView: ARView, data: Data, closure: @escaping (simd_float4x4) -> Void) {
        DispatchQueue.main.async {
            Task {
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
                    
                    closure(anchorEntity.transformMatrix(relativeTo: modelEntity))
                } catch {
                    print(error)
                }
            }
        }
    }
}
