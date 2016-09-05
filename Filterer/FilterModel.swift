//
//  FilterModel.swift
//  Filterer
//
//  Created by Ming Gong on 9/5/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import UIKit

class FilterModel {
    var label: String
    var image: UIImage
    var adjustable: Bool
    var filterType: FilterType
    
    init(label: String, image: UIImage, filterType: FilterType, adjustable: Bool) {
        self.label = label
        self.image = image
        self.filterType = filterType
        self.adjustable = adjustable
    }
}
