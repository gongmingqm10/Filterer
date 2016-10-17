import Foundation

class BWFilter: Filter {
    let intensity: Float
    
    let redCoefficient: Float = 0.299
    let greenCoefficient: Float = 0.587
    let blueCoefficient: Float = 0.114
    
    required init(intensity: Float) {
        self.intensity = intensity
    }
    
    func apply(_ rgbaImage: inout RGBAImage) {
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = x + y * rgbaImage.width
                let pixel = rgbaImage.pixels[index]
                let grayColor = calculateGray(pixel)
                rgbaImage.pixels[index].blue = grayColor
                rgbaImage.pixels[index].green = grayColor
                rgbaImage.pixels[index].red = grayColor
            }
        }
    }
    
    fileprivate func calculateGray(_ pixel: Pixel) -> UInt8 {
        let blue = Float(pixel.blue)
        let red = Float(pixel.red)
        let green = Float(pixel.green)
        let totalSquare = redCoefficient * red * red + blueCoefficient * blue * blue + greenCoefficient * green * green
        let calculatedGray = max(0, min(sqrt(totalSquare) - (intensity - 0.5) * 100, 255))
        return UInt8(calculatedGray)
    }
    
}
