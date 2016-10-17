//
//  ReliefFilter.swift
//  Filterer
//
//  Created by Ming Gong on 9/5/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import Foundation

class ReliefFilter: Filter {
    func apply(_ rgbaImage: inout RGBAImage) {
        
        for y in 0..<rgbaImage.height {
            var lastPixel = rgbaImage.pixels[y * rgbaImage.width]
            for x in 0..<rgbaImage.width {
                let index = x + y * rgbaImage.width
                let pixel = rgbaImage.pixels[index]
                let average = (Int(pixel.blue) - Int(lastPixel.blue) + 128 + Int(pixel.green) - Int(lastPixel.green) + 128 + Int(pixel.red) - Int(lastPixel.red) + 128) / 3
                let gray = min(255, max(0, average))
                rgbaImage.pixels[index].blue = UInt8(gray)
                rgbaImage.pixels[index].green = UInt8(gray)
                rgbaImage.pixels[index].red = UInt8(gray)
                
                lastPixel = pixel
            }
        }
    }
}
