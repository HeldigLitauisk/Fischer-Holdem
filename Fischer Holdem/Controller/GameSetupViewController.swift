//
//  GameSetupViewController.swift
//  Fischer Holdem
//
//  Created by Eimantas Urbutis on 11/03/2018.
//  Copyright © 2018 Urbut Corp. All rights reserved.
//

import UIKit

class GameSetupViewController: UIViewController {

    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var amountPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Configure play button
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        playButton.layer.masksToBounds = true
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.layer.borderWidth = 1.0
        
        // Configure amount wheel
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
