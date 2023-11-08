//
//  NonFungibleTokens.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/24/23.
//

import Foundation
import UIKit

struct NonFungibleTokens: Identifiable {
    let name: String
    let collectionName: String
    let description: String
    let properties: [String: String]
    let image: String
    let asset: Data?
    let tokenId: Int
    let id = UUID().uuidString
    
    var imageURL: String {
        var inputURL = self.image
        if inputURL.contains("ipfs://") {
            let urlGuard = URL(string: inputURL)!
            inputURL = urlGuard.host() != nil ? "http://ipfs.io/ipfs/\(urlGuard.host()!)" : inputURL
        }
        return inputURL
    }
}
