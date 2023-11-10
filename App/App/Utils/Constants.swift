//
//  Constants.swift
//  RizApp
//
//  Created by Marcus Arnett on 9/22/23.
//

import Foundation
import SwiftUI

struct RizzColors {
    static let rizzPink = Color("RizzPink")
    static let rizzBlue = Color("RizzBlue")
    static let rizzBlack = Color("RizzBlack")
    static let rizzWhite = Color("RizzWhite")
    static let rizzGray = Color("RizzGray")
    static let rizzLightGray = Color("RizzLightGray")
    static let rizzMatteBlack = Color("RizzMatteBlack")
    static let rizzNeonBlue = Color("RizzNeonBlue")
    static let rizzRed = Color("RizzRed")
    static let rizzGreen = Color("RizzGreen")
    static let rizzPurple = Color("RizzPurple")
}

struct RizzOnboarding {
    static let features: [FeatureItem] = [
        FeatureItem(
            icon: "Wallet",
            title: "Lorum ipsum",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        ),
        FeatureItem(
            icon: "Tech",
            title: "Lorum ipsum",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        ),
        FeatureItem(
            icon: "Connected",
            title: "Lorum ipsum",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        ),
        FeatureItem(
            icon: "Logo",
            title: "See the Unseen – Where Your World Meets the Future",
            description: "Sign in below."
        )
    ]
}

struct Collection: Identifiable {
    let title: String
    let logo: String
    let NFTs: [String]
    let id = UUID().uuidString
}

struct FeatureItem: Hashable, Identifiable {
    let icon: String
    let title: String
    let description: String
    
    var id: String {
        return "\(self.icon)-\(self.title)-\(self.description)"
    }
}

let mockNFTs: [NonFungibleTokens] = [
    NonFungibleTokens(name: "Welcome To NEARCON 2023", collectionName: "OpenDive", description: "NEARCON 2023 for the win!", properties: [:], image: "https://ipfs.io/ipfs/QmWBgjVcKnRKbxJVE4X5UESy6BNzp9uyKTGRB4vPkYRLgY", asset: "https://ipfs.io/ipfs/QmYW6WL7Pcq2jHVn8UNBAMk2CtFexb8mBaxqcmZsV3CBMZ", tokenId: "", type: .model, organization: nil)
]
