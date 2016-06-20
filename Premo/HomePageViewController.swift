//
//  HomePageViewController.swift
//  Premo
//
//  Created by Manish Dwibedy on 6/17/16.
//  Copyright © 2016 Manish Dwibedy. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var items: [String] = ["Party 1", "Party 2", "Party 3"]

    @IBOutlet weak var partyList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.partyList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "party_cell")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.partyList.dequeueReusableCellWithIdentifier("party_cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)")
    }
}
