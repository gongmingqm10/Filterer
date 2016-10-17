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
            densitySlider.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        }
    }
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var compareBtn: UIButton!
    
    let filterCellSelectedColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5)
    let filtersData = [
        FilterModel(label: "Gray", image: UIImage(named: "FilterGray")!, filterType: FilterType.bw, adjustable: true),
        FilterModel(label: "Layer", image: UIImage(named: "FilterLayer")!, filterType: FilterType.layer, adjustable: false),
        FilterModel(label: "Black", image: UIImage(named: "FilterBlack")!, filterType: FilterType.black, adjustable: false),
        FilterModel(label: "Reverse", image: UIImage(named: "FilterReverse")!, filterType: FilterType.reverse, adjustable: false),
        FilterModel(label: "Relief", image: UIImage(named: "FilterRelief")!, filterType: FilterType.relief, adjustable: false)
    ]
    
    var originalImage: UIImage?
    var imageFilters: ImageFilters?
    var selectedType: FilterType?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self
        
        densitySlider.isHidden = true
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        targetImage.translatesAutoresizingMaskIntoConstraints = false

        loadImage(UIImage(named: "SampleImage")!)
        compareBtn.isEnabled = false
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.imageTouched(_:)))
        tap.minimumPressDuration = 0
        targetImage.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onShare(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [targetImage.image!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }

    @IBAction func changeDensityValue(_ sender: AnyObject) {
        showFilterImage()
    }
    
    @IBAction func onNewPhoto(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New photo", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { (action) in
            self.showAlbum()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    @IBAction func onCompare(_ sender: UIButton) {
        if sender.isSelected {
            showFilterImage()
        } else {
            updateTargetImage(originalImage!)
            originalLabel.isHidden = false
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func onFilter(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if(sender.isSelected) {
            showFiltersColectionView()
        } else {
            hideFiltersCollectionView()
        }
    }
    
    func imageTouched(_ gesture: UITapGestureRecognizer) {
        if selectedType == nil {
            return
        }
        if gesture.state == .began {
            updateTargetImage(originalImage!)
            originalLabel.isHidden = false
        } else if gesture.state == .ended {
            showFilterImage()
        }
    }
    
    func loadImage(_ image: UIImage) {
        originalImage = image
        imageFilters = ImageFilters(image: image)
        targetImage.image = image
    }

    func showFiltersColectionView() {
        view.addSubview(filtersCollectionView)
        
        let bottomConstraint = filtersCollectionView.bottomAnchor.constraint(equalTo: actionStackView.topAnchor)
        let leftConstraint = filtersCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = filtersCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let heightConstraint = filtersCollectionView.heightAnchor.constraint(equalToConstant: 119)
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        
        filtersCollectionView.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.filtersCollectionView.alpha = 1
        }) 
    }
    
    func hideFiltersCollectionView() {
        UIView.animate(withDuration: 0.4, animations: { 
            self.filtersCollectionView.alpha = 0
            }, completion: { completed in
                if completed {
                    self.filtersCollectionView.removeFromSuperview()
                }
        }) 
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let filterViewCell = collectionView.cellForItem(at: indexPath) as? FilterViewCell {
            UIView.animate(withDuration: 0.1, animations: {
                filterViewCell.backgroundColor = UIColor.clear
                filterViewCell.isSelected = false
            }) 
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterViewCell", for: indexPath) as! FilterViewCell
        let filterData = filtersData[(indexPath as NSIndexPath).row]
        filterViewCell.populate(filterData.label, image: filterData.image)
        filterViewCell.backgroundColor = filterViewCell.isSelected ? filterCellSelectedColor : UIColor.clear
    
        return filterViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let filterViewCell = collectionView.cellForItem(at: indexPath) as? FilterViewCell {
            UIView.animate(withDuration: 0.1, animations: {
                filterViewCell.backgroundColor = self.filterCellSelectedColor
                filterViewCell.isSelected = true
            }) 
        }

        let filterData = filtersData[(indexPath as NSIndexPath).row]
        selectedType = filterData.filterType
        densitySlider.isHidden = !filterData.adjustable
        densitySlider.value = 50
        showFilterImage()
    }
    
    func showFilterImage() {
        compareBtn.isEnabled = true
        originalLabel.isHidden = true
        
        let density = densitySlider.value * 1.0 / densitySlider.maximumValue
        var processedImage: UIImage
        switch selectedType! {
        case .bw:
            processedImage = imageFilters!.apply(BWFilter(intensity: density))
        case .layer:
            processedImage = imageFilters!.apply(LayerFilter())
        case .black:
            processedImage = imageFilters!.apply(BlackFilter())
        case .reverse:
            processedImage = imageFilters!.apply(ReverseFilter())
        case .relief:
            processedImage = imageFilters!.apply(ReliefFilter())
        }
        
        updateTargetImage(processedImage)
    }
    
    fileprivate func updateTargetImage(_ processedImage: UIImage) {
        self.targetImage.alpha = 0.2
        self.targetImage.image = processedImage
        UIView.animate(withDuration: 0.75, animations: {
            self.targetImage.alpha = 1
        })
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        present(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let albumPicker = UIImagePickerController()
        albumPicker.delegate = self
        albumPicker.sourceType = .photoLibrary
        present(albumPicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // when user click the cancel button, should handle it here.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            loadImage(image)
        }
    }


}

