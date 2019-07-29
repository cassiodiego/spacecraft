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
        
        musicStatus.isOn = UserDefaults.standard.bool(forKey: "musicStatus")

        soundStatus.isOn = UserDefaults.standard.bool(forKey: "soundStatus")
        
        shipChoice.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "ship")
        

    }
    
    @IBAction func saveMusicStatus(_ sender: Any) {
        
        UserDefaults.standard.set(musicStatus.isOn, forKey: "musicStatus")
        
    }
    
    @IBAction func saveSoundStatus(_ sender: Any) {
        
        UserDefaults.standard.set(soundStatus.isOn, forKey: "soundStatus")
    
    }
    
    @IBAction func saveShipChoice(_ sender: Any) {
        
        var ship:Int
     
        if(shipChoice.selectedSegmentIndex == 0) {
            
            ship = 0
            
            UserDefaults.standard.set(ship, forKey: "ship")
            
        } else if(shipChoice.selectedSegmentIndex == 1) {
            
            ship = 1
            
            UserDefaults.standard.set(ship, forKey: "ship")
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }
    

}
