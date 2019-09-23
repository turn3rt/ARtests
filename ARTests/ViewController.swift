//
//  ViewController.swift
//  ARTests
//
//  Created by Turner Thornberry on 9/19/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    let scene = SCNScene()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the view's session
        sceneView.session.run(configuration)
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin, SCNDebugOptions.showFeaturePoints] //, .showWireframe]
        
        sceneView.scene = scene
        let startPoint = SCNVector3(0,0,0)
        let originPoint = createNode(at: startPoint)
//        originPoint.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
//        originPoint.geometry?.firstMaterial?.specular.contents = UIColor.yellow
//        scene.rootNode.addChildNode(originPoint)
        
        for i in 1...10 {
            
            createNodeRow(x: 0, y: 4*nodeRadius*Double(i), z: 0)
            createNodeRow(x: 0, y: -4*nodeRadius*Double(i), z: 0)
            createNodeRow(x: 4*nodeRadius*Double(i), y: 0, z: 0)
            createNodeRow(x: -4*nodeRadius*Double(i), y: 0, z: 0)


            for y in 1...10 {
                createNodeRow(x: 4*nodeRadius*Double(y), y: 4*nodeRadius*Double(i), z: 0)
                createNodeRow(x: 4*nodeRadius*Double(y), y: -4*nodeRadius*Double(i), z: 0)
                createNodeRow(x: -4*nodeRadius*Double(y), y: 4*nodeRadius*Double(i), z: 0)
                createNodeRow(x: -4*nodeRadius*Double(y), y: -4*nodeRadius*Double(i), z: 0)
            }
            
//            if i % 2 == 0 { // creates staggered rows
//                createNodeRow(x: 0, y: -4*nodeRadius*Double(i), z: -2*nodeRadius)
//            } else {
//                createNodeRow(x: 0, y: -4*nodeRadius*Double(i), z: 0)
//            }
            
            
            
            
//            createNodeRow(x: 4*nodeRadius*Double(i), y: 0)
//            createNodeRow(x: -4*nodeRadius*Double(i), y: 0)


            
        }
        
        
       
        // MARK: Animations
        lightOn(node: originPoint)
        moveLight(node: originPoint)
        
        
      
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: IBAction Functions
    @IBAction func resetClick(_ sender: UIButton) {
        sceneView.session.pause()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("User Reset World Origin")
    }
    
    // MARK: Internal Functions and vars
    let nodeRadius = 0.008
    func createNode(at position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: CGFloat(nodeRadius))
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.lightGray
        //material.specular.contents = UIColor.yellow
        //node.geometry?.firstMaterial?.specular.contents = UIColor.yellow
        node.geometry?.firstMaterial = material
        return node
    }
    
    func createNodeRow(x: Double, y: Double, z: Double) {
        for i in 0...10 {
        let nextNodeVector = SCNVector3(x,y, z - (4*nodeRadius*Double(i)))
        let nextPoint = createNode(at: nextNodeVector)
        scene.rootNode.addChildNode(nextPoint)
        }
    }
    
    func moveLight(node: SCNNode) {
        let moveNodeAction = SCNAction.move(to: SCNVector3(0, 0, -4*nodeRadius*10), duration: 2)
        let moveNodeBack = SCNAction.move(to: SCNVector3(0, 0, 0), duration: 2)
        
        let sequence = SCNAction.sequence([moveNodeAction, moveNodeBack])
        let repeatedSeq = SCNAction.repeatForever(sequence)
        
        node.runAction(repeatedSeq)

    }
    
    func lightOn(node: SCNNode) {
        node.light = SCNLight()
        node.light?.type = .omni
        node.light?.color = UIColor.white
       // node.light?.intensity = 200
        print("default light intensity is: \(node.light?.intensity)")
        // node.eulerAngles = SCNVector3(90, 0, 0)
//        node.light?.spotOuterAngle = 180
//        node.light?.spotInnerAngle = 90
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.geometry = SCNSphere(radius: CGFloat(nodeRadius))
        scene.rootNode.addChildNode(node)
    }
    
}
