//
//  AuthViewModel.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import SwiftUI
import SwiftyJSON
import AnyCodable
import Firebase
import FirebaseAuth
import GoogleSignIn
import OpenAIKit
import LocalAuthentication

class AuthViewModel: ObservableObject {
    static let instance: AuthViewModel = AuthViewModel()

    @Published var nfts: [NonFungibleTokens] = []
    @Published var playlist: [String: [NonFungibleTokens]] = [:]

    @Published var privateKey: String?
    @Published var owner: String?
    @Published var uid: String?

    @Published var isSigningUp: Bool = false
    @Published var selectedImage: UIImage? = nil

    let hostId: String = "https://nearcon-23.vercel.app"

    private init() { 
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            if let data = KeychainHelper.loadBioProtected(key: uuid, prompt: "Access logged in NEAR Session") {
                if let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data) {
                    self.privateKey = userInfo.privateKey
                    self.owner = userInfo.owner
                }
            }
        }
    }

    func mintNFT(name: String, description: String) {
        guard let selectedImage = selectedImage else { print("NO PICS"); return }
        guard let id = self.owner, let privateKey = self.privateKey else { return }
        guard let url = URL(string: "\(hostId)/api/accountCreate") else { print("NO URL"); return }  // TODO: Implement actual function
        
        DispatchQueue.main.async {
            Task {
                guard let image = try await self.uploadScreenshot(image: selectedImage) else { print("NO UPLOAD"); return }

                let body: [String: AnyCodable] = [
                    "accountId" : AnyCodable(id),
                    "title" : AnyCodable(name),
                    "description": AnyCodable(description),
                    "image_uri": AnyCodable(image),
                    "privateKey": AnyCodable(privateKey),
                    "receiverNFT": AnyCodable("INSERT CONTRACT HERE") // TODO: Put the contract ID here
                ]
                let jsonData = try? JSONEncoder().encode(body)

                let _ = try await RestHandler.asyncData(with: url, method: .post, body: jsonData)  // TODO: Figure out how to handle return values
            }
        }
    }
    
    @MainActor
    public func uploadScreenshot(image: UIImage) async throws -> String? {
        if let dataImage = image.jpegData(compressionQuality: 0.65) {
            let base64Image = dataImage.base64EncodedString()
            return try await self.uploadURL(base64: base64Image)
        }
        return nil
    }
    
    private func uploadURL(base64: String) async throws -> String {
        let formRequest = PiantaFormData(formUrl: URL(string: "https://api.pinata.cloud/pinning/pinFileToIPFS")!)
        let imageName = "\(self.owner!)_\(UUID().uuidString)"

        guard let image = try OpenAI(Configuration(organizationId: "", apiKey: "")).decodeBase64Image(base64).jpegData(compressionQuality: 1.0) else {
            throw NSError(domain: "Unable to convert image to data", code: -1)
        }

        formRequest.addDataField(
            named: "file",
            formData: PiantaFormDataValue(
                data: image,
                mimeType: "image/png",
                fileName: "\(imageName).jpg"
            )
        )

        formRequest.addTextField(named: "pinataMetadata", value: "{\"name\": \"\(imageName)\"}")

        let request = formRequest.asURLRequest(apiKey: pinataJWT)
        let encodedData = try await RestHandler.asyncData(with: request)
        let decodedResult: PinataIPFSResponse = try await RestHandler.decodeData(with: encodedData)

        return "https://ipfs.io/ipfs/\(decodedResult.ipfsHash)"
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
                self.lookupNearID(uid: user.uid)
            }
        }
    }
    
    func createNearID(id bareId: String) {
        let id = bareId.contains(".near") ? bareId : "\(bareId).near"
        guard let uid = self.uid else { print("NO UID"); return }
        guard let url = URL(string: "\(hostId)/api/accountCreate") else { print("NO URL"); return }
        
        let body: [String: AnyCodable] = [
            "accountId" : AnyCodable(id),
            "userID" : AnyCodable(uid)
        ]
        let jsonData = try? JSONEncoder().encode(body)
        
        DispatchQueue.main.async {
            Task {
                do {
                    let result = try await RestHandler.asyncData(with: url, method: .post, body: jsonData)
                    self.privateKey = JSON(result)["privateKey"].stringValue
                    self.owner = id
                    // KeychainHelper.createBioProtectedEntry(key: entryName, data: Data(entryContents.utf8))
                    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                        if let jsonData = try? JSONEncoder().encode(UserInfo(privateKey: JSON(result)["privateKey"].stringValue, owner: id)) {
                            let _ = KeychainHelper.createBioProtectedEntry(key: uuid, data: jsonData)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
    
    // TODO: Implement Account Lookup once endpoint is deployed
    func lookupNearID(uid: String) {
        if true {  // TODO: Implement condition to either sign up or get the account
            self.uid = uid
            self.isSigningUp = true
        } else {
            
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
            self.lookupNearID(uid: user.uid)
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
        try? Auth.auth().signOut()
        self.nfts = []
        self.owner = nil
        self.privateKey = nil
    }

    func fetchNFTs() {
        self.nfts = []
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
                    self.nfts.append(contentsOf: mockNFTs)
                }
            }
        }
    }
}

class UserInfo: Codable {
    init(privateKey: String, owner: String) {
        self.privateKey = privateKey
        self.owner = owner
    }
    
    let privateKey: String
    let owner: String
}
