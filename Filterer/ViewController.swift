//
//  ViewController.swift
//  Filterer
//
//  Created by Ming Gong on 8/18/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource {

    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var densitySlider: UISlider! {
        didSet {
            densitySlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        }
    }
    
    let filtersData = [["label": "Original", "image": "FilterOriginal"],
                       ["label": "Black & White", "image": "FilterOriginal"],
                       ["label": "Layer", "image": "FilterOriginal"]]
    let filtersType = [FilterType.ORIGINAL, FilterType.BW, FilterType.LAYER]

    var originalImage: UIImage?
    var imageFilters: ImageFilters?
    var selectedType: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self
        originalImage = UIImage(named: "SampleImage")!
        
        densitySlider.hidden = true
        
        targetImage.image = originalImage
        imageFilters = ImageFilters(image: originalImage!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeDensityValue(sender: AnyObject) {
        showFilterImage()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersData.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let filterViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterViewCell", forIndexPath: indexPath) as! FilterViewCell
        let filterData = filtersData[indexPath.row]
        filterViewCell.populate(filterData["label"]!, imageName: filterData["image"]!)
    
        return filterViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedType = filtersType[indexPath.row]
        densitySlider.hidden = selectedType == FilterType.ORIGINAL
        densitySlider.value = 50

        showFilterImage()
    }
    
    func showFilterImage() {
        let density = densitySlider.value * 1.0 / densitySlider.maximumValue
        var processedImage: UIImage
        switch selectedType! {
        case .BW:
            processedImage = imageFilters!.apply(BWFilter(intensity: density))
        case .LAYER:
            processedImage = imageFilters!.apply(LayerFilter(intensity: density))
        default:
            processedImage = originalImage!
        }
        targetImage.image = processedImage
    }


}

