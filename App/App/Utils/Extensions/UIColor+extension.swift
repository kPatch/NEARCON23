//
//  UIColor+extension.swift
//  RizzApp
//
//  Created by Marcus Arnett on 9/23/23.
//

import Foundation
import UIKit

extension UIColor {
    var contrastingColor: UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            // Return black as a default if the color components can't be retrieved
            return UIColor.black
        }
        
        // Calculate luminance using the YIQ equation
        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue
        
        // Return black or white UIColor depending on the luminance of the original color
        return luminance > 0.5 ? UIColor.black : UIColor.white
    }
}
