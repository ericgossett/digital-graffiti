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
    
    var boxSize = 0.1
    var rotationY = 0
    var texture = #imageLiteral(resourceName: "Grass")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        let boxscale = CGFloat(boxSize)
        
        DispatchQueue.main.async {
            let pointer = SCNNode(geometry: SCNBox(width: boxscale, height: boxscale, length: boxscale, chamferRadius: 0))
            pointer.name = "pointer"
            pointer.position = currentPositionOfCamera
            pointer.eulerAngles = SCNVector3(0,self.rotationY,0)
            pointer.geometry?.firstMaterial?.diffuse.contents = self.texture
            self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                if node.name == "pointer" {
                    node.removeFromParentNode()
                }
            })
            self.sceneView.scene.rootNode.addChildNode(pointer)
            //            pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func drawContents(_ sender: Any) {
//        print("something")
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        let boxscale = CGFloat(boxSize)
        let boxNode = SCNNode(geometry: SCNBox(width: boxscale, height: boxscale, length: boxscale, chamferRadius: 0))
        boxNode.position = currentPositionOfCamera
        boxNode.eulerAngles = SCNVector3(0,self.rotationY,0)
        boxNode.geometry?.firstMaterial?.diffuse.contents = texture
        //        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
        self.sceneView.scene.rootNode.addChildNode(boxNode)
    }
    @IBAction func sizeUp(_ sender: Any) {
        boxSize += 0.02
//        print("sizeUp")
    }
    @IBAction func sizeDown(_ sender: Any) {
        boxSize -= 0.02
//        print("sizeDown")
    }
    @IBAction func rotateLeft(_ sender: Any) {
        rotationY -= 30
//        print("rotateLeft")
    }
    @IBAction func rotateRight(_ sender: Any) {
        rotationY += 30
//        print("rotateRight")
    }
    
    @IBAction func plank(_ sender: Any) {
        texture = #imageLiteral(resourceName: "Plank")
    }
    @IBAction func diamond(_ sender: Any) {
        texture = #imageLiteral(resourceName: "Diamond")
    }
    @IBAction func stone(_ sender: Any) {
        texture = #imageLiteral(resourceName: "Stone")
    }
    @IBAction func grass(_ sender: Any) {
        texture = #imageLiteral(resourceName: "Grass")
    }
    @IBAction func glass(_ sender: Any) {
        texture = #imageLiteral(resourceName: "Glass")
    }
    @IBAction func brick(_ sender: Any) {
        texture = #imageLiteral(resourceName: "Brick")
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
func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
