//
//  NonFungibleTokens.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/24/23.
//

import Foundation
import UIKit
import SwiftUI
import Kingfisher

struct NonFungibleTokens: Identifiable {
    let name: String
    let collectionName: String
    let description: String
    let properties: [String: String]
    let image: String
    let asset: String
    let tokenId: String
    let type: NFTType
    let organization: String?
    let id = UUID().uuidString

    var imageURL: String {
        var inputURL = self.image
        if inputURL.contains("ipfs://") {
            let urlGuard = URL(string: inputURL)!
            inputURL = urlGuard.host() != nil ? "http://ipfs.io/ipfs/\(urlGuard.host()!)" : inputURL
        }
        return inputURL
    }
    
//    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
//        print("image doesn't exist")
//        return nil
//    }
//    
//    return UIImage.animatedImageWithSource(source)
    
    func getAsset() async throws -> Data? {
        guard let url = URL(string: self.asset) else { return nil }
        return try await RestHandler.asyncData(
            with: url,
            method: .get
        )
    }
    
    func getImage() async -> Image? {
        return await withCheckedContinuation { con in
            Self.fetchImageWithEscaping(imageURL: self.imageURL) { url in
                guard let url = url else {
                    con.resume(returning: nil)
                    return
                }
                guard let uiImage = UIImage(data: url.dataRepresentation) else {
                    con.resume(returning: nil)
                    return
                }

                if 
                    let source = CGImageSourceCreateWithData(url.dataRepresentation as CFData, nil),
                    let uiImageGif = UIImage.animatedImageWithSource(source) 
                {
                    con.resume(returning: Image(uiImage: uiImageGif))
                }

                con.resume(returning: Image(uiImage: uiImage))
            }
        }
    }

    static func fetchImageWithEscaping(imageURL: String, completionHandler: @escaping (_ url: URL?) -> Void) {
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
