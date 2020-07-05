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
                
        let musicStatus = UserDefaults.standard.object(forKey: Constants.DataConfigKeys.musicStatus)
        if musicStatus == nil { UserDefaults.standard.set(true, forKey: Constants.DataConfigKeys.musicStatus) }
        
        let soundStatus = UserDefaults.standard.object(forKey: Constants.DataConfigKeys.soundStatus)
        if soundStatus == nil { UserDefaults.standard.set(true, forKey: Constants.DataConfigKeys.soundStatus) }

        Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore) ? self.syncScore() : nil

    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        
        let gc: GKGameCenterViewController = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.leaderboards
        gc.leaderboardIdentifier = Constants.GameCenterConfig.leaderboardId
        self.present(gc, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override var prefersStatusBarHidden : Bool {
        
        return true
        
    }

}
