import UIKit

public class ImageFilters {
    let originalImage: RGBAImage
    
    public init(image: UIImage) {
        self.originalImage = RGBAImage(image: image)!
    }
    
    func apply(filters: Filter...) -> UIImage {
        var filterImage = originalImage
        for filter in filters {
            filter.apply(&filterImage)
        }
        return filterImage.toUIImage()!
    }

}