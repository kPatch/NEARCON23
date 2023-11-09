//
//  MultipeerNFT.swift
//  RizzApp
//
//  Created by Marcus Arnett on 11/9/23.
//

import Foundation

@objc(MultipeerNFT)
class MultipeerNFT: NSObject, NSSecureCoding {
    let transform: SIMD_float4x4_Wrapper
    let model: Data

    init(transform: SIMD_float4x4_Wrapper, model: Data) {
        self.transform = transform
        self.model = model
    }

    static var supportsSecureCoding: Bool {
        return true
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.transform, forKey: "transform")
        coder.encode(self.model, forKey: "model")
    }

    required init?(coder: NSCoder) {
        if
            let transform: SIMD_float4x4_Wrapper = coder.decodeObject(of: SIMD_float4x4_Wrapper.self, forKey: "transform"),
            let model: Data = coder.decodeObject(of: NSData.self, forKey: "model") as? Data
        {
            self.transform = transform
            self.model = model
        } else {
            return nil
        }
    }
}
