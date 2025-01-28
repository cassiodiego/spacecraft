//
//  Constants.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 16/05/20.
//  Copyright © 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    struct Assets {
        static let firstBackground: String = "background"
        static let auroraOne: String = "auroraOne"
        static let rockOne: NSString = "rockOne"
        static let rockTwo: NSString = "rockTwo"
        static let rockThree: NSString = "rockThree"
        static let whiteStar: String = "whiteStar"
        static let starParticle: String = "starParticle"
        static let yellowStar: String = "yellowStar"
        static let orangeShot: String = "orangeShot"
        static let blueShot: String = "blueShot"
        static let armory: String = "Armory"
        static let rinzler: String = "Rinzler"
        static let spacecraftLogo = "spacecraftLogo"
        static let twoShips = "twoShips"
        static let shotSound: String = "shotSound"
        static let backgroundMusicOne: String = "backgroundMusicOne"
        static let scoreBackgroundOne: String = "scoreBackgroundOne"
        static let scoreBackgroundTwo: String = "scoreBackgroundTwo"
        static let scoreIcon: String = "scoreIcon"
        static let heartIcon: String = "heartIcon"
        static let exitButton: String = "x"
    }

    struct Directions {
        static let left: String = "left"
        static let right: String = "right"
    }
    
    struct UI {
        static let spacecraftBlue: UIColor = Utils.hexStringToUIColor(hex: "#1C5FAA")
    }
    
    struct Fonts {
        static let main: String = "Helvetica"
        static let pressStart: String = "PressStart2P-Regular"
    }
    
    struct CollisionCategories {
        static let rockCategory: UInt32 = 0x1 << 1
        static let shotCategory: UInt32 = 0x1 << 0
        static let playerCategory: UInt32 = 0x1 << 0
        static let EdgeBody: UInt32 = 0x1 << 4
    }
    
    struct GameHeaderProportions {
        static let scoreIconXProportion: CGFloat = 0.12
        static let livesIconXProportion: CGFloat = 0.48
        static let exitButtonXProportion: CGFloat = 0.84
        static let iconsYProportion: CGFloat = 0.895
        static let exitButtonYProportion: CGFloat = 0.896
        static let zPosition: CGFloat = 20
        static let exitButtonScale: CGFloat = 0.50
    }

    struct DataConfigKeys {
        static let highscore: String = "highscore"
        static let ship: String = "ship"
        static let soundStatus: String = "soundStatus"
        static let musicStatus: String = "musicStatus"
    }
    
    struct GameCenterConfig {
        static let leaderboardId: String = "LeaderboardSpacecraftI"
    }

    struct GameConfigInitialValues {
        static let velocity = 200/1
    }
    
    struct GameAcelerometerValues {
        static let accelerometerUpdateInterval: Double = 0.1
        static let accelerationXMult: Double = 500
    }
    
    struct Author {
        static let email: String = "hello@cassiodiego.com"
        static let site: String = "cassiodiego.com"
    }

}
