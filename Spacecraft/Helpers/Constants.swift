//
//  Constants.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 16/05/20.
//  Copyright © 2020 Cassio Diego Tavares Campos. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Assets {
        static let firstBackground:String = "background"
        static let rockOne:NSString = "rock_1"
        static let rockTwo:NSString = "rock_2"
        static let rockThree:NSString = "rock_3"
        static let whiteStar:String = "star"
        static let yellowStar:String = "yellowStar"
        static let orangeShot:String = "shot"
        static let blueShot:String = "shot2"
        static let spacecraftOne:String = "spacecraft"
        static let spacecraftTwo:String = "spacecraft2"
    }
    
    struct Directions {
        static let left:String = "left"
        static let right:String = "right"
    }
    
    struct CollisionCategories {
        static let rockCategory:UInt32 = 0x1 << 1
        static let shotCategory:UInt32 = 0x1 << 0
        static let playerCategory:UInt32 = 0x1 << 0
        static let EdgeBody: UInt32 = 0x1 << 4
    }
    
    struct DataConfigKeys {
        static let ship:String = "ship"
        static let soundStatus:String = "soundStatus"
    }
    
    struct GameConfigInitialValues {
        static let velocity = 200/1
    }
    
    struct Levels {
        struct LevelOne {
            
        }
    }

}
