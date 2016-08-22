import Foundation

protocol Filter {
    func apply(inout rgbaImage: RGBAImage)
}