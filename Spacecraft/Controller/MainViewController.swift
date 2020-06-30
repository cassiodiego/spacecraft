//
//  MainViewController.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 12/12/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class MainViewController : GameCenterViewController {
    
    override func viewDidLoad() {
        
        self.authenticateLocalPlayer()
        
        let test = AlreadyExist(key: "highscore")
        
        let musicStatus = UserDefaults.standard.object(forKey: Constants.DataConfigKeys.musicStatus)
        if musicStatus == nil { UserDefaults.standard.set(true, forKey: Constants.DataConfigKeys.musicStatus) }
        
        let soundStatus = UserDefaults.standard.object(forKey: Constants.DataConfigKeys.soundStatus)
        if soundStatus == nil { UserDefaults.standard.set(true, forKey: Constants.DataConfigKeys.soundStatus) }

        if test { self.syncScore() }

    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        
        let gc: GKGameCenterViewController = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.leaderboards
        gc.leaderboardIdentifier = "LeaderboardSpacecraftI"
        self.present(gc, animated: true, completion: nil)
        
    }
    
    func AlreadyExist(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil
    
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }

}
