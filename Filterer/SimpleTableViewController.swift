//
//  SimpleTableViewController.swift
//  Filterer
//
//  Created by Ming Gong on 9/4/16.
//  Copyright © 2016 Ming Gong. All rights reserved.
//

import UIKit

class SimpleTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var simpleTableView: UITableView!
    
    let filters = ["Red", "Blue", "Green", "Yellow"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        simpleTableView.dataSource = self
        simpleTableView.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = simpleTableView.dequeueReusableCellWithIdentifier("SimpleCell", forIndexPath: indexPath)
        cell.textLabel!.text = filters[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(filters[indexPath.row])
    }
}
