import Foundation

class BWFilter: Filter {
    let intensity: Float
    
    let redCoefficient = 0.299
    let greenCoefficient = 0.587
    let blueCoefficient = 0.114
    
    required init(intensity: Float) {
        self.intensity = intensity
    }
    
    func apply(inout rgbaImage: RGBAImage) {
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
    
    private func calculateGray(pixel: Pixel) -> UInt8 {
        //TODO: Apply the intensity
        let blue = Double(pixel.blue)
        let red = Double(pixel.red)
        let green = Double(pixel.green)
        let totalSquare = redCoefficient * red * red + blueCoefficient * blue * blue + greenCoefficient * green * green
        return UInt8(sqrt(totalSquare))
    }
    
}
