//
//  GameViewController.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 17/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    var scene: SCNScene!
    var scnView: SCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/pokerTable.scn")!
        
        scene.physicsWorld.gravity = SCNVector3Make(0, -10, 0)
        let floor = scene.rootNode.childNode(withName: "floor", recursively: true)
        floor?.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "floorA")
        let leg = scene.rootNode.childNode(withName: "leg", recursively: true)
        leg?.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "pokerFelt3")
        let leather = scene.rootNode.childNode(withName: "leather", recursively: true)
        leather?.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "pokerFelt3")
        
        let newRound = RoundView()
        let cardNodes = newRound.dealCards(gamePhase: .preflop)
        for card in cardNodes {
            scene.rootNode.addChildNode(card)
            if card.name == "hero" {
                let dealHero = SCNAction.move(to: SCNVector3(0 , card.position.y, card.position.z + 15), duration: 0.2)
                card.runAction(dealHero)
            } else {
                let dealOpponent = SCNAction.move(to: SCNVector3(0 , card.position.y, card.position.z - 15), duration: 0.2)
                card.runAction(dealOpponent)
            }
            
        }
        
        // retrieve the ship node
       let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        ship.castsShadow = true
        
        // animate the 3d object
        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        //Allows actions during different phases of screen rendering
        scnView.delegate = self
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        //scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // double click reveals card
        let doubleClickGesture = UITapGestureRecognizer(target: self, action: #selector(revealCard(_:)))
        doubleClickGesture.numberOfTapsRequired = 2
        scnView.addGestureRecognizer(doubleClickGesture)
    }
    
    @objc
    func revealCard(_ gestureRecognize: UIGestureRecognizer) {
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            if result.node.name == "hero" {
                let pos = result.node.position
                let up = SCNAction.move(to: SCNVector3(pos.x, pos.y + 0.1 , pos.z), duration: 0.2)
                let rotate = (SCNAction.rotateBy(x: 0, y: 0, z: 2, duration: 0.2))
                result.node.runAction(up)
                result.node.runAction(rotate)
            }
        }
    }
    
   @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            if result.node.name == "hero" {
                let pos = result.node.position
                let up = SCNAction.move(to: SCNVector3(pos.x , pos.y, pos.z - 0.05), duration: 0.02)
                result.node.runAction(up)
                
                let material = result.node.geometry!.materials[2]
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                SCNTransaction.completionBlock = {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    material.emission.contents = UIColor.black
                    SCNTransaction.commit()
                }
                material.emission.contents = UIColor.green
                SCNTransaction.commit()
            }
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("didBeginContact")
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        print("didEndContact")
    }
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        print("didUpdateContact")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
