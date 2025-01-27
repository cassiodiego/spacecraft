//
//  StarEmitter.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 27/01/24.
//  Copyright (c) 2024 Cassio Diego Tavares Campos. All rights reserved.
//

import UIKit

class StarEmitter {
    
    static func createStarLayer() -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        emitter.emitterSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        emitter.emitterShape = .rectangle
        emitter.emitterMode = .surface
    
        let star = CAEmitterCell()
        star.contents = UIImage(named: "spark")?.cgImage
        star.birthRate = 15
        star.lifetime = 1.0
        star.velocity = 0
        star.scale = 0.02
        star.scaleRange = 0.05
        star.alphaSpeed = -1.0
        
        emitter.emitterCells = [star]
        
        return emitter
    }
}
