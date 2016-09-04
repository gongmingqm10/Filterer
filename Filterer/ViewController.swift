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
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    let filtersData = [["label": "Original", "image": "FilterOriginal"],
                       ["label": "Black & White", "image": "FilterOriginal"],
                       ["label": "Layer", "image": "FilterOriginal"]]
    let filtersType = [FilterType.ORIGINAL, FilterType.BW, FilterType.LAYER]

    var originalImage: UIImage?
    var imageFilters: ImageFilters?
    var selectedType: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self
        
        densitySlider.hidden = true
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        targetImage.translatesAutoresizingMaskIntoConstraints = false

        originalImage = UIImage(named: "SampleImage")!
        imageFilters = ImageFilters(image: originalImage!)
        
        targetImage.image = originalImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeDensityValue(sender: AnyObject) {
        showFilterImage()
    }
    
    @IBAction func onFilter(sender: UIButton) {
        sender.selected = !sender.selected

        if(sender.selected) {
            showFiltersColectionView()
        } else {
            hideFiltersCollectionView()
        }
    }

    func showFiltersColectionView() {
        view.addSubview(filtersCollectionView)
        
        let bottomConstraint = filtersCollectionView.bottomAnchor.constraintEqualToAnchor(actionStackView.topAnchor)
        let leftConstraint = filtersCollectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = filtersCollectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = filtersCollectionView.heightAnchor.constraintEqualToConstant(100)
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
    }
    
    func hideFiltersCollectionView() {
        filtersCollectionView.removeFromSuperview()
        view.layoutIfNeeded()
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

