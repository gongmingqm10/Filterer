import UIKit

open class ImageFilters {
    let originalImage: RGBAImage
    
    public init(image: UIImage) {
        self.originalImage = RGBAImage(image: image)!
    }
    
    func apply(_ filters: Filter...) -> UIImage {
        var filterImage = originalImage
        for filter in filters {
            filter.apply(&filterImage)
        }
        return filterImage.toUIImage()!
    }

}
