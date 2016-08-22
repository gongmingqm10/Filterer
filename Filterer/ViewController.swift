//
//  ViewController.swift
//  Filterer
//
//  Created by Ming Gong on 8/18/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource {

    @IBOutlet weak var filtersCollectionView: UICollectionView!
    let filtersData = [["label": "Original", "image": "FilterOriginal"],
                       ["label": "Black & White", "image": "FilterOriginal"],
                       ["label": "Light", "image": "FilterOriginal"],
                       ["label": "Popular", "image": "FilterOriginal"],
                       ["label": "Beauty", "image": "FilterOriginal"],
                       ["label": "Makeup", "image": "FilterOriginal"],
                       ["label": "Sweet", "image": "FilterOriginal"]
                       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        filtersCollectionView.dataSource = self
        filtersCollectionView.delegate = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


}

