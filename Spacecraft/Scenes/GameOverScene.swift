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
        
        let highscore = verifyHighscore(score: score)
        
        setupBackground()
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
            if location.x != 0 {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}
