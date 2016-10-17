import Foundation

protocol Filter {
    func apply(_ rgbaImage: inout RGBAImage)
}
