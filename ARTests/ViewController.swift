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
        sceneView.debugOptions = [SCNDebugOptions.showWorldOrigin, SCNDebugOptions.showFeaturePoints] //, .showWireframe]
        
        let scene = SCNScene()
        sceneView.scene = scene
        let startPoint = SCNVector3(0,0,-3)
        let originPoint = createNode(at: startPoint)
        scene.rootNode.addChildNode(originPoint)
        
        
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
    
    // MARK: Internal Functions
    func createNode(at position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 0.4)
        let node = SCNNode(geometry: sphere)
        node.position = position
        
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        return node
    }
    
    
}
