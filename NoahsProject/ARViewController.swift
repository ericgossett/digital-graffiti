//
//  ARViewController.swift
//  NoahsProject
//
//  Created by YUNHAN WANG on 11/12/17.
//  Copyright © 2017 Duke University. All rights reserved.
//

import UIKit
import ARKit

enum paintingBrush{
    case box
    case sphere
}

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var drawButton: RoundButton!
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    var boxSize = 0.1
    var rotationY = 0
    var texture = #imageLiteral(resourceName: "Grass")
    var brush = paintingBrush.box
    var brushColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view.
        brushColor = UIColor.cyan
    }

    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        let boxscale = CGFloat(boxSize)
        
        DispatchQueue.main.async {
            var pointer = SCNNode()
            if(self.brush == paintingBrush.box){
                pointer = SCNNode(geometry: SCNBox(width: boxscale, height: boxscale, length: boxscale, chamferRadius: 0))
                pointer.geometry?.firstMaterial?.diffuse.contents = self.texture
            }else if (self.brush == paintingBrush.sphere){
                pointer = SCNNode(geometry: SCNSphere(radius: boxscale/10))
                pointer.geometry?.firstMaterial?.diffuse.contents = self.brushColor
                if(self.drawButton.isHighlighted){
                    let sphereNode = SCNNode(geometry: SCNSphere(radius: boxscale/10))
                    sphereNode.geometry?.firstMaterial?.diffuse.contents = self.brushColor
                    sphereNode.position = currentPositionOfCamera
                    sphereNode.name = "sphere"
                    self.sceneView.scene.rootNode.addChildNode(sphereNode)
                }
            }
            pointer.name = "pointer"
            pointer.position = currentPositionOfCamera
            pointer.eulerAngles = SCNVector3(0,self.rotationY,0)
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
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPositionOfCamera = orientation + location
        
        if(brush == paintingBrush.box){
            // Minecraft functionality
            let boxscale = CGFloat(boxSize)
            let boxNode = SCNNode(geometry: SCNBox(width: boxscale, height: boxscale, length: boxscale, chamferRadius: 0))
            boxNode.position = currentPositionOfCamera
            boxNode.eulerAngles = SCNVector3(0,self.rotationY,0)
            boxNode.geometry?.firstMaterial?.diffuse.contents = texture
            //        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
            self.sceneView.scene.rootNode.addChildNode(boxNode)
        }
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
    @IBAction func boxBrush(_ sender: Any) {
        brush = paintingBrush.box
    }
    @IBAction func sphereBrush(_ sender: Any) {
        brush = paintingBrush.sphere
    }
    @IBAction func red(_ sender: Any) {
        brushColor = UIColor.red
    }
    @IBAction func yellow(_ sender: Any) {
        brushColor = UIColor.yellow
    }
    @IBAction func green(_ sender: Any) {
        brushColor = UIColor.green
    }
    @IBAction func cyan(_ sender: Any) {
        brushColor = UIColor.cyan
    }
    @IBAction func blue(_ sender: Any) {
        brushColor = UIColor.blue
    }
    @IBAction func purple(_ sender: Any) {
        brushColor = UIColor.purple
    }
    @IBAction func white(_ sender: Any) {
        brushColor = UIColor.white
    }
    @IBAction func gray(_ sender: Any) {
        brushColor = UIColor.gray
    }
    @IBAction func black(_ sender: Any) {
        brushColor = UIColor.black
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
