//
//  GameCenterController.swift
//  Spacecraft
//
//  Created by Cassio Diego T. Campos on 23/02/20.
//  Copyright © 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class GameCenterViewController : UIViewController, GKGameCenterControllerDelegate {
    
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    
    func authenticateLocalPlayer() {
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(MainViewController, error) -> Void in
            
            if((MainViewController) != nil) {
                
                MainViewController?.present(MainViewController!, animated: true, completion: nil)
                
            } else if (localPlayer.isAuthenticated) {
                
                self.gcEnabled = true
                
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: Error?) -> Void in
                    if error != nil {
                        print(error as Any)
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else { self.gcEnabled = false }
        }
    }
    
    func syncScore(){
        
        let highscore = UserDefaults.standard.object(forKey: Constants.DataConfigKeys.highscore)! as! String
        
        let sScore = GKScore(leaderboardIdentifier: Constants.GameCenterConfig.leaderboardId)
        
        sScore.value = Int64(highscore)!
        
        GKScore.report([sScore], withCompletionHandler: { (error: Error?) -> Void in
            
//            if error != nil {
//                debugPrint("[Spacecraft] Game Center Error: \(error!.localizedDescription)")
//            }
        })
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated: true, completion: nil)
        
    }
    
}
