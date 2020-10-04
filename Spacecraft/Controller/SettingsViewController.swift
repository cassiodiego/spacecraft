//
//  SettingsViewController.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 30/12/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {

    @IBOutlet weak var musicStatus: UISwitch!
    @IBOutlet weak var soundStatus: UISwitch!
    @IBOutlet weak var shipChoice: UISegmentedControl!

    
    override func viewDidLoad() {
        musicStatus.isOn = UserDefaults.standard.bool(forKey: Constants.DataConfigKeys.musicStatus)
        soundStatus.isOn = UserDefaults.standard.bool(forKey: Constants.DataConfigKeys.soundStatus)
        let shipChoiceData: String = UserDefaults.standard.string(forKey: Constants.DataConfigKeys.ship) ?? Constants.Assets.armory
        shipChoiceData == Constants.Assets.armory ? (shipChoice.selectedSegmentIndex = 0) : (shipChoice.selectedSegmentIndex = 1)
    }

    @IBAction func saveMusicStatus(_ sender: Any) {
        UserDefaults.standard.set(musicStatus.isOn, forKey: Constants.DataConfigKeys.musicStatus)
    }

    @IBAction func saveSoundStatus(_ sender: Any) {
        UserDefaults.standard.set(soundStatus.isOn, forKey: Constants.DataConfigKeys.soundStatus)
    }

    @IBAction func saveShipChoice(_ sender: Any) {
        if(shipChoice.selectedSegmentIndex == 0) {
            UserDefaults.standard.set(Constants.Assets.armory, forKey: Constants.DataConfigKeys.ship)
        } else if(shipChoice.selectedSegmentIndex == 1) {
            UserDefaults.standard.set(Constants.Assets.rinzler, forKey: Constants.DataConfigKeys.ship)
        }
    }
    
    @IBAction func backToHome(_ sender: Any) {
            self.view.removeFromSuperview()
            self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
