//
//  GameScene.swift
//  Spacecraft
//
//  Created by Cassio Diego Tavares Campos on 31/05/16.
//  Modified by Cassio Diego Tavares Campos on 11/03/19.
//  Copyright (c) 2016 Cassio Diego Tavares Campos. All rights reserved.

import SpriteKit
import CoreMotion
import AudioToolbox.AudioServices
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player:SKSpriteNode = SKSpriteNode()
    var leftJet:SKSpriteNode = SKSpriteNode()
    var rightJet:SKSpriteNode = SKSpriteNode()
    var motionManager = CMMotionManager()
    var xAcceleration:CGFloat  = 0.0
    
    var explosion:SKSpriteNode!
    
    var fireLeft:SKSpriteNode!
    var fireRight:SKSpriteNode!
    
    var lastYieldTimeIntervalRock:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalRock:TimeInterval = TimeInterval()
    
    var lastYieldTimeIntervalStar:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalStar:TimeInterval = TimeInterval()
    
    var lastYieldTimeIntervalAurora:TimeInterval = TimeInterval()
    var lastUpdateTimerIntervalAurora:TimeInterval = TimeInterval()
    var lastYieldTimeIntervalYellowStar:TimeInterval = TimeInterval()
    
    var rocksDestroyed:Int = 0
    
    struct CollisionCategories{
        static let rockCategory:UInt32 = 0x1 << 1
        static let shotCategory:UInt32 = 0x1 << 0
        static let playerCategory:UInt32 = 0x1 << 0
        static let EdgeBody: UInt32 = 0x1 << 4
    }
    
    var scoreLabel:SKLabelNode = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        setupPlayer()
        
        setupAcelerometer()
        
        setupJet(x: self.player.position.x-10, y: self.player.position.y-30, side: "left")

        setupJet(x: self.player.position.x+10, y: self.player.position.y-30, side: "right")
        
    }
    
    override init(size:CGSize){
        
        super.init(size: size)
        
        self.view?.isMultipleTouchEnabled = false

        self.physicsBody?.collisionBitMask = CollisionCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        var Background:SKSpriteNode = SKSpriteNode()

        self.backgroundColor = SKColor.black
        
        let screenSize = UIScreen.main.bounds
        _ = screenSize.width
        _ = screenSize.height
        
        Background = SKSpriteNode(imageNamed: "background")
        
        Background.position = CGPoint(x: (screenSize.width * 0.40), y: (screenSize.height * 0.500))
        
        Background.zPosition = 1
        
        self.addChild(Background)
        
        scoreLabel.position = CGPoint(x: (screenSize.width * 0.10), y: (screenSize.height * 0.88))
        
        scoreLabel.zPosition = 2
        
        self.addChild(scoreLabel)
        
        scoreLabelUpdate(0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func setupAcelerometer(){
        
        if motionManager.isAccelerometerAvailable == true {
            
            motionManager.accelerometerUpdateInterval = 0.1
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                
                data, error in

                let currentX = self.player.position.x
                
                if (data!.acceleration.x < 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
                    
                else if (data!.acceleration.x > 0) { self.xAcceleration = currentX + CGFloat((data?.acceleration.x)! * 500) }
            })
        }
    }
    
    func alreadyExist(key: String) -> Bool { return UserDefaults.standard.object(forKey: key) != nil }
    
    func setupPlayer(){
        
        let ship = self.getKindShip()
        
        var spritePlayer:String = ""
        
        ship == 0 ? (spritePlayer = "spacecraft") : (spritePlayer = "spacecraft2")

        player = SKSpriteNode(imageNamed: spritePlayer)
        player.position = CGPoint(x: self.frame.size.width/2, y: player.size.height/2 + 30)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
        player.physicsBody!.isDynamic = true
        player.physicsBody!.categoryBitMask = CollisionCategories.playerCategory
        player.physicsBody!.contactTestBitMask = CollisionCategories.rockCategory
        player.physicsBody!.categoryBitMask = CollisionCategories.EdgeBody
        player.physicsBody!.collisionBitMask = 0
        player.physicsBody!.usesPreciseCollisionDetection = true
        player.physicsBody?.velocity = CGVector(dx: xAcceleration * 900, dy: 0)
        player.zPosition = 5
        self.addChild(player)
    }
    
    func jetAnimation() -> SKAction{
        let anim = SKAction.animate(with: [SKTexture(imageNamed: "f-1"), SKTexture(imageNamed: "f-2"), SKTexture(imageNamed: "f-3"),
                                           SKTexture(imageNamed: "f-4"), SKTexture(imageNamed: "f-5"), SKTexture(imageNamed: "f-6"),
                                           SKTexture(imageNamed: "f-7"), SKTexture(imageNamed: "f-8"), SKTexture(imageNamed: "f-9"),
                                           SKTexture(imageNamed: "f-10"), SKTexture(imageNamed: "f-11"), SKTexture(imageNamed: "f-12"),
                                           SKTexture(imageNamed: "f-13"), SKTexture(imageNamed: "f-14"), SKTexture(imageNamed: "f-15"),
                                           SKTexture(imageNamed: "f-16"), SKTexture(imageNamed: "f-17"), SKTexture(imageNamed: "f-18"),
                                           SKTexture(imageNamed: "f-19"), SKTexture(imageNamed: "f-20"), SKTexture(imageNamed: "f-21"),
                                           SKTexture(imageNamed: "f-22"), SKTexture(imageNamed: "f-23"), SKTexture(imageNamed: "f-24"),
                                           SKTexture(imageNamed: "f-25"), SKTexture(imageNamed: "f-26"), SKTexture(imageNamed: "f-27"),
                                           SKTexture(imageNamed: "f-28"), SKTexture(imageNamed: "f-29"), SKTexture(imageNamed: "f-30"),
                                           SKTexture(imageNamed: "f-31"), SKTexture(imageNamed: "f-32"), SKTexture(imageNamed: "f-33"),
                                           SKTexture(imageNamed: "f-34"), SKTexture(imageNamed: "f-35"), SKTexture(imageNamed: "f-36"),
                                           SKTexture(imageNamed: "f-37"), SKTexture(imageNamed: "f-38"), SKTexture(imageNamed: "f-39")],
                                    timePerFrame: 0.09)
        return anim
    }
    
    func setupJet(x:CGFloat, y:CGFloat, side: String){

        let anim = self.jetAnimation()
        let boom = SKAction.repeatForever(anim)
        
        let fire = SKSpriteNode(texture: SKTexture(imageNamed: "f-1"))
        fire.setScale(0.05)
        fire.position = CGPoint(x: x, y: y)
        fire.zPosition = 4
        
        fire.run(boom)

        if(side == "left"){
            
            fireLeft = fire
            self.addChild(fireLeft)
            
        } else if(side == "right") {
            
            fireRight = fire
            self.addChild(fireRight)
            
        }

    }
    
    func setupRock(_ rockType:NSString, score:Int){
        
        let rock:SKSpriteNode = SKSpriteNode(imageNamed: rockType as String)
        let minX = rock.size.width/2
        let maxX = self.frame.size.width - rock.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        rock.physicsBody = SKPhysicsBody(rectangleOf: rock.size)
        rock.physicsBody!.isDynamic = true
        rock.physicsBody!.categoryBitMask = CollisionCategories.rockCategory
        rock.physicsBody!.contactTestBitMask = CollisionCategories.shotCategory
        rock.physicsBody!.contactTestBitMask = CollisionCategories.playerCategory
        rock.physicsBody!.collisionBitMask = 0
        rock.zPosition = 4
        rock.position = CGPoint(x: position, y: self.frame.size.height+rock.size.height)
        
        self.addChild(rock)
        
        var minDuration = 2
        var maxDuration = 4
        
        if score > 50 {
            
            minDuration = 1
            maxDuration = 4
            
        } else if score > 100{
            
            minDuration = 1
            maxDuration = 1
            
        }
        
        let rangeDuration = maxDuration - minDuration
        
        let duration = Int(arc4random_uniform(20)) % Int(rangeDuration) + Int(minDuration)
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -rock.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        rock.run(SKAction.sequence(actionArray))
    }
    
    func setupStar(kind: String, minDuration: Int, maxDuration: Int, duration: Int){
        
        let star:SKSpriteNode = SKSpriteNode(imageNamed: kind)
        let minX = star.size.width/2
        let maxX = self.frame.size.width - star.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        star.zPosition = 3
        star.position = CGPoint(x: position, y: self.frame.size.height+star.size.height)
        
        self.addChild(star)
        
        let rangeDuration = maxDuration - minDuration
        let duration = Int(arc4random_uniform(20)) % Int(rangeDuration) + Int(minDuration)
        
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -star.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        star.run(SKAction.sequence(actionArray))
        
    }
    
    func setupAurora(){
        
        let aurora:SKSpriteNode = SKSpriteNode(imageNamed: "aurora-1")
        
        aurora.zPosition = 2
        
        let minX = aurora.size.width/2
        let maxX = self.frame.size.width - aurora.size.width/2
        let rangeX = maxX - minX
        let position:CGFloat = CGFloat(arc4random()).truncatingRemainder(dividingBy: CGFloat(rangeX)) + CGFloat(minX)
        
        aurora.position = CGPoint(x: position, y: self.frame.size.height+aurora.size.height)
        
        self.addChild(aurora)
        
        let duration = 25
        var actionArray = [SKAction]()
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -aurora.size.height), duration:TimeInterval(duration)))
        actionArray.append(SKAction.removeFromParent())
        aurora.run(SKAction.sequence(actionArray))
        
    }
    
    func setupExplosion(x:CGFloat, y:CGFloat){
        
        let boom = SKAction.repeatForever(
            SKAction.animate(with: [SKTexture(imageNamed: "e-1"), SKTexture(imageNamed: "e-2"), SKTexture(imageNamed: "e-3"),
                                    SKTexture(imageNamed: "e-4"), SKTexture(imageNamed: "e-5"), SKTexture(imageNamed: "e-6"),
                                    SKTexture(imageNamed: "e-7"), SKTexture(imageNamed: "e-8"), SKTexture(imageNamed: "e-9")],
                             timePerFrame: 0.09))
        
        explosion = SKSpriteNode(texture: SKTexture(imageNamed: "e-1"))
        explosion.setScale(0.6)
        explosion.position = CGPoint(x: x, y: y)
        explosion.zPosition = 6

        explosion.run(boom)
 
        self.addChild(explosion)
    }
    
    func updateWithTimeSinceLastUpdate(_ timeSinceLastUpdate:CFTimeInterval){
        
        lastYieldTimeIntervalRock += timeSinceLastUpdate
        lastYieldTimeIntervalStar += timeSinceLastUpdate
        lastYieldTimeIntervalAurora += timeSinceLastUpdate
        lastYieldTimeIntervalYellowStar += timeSinceLastUpdate
        
        var speed:Double = 3
        
        speed = speed - 0.1
        
        if (lastYieldTimeIntervalRock > 1){
            
            lastYieldTimeIntervalRock = 0
            setupRock("rock_1", score: 1)
        }
        
        if (lastYieldTimeIntervalStar > 0.0001){
            
            lastYieldTimeIntervalStar = 0
            setupStar(kind: "star", minDuration: 2, maxDuration: 6, duration: 20)
        }
        
        if (lastYieldTimeIntervalAurora > 5){
            
            lastYieldTimeIntervalAurora = 0
            setupAurora()
        }
        
        if (lastYieldTimeIntervalYellowStar > 1){
            
            lastYieldTimeIntervalYellowStar = 0
            setupStar(kind: "yellowStar", minDuration: 8, maxDuration: 10, duration: 40)
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let action = SKAction.moveTo(x: xAcceleration, duration: 1)
        let actionJetLeft = SKAction.moveTo(x: xAcceleration-10, duration: 1)
        let actionJetRight = SKAction.moveTo(x: xAcceleration+10, duration: 1)

        self.player.run(action)
        
        self.fireLeft.run(actionJetLeft)
        self.fireRight.run(actionJetRight)
        
        var timeSinceLastUpdate = currentTime - lastUpdateTimerIntervalRock
        
        lastUpdateTimerIntervalRock = currentTime
        
        if (timeSinceLastUpdate > 1){
            
            timeSinceLastUpdate = 1/60
            lastUpdateTimerIntervalRock = currentTime
        }
        
        updateWithTimeSinceLastUpdate(timeSinceLastUpdate)
        
    }
    
    func scoreLabelUpdate(_ newscore:Int){
        
        scoreLabel.text = "\(newscore)"

        newscore > 25 && newscore < 50 ? setupRock("rock_1", score: newscore) : nil
        newscore > 50 ? setupRock("rock_2", score: newscore) : nil
        newscore > 200 ? setupRock("rock_3", score: newscore) : nil
    }
    
    func getKindShip() -> Int {
        
        let playerChoosedShip = alreadyExist(key: "ship")
        
        !playerChoosedShip ? UserDefaults.standard.set(0, forKey: "ship") : nil
        
        return UserDefaults.standard.object(forKey: "ship")! as! Int
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        var spriteShot:String = ""
        var actionArray = [SKAction]()

        self.getKindShip() == 0 ? (spriteShot = "shot") : (spriteShot = "shot2")
        
        let shot:SKSpriteNode = SKSpriteNode(imageNamed: spriteShot)
        let location = CGPoint(x: player.position.x, y:player.position.y+500)
        let offset:CGPoint = vecSub(location, b: shot.position)
        let direction:CGPoint = vecNormalize(offset)
        let shotLength:CGPoint = vecMult(direction, b: 300)
        let finalDestination:CGPoint = vecAdd(shotLength, b: shot.position)
        let velocity = 200/1
        let moveDuration:Float = Float(self.size.width) / Float(velocity)
        let soundIsOn = UserDefaults.standard.bool(forKey: "soundStatus")
        
        soundIsOn ? self.run(SKAction.playSoundFileNamed("Shot", waitForCompletion: false)) : nil
        
        shot.position = player.position
        shot.physicsBody = SKPhysicsBody(circleOfRadius: shot.size.width/2)
        shot.physicsBody!.isDynamic = false
        shot.physicsBody!.categoryBitMask = CollisionCategories.shotCategory
        shot.physicsBody!.contactTestBitMask = CollisionCategories.rockCategory
        shot.physicsBody!.collisionBitMask = 0
        shot.physicsBody!.usesPreciseCollisionDetection = true
        shot.zPosition = 3

        if (offset.y < 0){ return }
        
        self.addChild(shot)

        actionArray.append(SKAction.move(to: finalDestination, duration: TimeInterval(moveDuration)))
        actionArray.append(SKAction.removeFromParent())
        
        shot.run(SKAction.sequence(actionArray))
        
    }

    func didBegin(_ contact: SKPhysicsContact){

        let firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        var thirdBody:SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
            thirdBody = contact.bodyB
            
        } else {
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            thirdBody = contact.bodyB
            
        }

        if (firstBody.categoryBitMask & CollisionCategories.shotCategory) != 0 && (secondBody.categoryBitMask & CollisionCategories.rockCategory) != 0 {
            firstBody.node != nil && secondBody.node != nil ?
                shotDidCollideWithRock(shot: firstBody.node as! SKSpriteNode, rock: secondBody.node as! SKSpriteNode) : nil
        }
        
        if (player.position.x == firstBody.node!.position.x) || (player.position.y == firstBody.node!.position.y) || (player.position.x == thirdBody.node!.position.x) || (player.position.y == thirdBody.node!.position.y) {
            
            setupExplosion(x: player.position.x, y: player.position.y)
        
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            
            let score = scoreLabel.text
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene:SKScene = GameOverScene(size: self.size, won: false, score: score!)
            
            self.view!.presentScene(gameOverScene, transition: transition)
            
        }
        
        if(scoreLabel.text == "99999"){
            
            let score = scoreLabel.text
            let transition:SKTransition = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene:SKScene = GameOverScene(size: self.size, won: true, score: score!)
            
            self.view!.presentScene(gameOverScene, transition: transition)
        }
    }
    
    func shotDidCollideWithRock(shot:SKSpriteNode, rock:SKSpriteNode){

        rock.removeFromParent()
        rocksDestroyed += 1
        scoreLabelUpdate(rocksDestroyed)
    }
    
    func vecAdd(_ a:CGPoint, b:CGPoint)->CGPoint{
        return CGPoint(x: a.x + b.x, y: a.y + b.y)
    }
    
    func vecSub(_ a:CGPoint, b:CGPoint)->CGPoint{
        return CGPoint(x: a.x - b.x, y: a.y - b.y)
    }
    
    func vecMult(_ a:CGPoint, b:CGFloat)->CGPoint{
        return CGPoint(x: a.x * b, y: a.y * b)
    }
    
    func vecLength(_ a:CGPoint)->CGFloat{
        return CGFloat(sqrtf(CFloat(a.x)*CFloat(a.x)+CFloat(a.y)*CFloat(a.y)))
    }
    
    func vecNormalize(_ a:CGPoint)->CGPoint{
        let length:CGFloat = vecLength(a)
        return CGPoint(x: a.x / length, y: a.y / length)
    }
    
}
