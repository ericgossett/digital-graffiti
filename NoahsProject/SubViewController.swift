//
//  SubViewController.swift
//  NoahsProject
//
//  Created by ece on 11/8/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import Foundation
import UIKit

class SubViewController: UITableViewController{
    @IBOutlet var subTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subTableView.reloadData()
        
    }
    override func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subTableCell") as! SubTableViewCell
        cell.subCellLab.text=subArr[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let curRow = indexPath.row
            subArr.remove(at: curRow)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 115.0
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Subscriptions"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subArr.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
}
