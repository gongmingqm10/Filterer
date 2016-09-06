//
//  ViewController.swift
//  Filterer
//
//  Created by Ming Gong on 8/18/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var densitySlider: UISlider! {
        didSet {
            densitySlider.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        }
    }
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var compareBtn: UIButton!
    
    let filterCellSelectedColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5)
    let filtersData = [
        FilterModel(label: "Gray", image: UIImage(named: "FilterGray")!, filterType: FilterType.BW, adjustable: true),
        FilterModel(label: "Layer", image: UIImage(named: "FilterLayer")!, filterType: FilterType.LAYER, adjustable: false),
        FilterModel(label: "Black", image: UIImage(named: "FilterBlack")!, filterType: FilterType.BLACK, adjustable: false),
        FilterModel(label: "Reverse", image: UIImage(named: "FilterReverse")!, filterType: FilterType.REVERSE, adjustable: false),
        FilterModel(label: "Relief", image: UIImage(named: "FilterRelief")!, filterType: FilterType.RELIEF, adjustable: false)
    ]
    
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

        loadImage(UIImage(named: "SampleImage")!)
        compareBtn.enabled = false
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.imageTouched(_:)))
        tap.minimumPressDuration = 0
        targetImage.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [targetImage.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }

    @IBAction func changeDensityValue(sender: AnyObject) {
        showFilterImage()
    }
    
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New photo", message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action) in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { (action) in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    @IBAction func onCompare(sender: UIButton) {
        if sender.selected {
            showFilterImage()
        } else {
            updateTargetImage(originalImage!)
            originalLabel.hidden = false
        }
        
        sender.selected = !sender.selected
    }
    
    @IBAction func onFilter(sender: UIButton) {
        sender.selected = !sender.selected

        if(sender.selected) {
            showFiltersColectionView()
        } else {
            hideFiltersCollectionView()
        }
    }
    
    func imageTouched(gesture: UITapGestureRecognizer) {
        if selectedType == nil {
            return
        }
        if gesture.state == .Began {
            updateTargetImage(originalImage!)
            originalLabel.hidden = false
        } else if gesture.state == .Ended {
            showFilterImage()
        }
    }
    
    func loadImage(image: UIImage) {
        originalImage = image
        imageFilters = ImageFilters(image: image)
        targetImage.image = image
    }

    func showFiltersColectionView() {
        view.addSubview(filtersCollectionView)
        
        let bottomConstraint = filtersCollectionView.bottomAnchor.constraintEqualToAnchor(actionStackView.topAnchor)
        let leftConstraint = filtersCollectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = filtersCollectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = filtersCollectionView.heightAnchor.constraintEqualToConstant(119)
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        
        filtersCollectionView.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.filtersCollectionView.alpha = 1
        }
    }
    
    func hideFiltersCollectionView() {
        UIView.animateWithDuration(0.4, animations: { 
            self.filtersCollectionView.alpha = 0
            }) { completed in
                if completed {
                    self.filtersCollectionView.removeFromSuperview()
                }
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersData.count
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let filterViewCell = collectionView.cellForItemAtIndexPath(indexPath) as? FilterViewCell {
            UIView.animateWithDuration(0.1) {
                filterViewCell.backgroundColor = UIColor.clearColor()
                filterViewCell.selected = false
            }
        }
    }
 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let filterViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("FilterViewCell", forIndexPath: indexPath) as! FilterViewCell
        let filterData = filtersData[indexPath.row]
        filterViewCell.populate(filterData.label, image: filterData.image)
        filterViewCell.backgroundColor = filterViewCell.selected ? filterCellSelectedColor : UIColor.clearColor()
    
        return filterViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let filterViewCell = collectionView.cellForItemAtIndexPath(indexPath) as? FilterViewCell {
            UIView.animateWithDuration(0.1) {
                filterViewCell.backgroundColor = self.filterCellSelectedColor
                filterViewCell.selected = true
            }
        }

        let filterData = filtersData[indexPath.row]
        selectedType = filterData.filterType
        densitySlider.hidden = !filterData.adjustable
        densitySlider.value = 50
        showFilterImage()
    }
    
    func showFilterImage() {
        compareBtn.enabled = true
        originalLabel.hidden = true
        
        let density = densitySlider.value * 1.0 / densitySlider.maximumValue
        var processedImage: UIImage
        switch selectedType! {
        case .BW:
            processedImage = imageFilters!.apply(BWFilter(intensity: density))
        case .LAYER:
            processedImage = imageFilters!.apply(LayerFilter())
        case .BLACK:
            processedImage = imageFilters!.apply(BlackFilter())
        case .REVERSE:
            processedImage = imageFilters!.apply(ReverseFilter())
        case .RELIEF:
            processedImage = imageFilters!.apply(ReliefFilter())
        }
        
        updateTargetImage(processedImage)
    }
    
    private func updateTargetImage(processedImage: UIImage) {
        self.targetImage.alpha = 0.2
        self.targetImage.image = processedImage
        UIView.animateWithDuration(0.75, animations: {
            self.targetImage.alpha = 1
        })
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let albumPicker = UIImagePickerController()
        albumPicker.delegate = self
        albumPicker.sourceType = .PhotoLibrary
        presentViewController(albumPicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // when user click the cancel button, should handle it here.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            loadImage(image)
        }
    }


}

