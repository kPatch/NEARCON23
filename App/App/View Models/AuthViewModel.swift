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
import Firebase
import FirebaseAuth
import GoogleSignIn

class AuthViewModel: ObservableObject {
    static let instance: AuthViewModel = AuthViewModel()

    @Published var nfts: [NonFungibleTokens] = []
    @Published var playlist: [String: [NonFungibleTokens]] = [:]

    @Published var userSession: FirebaseAuth.User?
    @Published var owner: String?
    
    private var cancellables = Set<AnyCancellable>()

    private init() {
//        userSession = Auth.auth().currentUser
    }

    public func connectWallet() async throws {
        self.fetchNFTs()
    }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Configure Google Sign In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { user, error in
            guard let user, let idToken = user.user.idToken else {
                if let error = error {
                    // Handle error
                    print(error.localizedDescription)
                    return
                }
                print("Unknown error")
                return
            }

            let accessToken = user.user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                guard let user = result?.user else { return }

                self.userSession = user
            }
        }
    }
    
    func login(withEmail email: String, password: String, completion: @escaping(String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let logResult = "\(error.localizedDescription)"
                if logResult == "There is no user record corresponding to this identifier. The user may have been deleted." {
                    completion("Incorrect email or password.")
                } else {
                    completion(logResult)
                }
            }
            
            guard let user = result?.user else { return }
            
            self.userSession = user
        }
    }
    
    func getRootViewController() -> UIViewController {
        // Get the scene with a connected window
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            fatalError("No root view controller set!")
        }
        return rootViewController
    }

    func signout() {
        self.userSession = nil
        try? Auth.auth().signOut()
    }

    private func fetchNFTs() {
        if let user = self.owner {
            let url = URL(string: "https://graph.mintbase.xyz/testnet")!
            let queryRequest = """
query MyQuery {  mb_views_nft_tokens(\n where: {owner: {_eq: \"\(user)\"}}\n limit: 100\n order_by: {last_transfer_timestamp: desc}\n  ) {\n base_uri\n extra\n nft_contract_id\n nft_contract_name\n title\n description\n media\n last_transfer_receipt_id\n token_id\n nft_contract_icon\n }\n}\n
"""
            let body: [String: AnyCodable] = [
                "query": AnyCodable(queryRequest),
                "variables": AnyCodable(nil),
                "operationName": AnyCodable("MyQuery")
            ]

            let jsonData = try? JSONEncoder().encode(body)

            DispatchQueue.main.async {
                Task {
                    let data = try await RestHandler.asyncData(
                        with: url,
                        method: .post,
                        headers: ["mb-api-key": "anon"],
                        body: jsonData
                    )

                    for result in JSON(data)["data"]["mb_views_nft_tokens"].arrayValue {
                        let name: String? = result["title"].string
                        let collectionName: String? = result["nft_contract_name"].string
                        let description: String? = result["description"].string
                        let media: String? = result["media"].string
                        let tokenId: String? = result["token_id"].string
                        let assetUrl: String? = result["base_uri"].string
                        let organizationIcon: String? = result["nft_contract_icon"].string
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
                                type: type,
                                organization: organizationIcon
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
    }
}
