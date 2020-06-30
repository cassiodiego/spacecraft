//
//  SettingsViewController.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 30/12/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var musicStatus: UISwitch!
    @IBOutlet weak var soundStatus: UISwitch!
    @IBOutlet weak var shipChoice: UISegmentedControl!
    
    override func viewDidLoad() {
        
        musicStatus.isOn = UserDefaults.standard.bool(forKey: Constants.DataConfigKeys.musicStatus)
        soundStatus.isOn = UserDefaults.standard.bool(forKey: Constants.DataConfigKeys.soundStatus)
        shipChoice.selectedSegmentIndex = UserDefaults.standard.integer(forKey: Constants.DataConfigKeys.ship)

    }
    
    @IBAction func saveMusicStatus(_ sender: Any) {
        
        UserDefaults.standard.set(musicStatus.isOn, forKey: Constants.DataConfigKeys.musicStatus)
        
    }
    
    @IBAction func saveSoundStatus(_ sender: Any) {
        
        UserDefaults.standard.set(soundStatus.isOn, forKey: Constants.DataConfigKeys.soundStatus)
    
    }
    
    @IBAction func saveShipChoice(_ sender: Any) {
        
        var ship:Int
     
        if(shipChoice.selectedSegmentIndex == 0) {
            
            ship = 0
            UserDefaults.standard.set(ship, forKey: Constants.DataConfigKeys.ship)
            
        } else if(shipChoice.selectedSegmentIndex == 1) {
            
            ship = 1
            UserDefaults.standard.set(ship, forKey: Constants.DataConfigKeys.ship)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }
    

}
