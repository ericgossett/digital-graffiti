//
//  ARViewController.swift
//  NoahsProject
//
//  Created by YUNHAN WANG on 11/12/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func drawContents(_ sender: Any) {
        print("something")
    }
    @IBAction func sizeUp(_ sender: Any) {
        print("sizeUp")
    }
    @IBAction func sizeDown(_ sender: Any) {
        print("sizeDown")
    }
    @IBAction func rotateLeft(_ sender: Any) {
        print("rotateLeft")
    }
    @IBAction func rotateRight(_ sender: Any) {
        print("rotateRight")
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
