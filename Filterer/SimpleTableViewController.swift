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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = simpleTableView.dequeueReusableCell(withIdentifier: "SimpleCell", for: indexPath)
        cell.textLabel!.text = filters[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(filters[(indexPath as NSIndexPath).row])
    }
}
