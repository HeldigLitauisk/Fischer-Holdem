//
//  Colorize.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 18/02/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import Foundation
import SceneKit

struct Colorize {
    
    func colorizeCard(cardNode: Card) {
        var materials = [SCNMaterial]()
        let faceUpCard: String = String(describing: cardNode.cardValue.rank) + String(describing: cardNode.cardValue.suit)
        print(faceUpCard)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: faceUpCard)
        materials.append(material)
        for index in 2...6 {
            material.diffuse.contents = UIImage(named: "cardSide" + String(index))
            materials.append(material)
        }
        cardNode.geometry?.materials = materials
    }
    
}
