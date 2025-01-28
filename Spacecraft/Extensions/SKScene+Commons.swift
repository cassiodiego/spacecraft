//
//  SKScene+Commons.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 27/01/24.
//  Copyright (c) 2024 Cassio Diego Tavares Campos. All rights reserved.
//

import SpriteKit

extension SKScene {
    func exitGame() {
        guard let view = self.view else { return }
        _ = SKTransition.flipHorizontal(withDuration: 0.5)
        
        if let mainVC = view.window?.rootViewController as? MainViewController {
            view.window?.rootViewController = mainVC
            mainVC.dismiss(animated: true, completion: nil)
        }
    }
    
    func verifyHighscore(score: String) -> String{
        var highscore: String
        Utils.alreadyExistDataForKey(key: Constants.DataConfigKeys.highscore) ? (highscore = (UserDefaults.standard.object(forKey: Constants.DataConfigKeys.highscore)! as? String)!) : (highscore = "0")

        if (Int(score))! > (Int(highscore))! {
            UserDefaults.standard.set(score, forKey: Constants.DataConfigKeys.highscore)
            GameCenterViewController().syncScore()
        }
        return highscore
    }
}
