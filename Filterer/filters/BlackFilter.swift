//
//  BlackFilter.swift
//  Filterer
//
//  Created by Ming Gong on 9/5/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import Foundation

class BlackFilter: Filter {

    func apply(_ rgbaImage: inout RGBAImage) {
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = x + y * rgbaImage.width
                let pixel = rgbaImage.pixels[index]
                let grayColor = calculateBlack(pixel)
                rgbaImage.pixels[index].blue = grayColor
                rgbaImage.pixels[index].green = grayColor
                rgbaImage.pixels[index].red = grayColor
            }
        }
    }
    
    fileprivate func calculateBlack(_ pixel: Pixel) -> UInt8 {
        let blue = Float(pixel.blue)
        let red = Float(pixel.red)
        let green = Float(pixel.green)
        let average = (blue + red + green) / 3
        return average > 100 ? UInt8(255) : UInt8(0)
    }
}
