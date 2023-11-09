//
//  AuthViewModel.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI
import Combine
import SwiftyJSON
import AnyCodable

@MainActor
class AuthViewModel: ObservableObject {
    static let instance: AuthViewModel = AuthViewModel()

    @Published var nfts: [NonFungibleTokens] = []
    @Published var playlist: [String: [NonFungibleTokens]] = [:]
    @Published var owner: String?
    
    private var cancellables = Set<AnyCancellable>()

    private init() {
        // TODO: Fetch Username info
    }

    public func connectWallet() async throws {
        try await self.fetchNFTs()
    }

    private func fetchNFTs() async throws {
        self.owner = "irvin123.testnet"
        
        if let owner {
            let url = URL(string: "https://graph.mintbase.xyz/testnet")!
            let queryRequest = """
query MyQuery {  mb_views_nft_tokens(\n where: {owner: {_eq: \"\(owner)\"}}\n limit: 100\n order_by: {last_transfer_timestamp: desc}\n  ) {\n base_uri\n extra\n nft_contract_id\n nft_contract_name\n title\n description\n media\n last_transfer_receipt_id\n token_id\n }\n}\n
"""
            let body: [String: AnyCodable] = [
                "query": AnyCodable(queryRequest),
                "variables": AnyCodable(nil),
                "operationName": AnyCodable("MyQuery")
            ]

            let jsonData = try? JSONEncoder().encode(body)

            let data = try await RestHandler.asyncData(
                with: url,
                method: .post,
                headers: ["mb-api-key": "anon"],
                body: jsonData
            )
            
            print(JSON(data))

            for result in JSON(data)["data"]["mb_views_nft_tokens"].arrayValue {
                let name: String? = result["title"].string
                let collectionName: String? = result["nft_contract_name"].string
                let description: String? = result["description"].string
                let media: String? = result["media"].string
                let tokenId: String? = result["token_id"].string
                let assetUrl: String? = result["base_uri"].string
                let type: NFTType = NFTType(rawValue: result["extra"].string ?? "regular") ?? .regular

                self.nfts.append(
                    NonFungibleTokens(
                        name: name ?? "Untitiled NFT",
                        collectionName: collectionName ?? "Unknown",
                        description: description ?? "No description available.",
                        properties: [:],
                        image: media ?? "",
                        asset: assetUrl ?? "",
                        tokenId: tokenId ?? "",
                        type: type
                    )
                )
            }
            for nft in self.nfts {
                if
                    self.playlist[nft.collectionName]?.isEmpty != nil,
                    !self.playlist[nft.collectionName]!.isEmpty
                {
                    self.playlist[nft.collectionName]!.append(nft)
                    continue
                }
                self.playlist[nft.collectionName] = [nft]
            }
        }
    }
}
