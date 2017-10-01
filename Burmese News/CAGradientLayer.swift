//
//  CAGradientLayer.swift
//  Burmese News
//
//  Created by Khant Zaw Ko on 27/9/15.
//  Copyright © 2015 Khant Zaw Ko. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func turquoiseColor() -> CAGradientLayer {
        
        let topColor = UIColor(red: 133/225.0, green: 153/225.0, blue: 220/225.0, alpha: 1)
        let bottomColor = UIColor(red: 80/225.0, green: 227/225.0, blue: 194/225.0, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer
    }
}

