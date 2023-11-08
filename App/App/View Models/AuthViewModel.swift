//
//  AuthViewModel.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import WalletConnectSign
import WalletConnectModal
import WalletConnectNotify
import WalletConnectUtils
import Web3Core
import web3swift
import SwiftUI
import Combine
import Starscream
import SwiftyJSON

@MainActor
class AuthViewModel: ObservableObject {
    static let instance: AuthViewModel = AuthViewModel()
    
    @Published var session: Session? = nil
    @Published var nfts: [NonFungibleTokens] = []
    @Published var playlist: [String: [NonFungibleTokens]] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    let infuraKey = "f7c4f86c263940ce96b77757f9266602"
    let walletConnectProjectId = "2467db657131d94236a5104f687862ca"
    let moralisKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6IjRjYjNhM2EwLTk5MGEtNGE1Mi1iZjRjLWNkODE0NGJkZjBiMCIsIm9yZ0lkIjoiMjA2NTM2IiwidXNlcklkIjoiMjA2MjA4IiwidHlwZUlkIjoiNzEyM2RlYTYtZjFjYy00MzE3LTg3NzQtOWEyNWEyY2Q5NGE2IiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE2OTU1NDc3NDMsImV4cCI6NDg1MTMwNzc0M30.QonO8xlpavA7KmCBGFFuVuotjMr4ZrjsYgceByrpfyA"
    
    private init() {
        let metadata = AppMetadata(
            name: "RizzProtocol",
            description: "RIZZ Protocol Wallet",
            url: "opendive.io",
            icons: ["https://pbs.twimg.com/profile_images/1559578802644303872/Tsa6LT-I_400x400.jpg"]
        )
        
        Networking.configure(projectId: walletConnectProjectId, socketFactory: DefaultSocketFactory())
        
        WalletConnectModal.configure(projectId: walletConnectProjectId, metadata: metadata)
        
        self.addSubscribers()
        
        if let session = Sign.instance.getSessions().first {
            self.session = session
            
            Task {
                do {
                    try await self.fetchNFTs()
                } catch { }
            }
        }
    }
    
    func connectWallet() async {
        let methods: Set<String> = ["eth_requestAccounts", "eth_sendTransaction", "personal_sign", "eth_signTypedData", "eth_signTransaction", "eth_sign"]
        let blockchains: Set<Blockchain> = [Blockchain("eip155:1")!, Blockchain("eip155:137")!]
        let namespaces: [String: ProposalNamespace] = [
            "eip155": ProposalNamespace(
                chains: blockchains,
                methods: methods,
                events: []
            )
        ]
        
        WalletConnectModal.set(sessionParams: .init(
            requiredNamespaces: namespaces,
            optionalNamespaces: nil,
            sessionProperties: nil
        ))
        
        WalletConnectModal.present()
    }
    
    private func fetchNFTs() async throws {
        if let session {
            let url = URL(string: "https://deep-index.moralis.io/api/v2.2/\(session.accounts[0].address)/nft?chain=eth&format=decimal&media_items=false")!
            
            let data = try await RestHandler.asyncData(
                with: url,
                method: .get,
                headers: ["X-API-Key": self.moralisKey]
            )
            print("RESULT COUNT - \(JSON(data)["result"].arrayValue.count)")
            for result in JSON(data)["result"].arrayValue {
                let name: String? = result["name"].string
                let metadata: String? = result["metadata"].string
                
                if let name, let metadata, let mdData = metadata.data(using: .utf8) {
                    let mdJson = JSON(mdData)
                    
                    self.nfts.append(
                        NonFungibleTokens(
                            name: mdJson["name"].string ?? "Untitiled NFT",
                            collectionName: name,
                            description: mdJson["description"].string ?? "No description available.",
                            properties: [:],
                            image: mdJson["image"].string ?? "",
                            asset: nil,
                            tokenId: result["token_id"].intValue
                        )
                    )
                }
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
    
    private func addSubscribers() {
        Sign.instance.sessionSettlePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (returnedSession) in
                guard let self = self else { return }
                self.session = returnedSession
                Task {
                    do {
                        try await self.fetchNFTs()
                    } catch { }
                }
            }
            .store(in: &cancellables)
    }
}

extension WebSocket: WebSocketConnecting { }

struct DefaultSocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        return WebSocket(url: url)
    }
}
