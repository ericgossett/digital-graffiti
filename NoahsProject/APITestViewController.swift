//
//  APITestViewController.swift
//  NoahsProject
//
//  Created by egossett on 11/3/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import UIKit

class APITestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = APIClient()
        api.fetchUserList() { (result) in
            print(result)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
