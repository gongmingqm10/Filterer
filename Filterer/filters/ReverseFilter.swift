//
//  ReverseFilter.swift
//  Filterer
//
//  Created by Ming Gong on 9/5/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import Foundation

class ReverseFilter: Filter {
    func apply(inout rgbaImage: RGBAImage) {
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = x + y * rgbaImage.width
                let pixel = rgbaImage.pixels[index]
                rgbaImage.pixels[index].blue = UInt8(255 - Int(pixel.blue))
                rgbaImage.pixels[index].green = UInt8(255 - Int(pixel.green))
                rgbaImage.pixels[index].red =  UInt8(255 - Int(pixel.red))
            }
        }
    }
}