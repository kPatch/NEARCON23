//
//  MultipeerNFT.swift
//  RizzApp
//
//  Created by Marcus Arnett on 11/9/23.
//

import Foundation

class MultipeerNFT: NSSecureCoding {
    let transform: SIMD_float4x4_Wrapper
    let model: Data

    static var supportsSecureCoding: Bool {
        return true
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.transform, forKey: "transform")
        coder.encode(self.model, forKey: "model")
    }

    required init?(coder: NSCoder) {
        if
            let transform: SIMD_float4x4_Wrapper = coder.decodeObject(forKey: "transform") as? SIMD_float4x4_Wrapper,
            let model: Data = coder.decodeObject(forKey: "model") as? Data
        {
            self.transform = transform
            self.model = model
        } else {
            return nil
        }
    }
}
