//
//  GameSetupViewController.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 11/03/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import UIKit
import Firebase

class GameSetupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var db = Firestore.firestore()
    var cashier: UInt32!
    var currentUser: User!
    var amountPicked: UInt32 = 50
    
    func buyInOptions() -> Array<String> {
        var arrayOfNumbers: Array<String> = []
        let numberOfOptions = Int(cashier / 50)
        for i in 1...numberOfOptions {
            arrayOfNumbers.append(String(50 * i))
        }
        if cashier % 50 != 0 {
            arrayOfNumbers.append(String(cashier))
        }
        return arrayOfNumbers
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buyInOptions().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let wheel = buyInOptions()
        return wheel[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let wheel = buyInOptions()
        amountPicked = UInt32(wheel[row])!
        let newTitle = NSAttributedString(string: "Play " + wheel[row] + "$")
        playButton.setAttributedTitle(newTitle, for: UIControlState.normal)
    }
    
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var amountPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountPicker.delegate = self
        amountPicker.dataSource = self
        
        // Configure play button
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        playButton.layer.masksToBounds = true
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.borderWidth = 1.0
    }
    
    private func updateDb() {
    
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? GameViewController {
            let hero = Player(chipCount: amountPicked, playerId: currentUser.uid)
            let opponent = Player(chipCount: amountPicked, isHero: false)
            nextVC.gameId = NewGame(player1: hero, player2: opponent)
        }
    }

}
