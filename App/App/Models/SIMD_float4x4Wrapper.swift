//
//  SIMD_float4x4Wrapper.swift
//  App
//
//  Created by Marcus Arnett on 11/9/23.
//

import Foundation
import simd

@objc(SIMD_float4x4_Wrapper) // This makes the class name visible to the Objective-C runtime
class SIMD_float4x4_Wrapper: NSObject, NSSecureCoding {
    
    var matrix: simd_float4x4

    init(matrix: simd_float4x4) {
        self.matrix = matrix
    }
    
    // Required for NSSecureCoding
    static var supportsSecureCoding: Bool {
        return true
    }
    
    // Used to encode the instance with an NSCoder
    func encode(with coder: NSCoder) {
        for i in 0..<4 {
            coder.encode(matrix[i].x, forKey: "matrix_\(i)_x")
            coder.encode(matrix[i].y, forKey: "matrix_\(i)_y")
            coder.encode(matrix[i].z, forKey: "matrix_\(i)_z")
            coder.encode(matrix[i].w, forKey: "matrix_\(i)_w")
        }
    }
    
    // Used to decode an instance from an NSCoder
    required init?(coder: NSCoder) {
        matrix = simd_float4x4()
        for i in 0..<4 {
            matrix[i].x = coder.decodeFloat(forKey: "matrix_\(i)_x")
            matrix[i].y = coder.decodeFloat(forKey: "matrix_\(i)_y")
            matrix[i].z = coder.decodeFloat(forKey: "matrix_\(i)_z")
            matrix[i].w = coder.decodeFloat(forKey: "matrix_\(i)_w")
        }
    }
}

extension Float {
    var degreesToRadians: Float {
        return self * .pi / 180
    }
}
