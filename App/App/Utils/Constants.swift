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
    NonFungibleTokens(name: "Rogue Fox #855", collectionName: "Rogues Genesis", description: "The Great Collapse. No fox knows the cause. From the ashes the fox arose, gathering in small groups, rebuilding by claw and by paw. Small settlements grew into towns and some even evolved into great skulks…But the Barren Lands are hard to traverse and keep these disparate settlements isolated. Only Rogues are cunning enough to roam between settlements, trading stories, goods and Lost Artifacts. ## Welcome to the Rogue Fox Guild, wanderer, and may luck be with you on the journey.", properties: [:], image: "https://paras-ipfs.paras.id/2bb216fe48095e8a40151fefd602691420dea30a", asset: "", tokenId: "", type: .regular, organization: nil),
    NonFungibleTokens(name: "Rogue Fox #763", collectionName: "Rogues Genesis", description: "The Great Collapse. No fox knows the cause. From the ashes the fox arose, gathering in small groups, rebuilding by claw and by paw. Small settlements grew into towns and some even evolved into great skulks…But the Barren Lands are hard to traverse and keep these disparate settlements isolated. Only Rogues are cunning enough to roam between settlements, trading stories, goods and Lost Artifacts. ## Welcome to the Rogue Fox Guild, wanderer, and may luck be with you on the journey.", properties: [:], image: "https://paras-ipfs.paras.id/214efa4a3bd9ef95e5990d112c2d88483c17bed1", asset: "", tokenId: "", type: .regular, organization: nil),
    NonFungibleTokens(name: "Welcome To NEARCON 2023", collectionName: "OpenDive", description: "NEARCON 2023 for the win!", properties: [:], image: "https://ipfs.io/ipfs/QmWBgjVcKnRKbxJVE4X5UESy6BNzp9uyKTGRB4vPkYRLgY", asset: "https://ipfs.io/ipfs/QmYW6WL7Pcq2jHVn8UNBAMk2CtFexb8mBaxqcmZsV3CBMZ", tokenId: "", type: .model, organization: nil)
]
