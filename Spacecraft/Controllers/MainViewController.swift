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

class MainViewController: GameCenterViewController {
    
    @IBOutlet weak var startGame: UILabel!
    
    override func viewDidLoad() {
        
        startGame.blink()
        startGame.attributedText = NSAttributedString(
            string: NSLocalizedString("START_LABEL", comment: "Start the game"),
            attributes: Utils.setupLetterpress())
        
        self.authenticateLocalPlayer()
        !(Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.musicStatus)) ?
            UserDefaults.standard.set(true, forKey: Constants.DataConfigKeys.musicStatus) : nil

        !(Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.soundStatus)) ?
            UserDefaults.standard.set(true, forKey: Constants.DataConfigKeys.soundStatus) : nil

        Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore) ? self.syncScore() : nil
        
        let starLayer = StarEmitter.createStarLayer()
        view.layer.addSublayer(starLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startGame.blink()
    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        let gameCenter: GKGameCenterViewController = GKGameCenterViewController()
        gameCenter.gameCenterDelegate = self
        gameCenter.viewState = GKGameCenterViewControllerState.leaderboards
        gameCenter.leaderboardIdentifier = Constants.GameCenterConfig.leaderboardId
        self.present(gameCenter, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
