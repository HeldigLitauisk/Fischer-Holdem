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
    var gameOverlay: GameOverlay!
    var hero: Player!
    var opponent: Player!
    var gameLogic: GameLogic!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/pokerTable.scn")!
        
        scene.physicsWorld.gravity = SCNVector3(x: 0, y: -1, z: 0)
        
        
  
        // retrieve the SCNView
        scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        //Allows actions during different phases of screen rendering
        scnView.delegate = self
        
        // display card as an overlay on screen
        scnView.overlaySKScene = GameOverlay(size: view.frame.size)
        
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // double click reveals card
        let doubleClickGesture = UITapGestureRecognizer(target: self, action: #selector(revealCard(_:)))
        doubleClickGesture.numberOfTapsRequired = 2
        scnView.addGestureRecognizer(doubleClickGesture)
        
        let cameraZoom = UIPinchGestureRecognizer(target: self, action: #selector(zoom(_:)))
        scnView.addGestureRecognizer(cameraZoom)
        
        let foldingSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        foldingSwipe.direction = [.up]
        scnView.addGestureRecognizer(foldingSwipe)
        
        let cameraSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeCamera(_:)))
        cameraSwipe.direction = [.left, .right]
        scnView.addGestureRecognizer(cameraSwipe)

        
        
        
        hero = Player(chipCount: 200)
        opponent = Player(chipCount: hero.chipCount, isHero: false)
        gameLogic = GameLogic(hero: hero, opponent: opponent)
        
        
        
        
    }
    
    func moveDealerButton() {
        let dealerButton = scene.rootNode.childNode(withName: "dealerButton", recursively: true)
        let heroPos = SCNVector3(-5, 17, -5)
        let opponentPos = SCNVector3(-5, 17, 5)
        if gameLogic.hero.isDealer {
            let moveButton = SCNAction.move(to: heroPos, duration: 1)
            dealerButton?.runAction(moveButton)
        } else {
            let moveButton = SCNAction.move(to: opponentPos, duration: 1)
            dealerButton?.runAction(moveButton)
        }
    }


    func actionButtonsOn() {
        scene.rootNode.childNode(withName: "actionButtons", recursively: true)?.isHidden = false
    }
    
    func actionButtonsOff() {
        scene.rootNode.childNode(withName: "actionButtons", recursively: true)?.isHidden = true
    }
    
    func reactionButtonsOn() {
        scene.rootNode.childNode(withName: "reactionButtons", recursively: true)?.isHidden = false
    }
    
    func reactionButtonsOff() {
        scene.rootNode.childNode(withName: "reactionButtons", recursively: true)?.isHidden = true
    }


    @objc
    func revealCard(_ gestureRecognize: UIGestureRecognizer) {

        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            if result.node.name == "52" || result.node.name == "51" {
                let cardNode = result.node as! Card
                cardNode.revealCard()
            } else if result.node.name == "dealerButton" {
                let dropDownAction = SCNAction.move(to: SCNVector3(0, 50, 0), duration: 1)
                result.node.runAction(dropDownAction)
            }
        }
    }
            
   @objc
    func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
    
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        if hitResults.count > 0 {
            let result = hitResults[0]
            var material = (result.node.geometry?.firstMaterial)!
            let pos = result.node.position
            let up = SCNAction.move(to: SCNVector3(pos.x , pos.y, pos.z - 0.3), duration: 0.02)
            if result.node.name == "52" || result.node.name == "51" {
                material = result.node.geometry!.materials[2]
                highlightNode(material: material)
                result.node.runAction(up)
                
                let cardNode = result.node as! Card
                let gameOverlay = scnView.overlaySKScene as! GameOverlay
                gameOverlay.showCard(cardNode: cardNode)
                
            } else if result.node.parent?.name == "chips" {
                
                highlightNode(material: material)
                result.node.runAction(up)
                if result.node.name == "dollar" {
                    gameLogic.increaseBetAmount(betAmount: UInt32(1))
                } else if result.node.name == "fiveDollars" {
                    gameLogic.increaseBetAmount(betAmount: UInt32(5))
                } else if result.node.name == "twentyFiveDollars" {
                        gameLogic.increaseBetAmount(betAmount: UInt32(25))
                }
            } else if result.node.parent?.name == "actionButtons" {
                highlightNode(material: material)
                if result.node.name == "fold" {
                    gameLogic.fold(player: gameLogic.hero)
                    actionButtonsOff()
                } else if result.node.name == "check" {
                    gameLogic.check(player: hero)
                    actionButtonsOff()
                } else if result.node.name == "bet" {
                    if gameLogic.betAmount != 0 {
                        gameLogic.bet(player: gameLogic.hero)
                        actionButtonsOff()
                    }
                }
            } else if result.node.parent?.name == "reactionButtons" {
                highlightNode(material: material)
                if result.node.name == "fold" {
                    gameLogic.fold(player: gameLogic.hero)
                    reactionButtonsOff()
                } else if result.node.name == "call" {
                    gameLogic.call(player: gameLogic.hero)
                    reactionButtonsOff()
                } else if result.node.name == "raise" {
                    if gameLogic.betAmount >= 2 * gameLogic.callAmount {
                        gameLogic.bet(player: gameLogic.hero)
                        reactionButtonsOff()
                    }
                }
            }
        }
    }
    
    // highlights card when clicked
    private func highlightNode(material: SCNMaterial) {
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
    
    
    @objc
    func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let p = gesture.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        let node = hitResults[0]
        if node.node.name == "52" || node.node.name == "51"  {
            let material = (node.node.geometry?.firstMaterial)!
            highlightNode(material: material)
            gameLogic.fold(player: hero)
            }
        }
    
    @objc
    func handleSwipeCamera(_ gesture: UISwipeGestureRecognizer) {
        let cameraNode = scene.rootNode.childNode(withName: "camera", recursively: false)
        let heroView = SCNAction.move(to: SCNVector3(0, 25, 28), duration: 1)
        let sideView = SCNAction.move(to: SCNVector3(-50, 50, 0), duration: 1)
        if cameraNode?.position.x == 0 {
            cameraNode?.runAction(sideView)
        } else {
            cameraNode?.runAction(heroView)
        }
    }
    
    @objc
     func zoom(_ gesture: UIPinchGestureRecognizer) {
        let node = scene.rootNode.childNode(withName: "camera", recursively: true)
        let scale = gesture.velocity
        
        let maximumFOV:CGFloat = 10
        let minimumFOV:CGFloat = 125
        
        if scale > -20 && scale < 20 {
            switch gesture.state {
            case .began:
                break
            case .changed:
                node!.camera!.fieldOfView = node!.camera!.fieldOfView - CGFloat(scale)
                if node!.camera!.fieldOfView <= maximumFOV {
                    node!.camera!.fieldOfView = maximumFOV
                }
                if node!.camera!.fieldOfView >= minimumFOV {
                    node!.camera!.fieldOfView = minimumFOV
                }
                break
            default: break
            }
        }
        
    }
    

    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        if !gameLogic.haveWinner {
            reactionButtonsOff()
            actionButtonsOff()
            gameLogic.updateCallAmount()
            
            let callAmountText = scene.rootNode.childNode(withName: "callSize", recursively: true)?.geometry as! SCNText
            callAmountText.string = String(gameLogic.callAmount) + "$"
            let raiseAmountText = scene.rootNode.childNode(withName: "raiseAmount", recursively: true)?.geometry as! SCNText
            raiseAmountText.string = String(gameLogic.betAmount) + "$"
            
            if gameLogic.heroToAct && gameLogic.callAmount > 0  {
                reactionButtonsOn()
            } else if gameLogic.heroToAct && gameLogic.callAmount == 0 {
                actionButtonsOn()
            } else if gameLogic.computerToAct && gameLogic.callAmount > 0 {
                self.gameLogic.computerToAct = false
                self.gameLogic.heroToAct = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.gameLogic.randomReactionDecision()
                }
            } else if gameLogic.computerToAct && gameLogic.callAmount == 0 {
                self.gameLogic.computerToAct = false
                self.gameLogic.heroToAct = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.gameLogic.randomActionDecision()
                }
            }
        }
        
        if gameLogic.haveWinner {
            if gameLogic.opponent.chipCount < 3 {
                gameLogic.opponent.chipCount += 200
            }
            reactionButtonsOff()
            actionButtonsOff()
            gameLogic.haveWinner = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.gameLogic.updateDeck()
                self.gameLogic.updateChips()
                self.scene.rootNode.addChildNode(self.hero.chips)
                self.scene.rootNode.addChildNode(self.gameLogic.deck)
                self.scene.rootNode.addChildNode(self.opponent.chips)
                self.gameLogic.startNewGame()
            }
            moveDealerButton()
        }
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
        // let taps = event?.allTouches
       // let firstTouch = taps?.count
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
