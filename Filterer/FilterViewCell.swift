//
//  FilterViewCell.swift
//  Filterer
//
//  Created by Ming Gong on 8/22/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import UIKit

class FilterViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filterCellLabel: UILabel!
    @IBOutlet weak var filterCellImage: UIImageView!
    
    func populate(_ text: String, image: UIImage) {
        filterCellLabel.text = text
        filterCellImage.image = image
    }
}
