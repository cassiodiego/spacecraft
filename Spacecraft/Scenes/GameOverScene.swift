//
//  GameOverScene.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 31/05/16.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import GameKit

class GameOverScene: GameOverSceneObjects {
    
    init(size: CGSize, won: Bool, score: String) {
        
        super.init(size: size)
        
        setupBackground()
        
        var highscore: String
        Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore) ? (highscore = (UserDefaults.standard.object(forKey: Constants.DataConfigKeys.highscore)! as? String)!) : (highscore = "0")

        if (Int(score))! > (Int(highscore))! {
            UserDefaults.standard.set(score, forKey: Constants.DataConfigKeys.highscore)
            GameCenterViewController().syncScore()
        }
        setupExitButton()
        setupScoreBackground()
        setupSpacecraftLogo()
        setupMessageLabel(won: won)
        setupScoreLabel(won: won, score: score)
        setupScoreTextLabel(highscore: highscore, score: score)
        setupTouchToRestartLabel()
        setupSpacecraftWebsiteLabel()
        setupEmailLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupStars()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if exitButton.contains(location) {
            exitGame()
        } else {
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            if touchLocation.x != 0 {
                let transition: SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene: SKScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene, transition: transition)
            }
        }
    }
    
    func exitGame() {
        guard let view = self.view else { return }
        _ = SKTransition.flipHorizontal(withDuration: 0.5)
        
        if let mainVC = view.window?.rootViewController as? MainViewController {
            view.window?.rootViewController = mainVC
            mainVC.dismiss(animated: true, completion: nil)
        }
    }
}

