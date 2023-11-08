//
//  ArtPiece.swift
//  SuiKit
//
//  Copyright (c) 2023 OpenDive
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RealityKit
import SceneKit
import Kingfisher

struct ModelHelper {
    static func modelEntity(imageUrl: String, completionHandler: @escaping (_ entity: ModelEntity?) -> Void) {
        let dimensions: SIMD3<Float> = [0.3075, 0.046, 0.3075]

        // Create Frame Housing
        let housingMesh = MeshResource.generateBox(size: dimensions)
        let housingMat = SimpleMaterial(color: .black, roughness: 0.4, isMetallic: false)
        let housingEntity = ModelEntity(mesh: housingMesh, materials: [housingMat])

        // Create Contents of Frame
        let screenMesh = MeshResource.generatePlane(width: dimensions.x, depth: dimensions.z)
        let screenMaterial = SimpleMaterial(color: .white, roughness: 0.2, isMetallic: false)
        let screenEntity = ModelEntity(mesh: screenMesh, materials: [screenMaterial])
        screenEntity.name = UUID().uuidString

        // Add Contents of Frame to Frame Housing
        housingEntity.addChild(screenEntity)
        screenEntity.setPosition([0, dimensions.y / 2 + 0.001, 0], relativeTo: housingEntity)
        
        // Implement Texture Material onto Contents
        Self.fetchImageWithEscaping(imageURL: imageUrl) { url in
            do {
                guard let url = url else { throw NSError(domain: "Unable to unwrap URL", code: -1) }
                let texture = try TextureResource.load(contentsOf: url)
                
                var material = SimpleMaterial()
                material.color.texture = SimpleMaterial.Texture(texture)
                screenEntity.model?.materials = [material]
                
                completionHandler(housingEntity)
            } catch {
                print(error)
                completionHandler(nil)
            }
        }
    }
    
    private static func fetchImageWithEscaping(imageURL: String, completionHandler: @escaping (_ url: URL?) -> Void) {
        var inputURL = imageURL
        if inputURL.contains("ipfs://") {
            let urlGuard = URL(string: inputURL)!
            inputURL = urlGuard.host() != nil ? "http://ipfs.io/ipfs/\(urlGuard.host()!)" : inputURL
        }
        
        URLSession.shared.dataTask(with: URL(string: imageURL)!) { data, response, error in
            guard let data else {
                completionHandler(nil)
                return
            }

            do {
                let id = UUID().uuidString
                try KingfisherManager.shared.cache.diskStorage.store(value: data, forKey: id)
                let kfData = KingfisherManager.shared.cache.diskStorage.cacheFileURL(forKey: id)
                completionHandler(kfData)
            } catch {
                completionHandler(nil)
            }
        }.resume()
    }
}
