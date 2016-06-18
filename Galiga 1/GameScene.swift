//
//  GameScene.swift
//  Galiga 1
//
//  Created by Rodrigo Ferreira on 06/06/16.
//  Copyright (c) 2016 Rodrigo Ferreira. All rights reserved.
//

import SpriteKit
import AVFoundation


struct PhysicsCatagory {
    static let Player: UInt32 = 1 //00000000000000000000000000000011
    static let Enemy1: UInt32 = 50 //00000000000000000000000000000001
    static let Enemy2: UInt32 = 51
    static let Lazor: UInt32 = 30
    static let Blast: UInt32 = 31
    static let Beam: UInt32 = 32
    static let Bullet: UInt32 = 20 //00000000000000000000000000000010
    static let WUp:UInt32 = 10
    static let PowerUpLazor: UInt32 = 11
    static let PowerUpBlast: UInt32 = 12
    static let PowerUpBeam: UInt32 = 13
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Score = Int()
    var Player = SKSpriteNode(imageNamed: "9-inc.png")
    var Jet = SKSpriteNode(imageNamed: "9-inc jet4.png")
    var JetR = SKSpriteNode(imageNamed: "9-inc jetR.png")
    var JetL = SKSpriteNode(imageNamed: "9-inc jetL.png")
    var Lazor_head = SKSpriteNode(imageNamed: "Lazor_head1.png")
    var Lazor_beam = SKSpriteNode(imageNamed: "Lazor_beam1.png")
    var location: CGPoint = CGPointMake(0, 0)
    var pressed: Bool = false
    var gun_mode = 1
    //    var lazor_on_once = false
    var ScoreLabel = UILabel()
    var HighScore = Int()
    var beamTimer = 75
    var lazorTimer = 50
    var blastTimer = 45
    var count = 45
    var Timer: NSTimer!
    var TextureArray_LazorHead = [SKTexture]()
    var TextureArray_LazorBeam = [SKTexture]()
    //    var TextureArray_BeamFront = [SKTexture]()
    //    var TextureArray_BeamRear = [SKTexture]()
    var base_gun_mode = 1
    var beam_number = 1
    //    var lazorAnimated = SKSpriteNode()
    var audioPlayer: AVAudioPlayer!
    
    
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let path = NSBundle.mainBundle().pathForResource("gameSounds/Bauchamp_jucky.mp3", ofType:nil)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer = sound
            
            sound.volume = 0.65
            let seconds = 1.0//Time To Delay
            let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
            let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                sound.play()
            })
            sound.numberOfLoops = -1
        } catch {
            // couldn't load file :(
        }

        
        
        
        var TextureAtlas = SKTextureAtlas()
        TextureAtlas = SKTextureAtlas(named: "Lazor_head")
        
        for i in 1...TextureAtlas.textureNames.count{
            TextureArray_LazorHead.append(SKTexture(imageNamed: "Lazor_head\(i).png"))
            TextureArray_LazorBeam.append(SKTexture(imageNamed: "Lazor_beam\(i).png"))
        }
        
        
        //        TextureAtlas = SKTextureAtlas(named: "back_beam_front")
        //        for i in 1...TextureAtlas.textureNames.count{
        //            TextureArray_BeamFront.append(SKTexture(imageNamed: "back_beam_front\(i).png"))
        //            TextureArray_BeamRear.append(SKTexture(imageNamed: "back_beam_rear\(i).png"))
        //        }
        
        //        TextureAtlas = SKTextureAtlas(named: "Lazor_beam")
        ////        NSLog("\(TextureAtlas.textureNames.count)")
        //        for i in 1...TextureAtlas.textureNames.count{
        //            TextureArray_LazorBeam.append(SKTexture(imageNamed: "Lazor_beam\(i).png"))
        //        }
        
        
        
        
        let HighScoreDefault = NSUserDefaults.standardUserDefaults()
        if HighScoreDefault.valueForKey("HighScore") != nil {
            HighScore = HighScoreDefault.valueForKey("HighScore") as! NSInteger
        }else{
            HighScore = 0
        }
        
        physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.darkGrayColor()
        self.addChild(SKEmitterNode(fileNamed: "MagicParticle")!)
        
        Player.position = CGPointMake(self.size.width/2, self.size.height/6)
        Player.setScale(0.125)
        Jet.position = CGPointMake(self.size.width/2, self.size.height/6)
        JetR.position = CGPointMake(self.size.width + 100, self.size.height + 100)
        JetL.position = CGPointMake(self.size.width + 100, self.size.height + 100)
        Jet.setScale(0.125)
        JetR.setScale(0.125)
        JetL.setScale(0.125)
        Jet.position.y = Jet.position.y-10
        JetR.position.y = JetR.position.y-10
        JetL.position.y = JetL.position.y-10
        
        location = CGPointMake(self.size.width/2, self.size.height/6)
        
        
        //        if lazor_on == false{
        //        if gun_mode < 4 {
        _ = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(GameScene.ShowBullet), userInfo: nil, repeats: true)
        //        }else if gun_mode == 4{
        //            _ = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameScene.ShowBullet), userInfo: nil, repeats: true)
        //        }else if gun_mode == 5{
        //            _ = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(GameScene.ShowBullet), userInfo: nil, repeats: true)
        //        }
        //        }else if lazor_on == true{
        _ = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(GameScene.updadeCounterLazor), userInfo: nil, repeats: true)
        //            lazor_on_once=true
        //        }
        //        _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.ShowBlast), userInfo: nil, repeats: true)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(GameScene.ShowPowerUp), userInfo: nil, repeats: true)
        _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(GameScene.ShowWUp), userInfo: nil, repeats: true)
        _ = NSTimer.scheduledTimerWithTimeInterval(1.3, target: self, selector: #selector(GameScene.SpawnEnemy1), userInfo: nil, repeats: true)
        _ = NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: #selector(GameScene.SpawnEnemy2), userInfo: nil, repeats: true)
        
        
        Jet.zPosition = 1
        JetR.zPosition = 1
        JetR.zPosition = 1
        
        
        Lazor_head.setScale(0.5)
        Lazor_head.zPosition = 1
        Lazor_head.position = CGPointMake(self.size.width + 100, self.size.height+2000)
        Lazor_head.physicsBody = SKPhysicsBody(rectangleOfSize: Lazor_head.size)
        Lazor_head.physicsBody?.categoryBitMask = PhysicsCatagory.Lazor
        Lazor_head.physicsBody?.collisionBitMask = 0
        Lazor_head.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
        //        Lazor_head.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy2
        Lazor_head.physicsBody?.affectedByGravity = false
        Lazor_head.physicsBody?.dynamic = false
        self.addChild(Lazor_head)
        //        Lazor_beam.setScale(2.0)
        Lazor_beam.zPosition = 1
        Lazor_beam.position = CGPointMake(self.size.width + 100, self.size.height+2000)
        Lazor_beam.physicsBody = SKPhysicsBody(rectangleOfSize: Lazor_beam.size)
        Lazor_beam.physicsBody?.categoryBitMask = PhysicsCatagory.Lazor
        Lazor_beam.physicsBody?.collisionBitMask = 0
        Lazor_beam.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
        //        Lazor_beam.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy2
        Lazor_beam.physicsBody?.affectedByGravity = false
        Lazor_beam.physicsBody?.dynamic = false
        self.addChild(Lazor_beam)
        
        
        
        
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size)
        Player.physicsBody?.affectedByGravity = false
        Player.physicsBody?.categoryBitMask = PhysicsCatagory.Player
        Player.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2|PhysicsCatagory.PowerUpLazor
        Player.physicsBody?.collisionBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2|PhysicsCatagory.PowerUpLazor
        Player.physicsBody?.dynamic = false
        
        
        self.addChild(Jet)
        self.addChild(Player)
        self.addChild(JetR)
        self.addChild(JetL)
        
        
        
        ScoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        ScoreLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.3)
        ScoreLabel.textColor = UIColor.whiteColor()
        self.view?.addSubview(ScoreLabel)
        ScoreLabel.text = "Score: 0"
        
        
    }
    
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody = contact.bodyA
        let secondBody: SKPhysicsBody = contact.bodyB
        
        if firstBody.node as? SKSpriteNode != nil && secondBody.node as? SKSpriteNode != nil {
            if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy1) && (secondBody.categoryBitMask == PhysicsCatagory.Bullet)) || ((firstBody.categoryBitMask == PhysicsCatagory.Bullet) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy1)){
                if let enemy = firstBody.node as? EnemyClass{
                    collisionWithBullet(enemy, Bullet: secondBody.node as! SKSpriteNode, points: 1)
                }else{
                    collisionWithBullet((secondBody.node as! EnemyClass), Bullet: firstBody.node as! SKSpriteNode, points: 1)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy2) && (secondBody.categoryBitMask == PhysicsCatagory.Bullet)) || ((firstBody.categoryBitMask == PhysicsCatagory.Bullet) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy2)){
                if let enemy = firstBody.node as? EnemyClass{
                    collisionWithBullet(enemy, Bullet: secondBody.node as! SKSpriteNode, points: 5)
                }else{
                    collisionWithBullet(secondBody.node as! EnemyClass, Bullet: firstBody.node as! SKSpriteNode, points: 5)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy1) && (secondBody.categoryBitMask == PhysicsCatagory.Player)) || ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy1)){
                collisionWithPlayer(firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy2) && (secondBody.categoryBitMask == PhysicsCatagory.Player)) || ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy2)){
                collisionWithPlayer(firstBody.node as! SKSpriteNode, Player: secondBody.node as! SKSpriteNode)
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy1) && (secondBody.categoryBitMask == PhysicsCatagory.Lazor)) || ((firstBody.categoryBitMask == PhysicsCatagory.Lazor) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy1)){
                if firstBody.categoryBitMask == PhysicsCatagory.Enemy1{
                    collisionWithLazor(firstBody.node as! EnemyClass, points: 1)
                }else{
                    collisionWithLazor(secondBody.node as! EnemyClass, points: 1)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy2) && (secondBody.categoryBitMask == PhysicsCatagory.Lazor)) || ((firstBody.categoryBitMask == PhysicsCatagory.Lazor) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy2)){
                if firstBody.categoryBitMask == PhysicsCatagory.Enemy2{
                    collisionWithLazor(firstBody.node as! EnemyClass, points: 5)
                }else{
                    collisionWithLazor(secondBody.node as! EnemyClass, points: 5)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy1) && (secondBody.categoryBitMask == PhysicsCatagory.Blast)) || ((firstBody.categoryBitMask == PhysicsCatagory.Blast) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy1)){
                if firstBody.categoryBitMask == PhysicsCatagory.Enemy1{
                    collisionWithBlast(firstBody.node as! SKSpriteNode, points: 1)
                }else{
                    collisionWithBlast(secondBody.node as! SKSpriteNode, points: 1)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Enemy2) && (secondBody.categoryBitMask == PhysicsCatagory.Blast)) || ((firstBody.categoryBitMask == PhysicsCatagory.Blast) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy2)){
                if firstBody.categoryBitMask == PhysicsCatagory.Enemy2{
                    collisionWithBlast(firstBody.node as! SKSpriteNode, points: 5)
                }else{
                    collisionWithBlast(secondBody.node as! SKSpriteNode, points: 5)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.PowerUpLazor) && (secondBody.categoryBitMask == PhysicsCatagory.Player)) || ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.PowerUpLazor)){
                if firstBody.categoryBitMask == PhysicsCatagory.PowerUpLazor{
                    collisionWithPowerUpLazor(firstBody.node as! SKSpriteNode, points: 20)
                }else {
                    collisionWithPowerUpLazor(secondBody.node as! SKSpriteNode, points: 20)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.PowerUpBlast) && (secondBody.categoryBitMask == PhysicsCatagory.Player)) || ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.PowerUpBlast)){
                if firstBody.categoryBitMask == PhysicsCatagory.PowerUpBlast{
                    collisionWithPowerUpBlast(firstBody.node as! SKSpriteNode, points: 20)
                }else {
                    collisionWithPowerUpBlast(secondBody.node as! SKSpriteNode, points: 20)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.PowerUpBeam) && (secondBody.categoryBitMask == PhysicsCatagory.Player)) || ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.PowerUpBeam)){
                if firstBody.categoryBitMask == PhysicsCatagory.PowerUpBeam{
                    collisionWithPowerUpBeam(firstBody.node as! SKSpriteNode, points: 20)
                }else {
                    collisionWithPowerUpBeam(secondBody.node as! SKSpriteNode, points: 20)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.WUp) && (secondBody.categoryBitMask == PhysicsCatagory.Player)) || ((firstBody.categoryBitMask == PhysicsCatagory.Player) && (secondBody.categoryBitMask == PhysicsCatagory.WUp)){
                if firstBody.categoryBitMask == PhysicsCatagory.PowerUpLazor{
                    collisionWithWUp(firstBody.node as! SKSpriteNode, points: 20)
                }else {
                    collisionWithWUp(secondBody.node as! SKSpriteNode, points: 20)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Beam) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy1)) || ((firstBody.categoryBitMask == PhysicsCatagory.Enemy1) && (secondBody.categoryBitMask == PhysicsCatagory.Beam)){
                if firstBody.categoryBitMask == PhysicsCatagory.Enemy1{
                    collisionWithBeam(firstBody.node as! EnemyClass,Beam: secondBody.node as! SKSpriteNode, points: 1)
                }else {
                    collisionWithBeam(secondBody.node as! EnemyClass,Beam: firstBody.node as! SKSpriteNode, points: 1)
                }
            }else if ((firstBody.categoryBitMask == PhysicsCatagory.Beam) && (secondBody.categoryBitMask == PhysicsCatagory.Enemy2)) || ((firstBody.categoryBitMask == PhysicsCatagory.Enemy2) && (secondBody.categoryBitMask == PhysicsCatagory.Beam)){
                if firstBody.categoryBitMask == PhysicsCatagory.Enemy2{
                    collisionWithBeam(firstBody.node as! EnemyClass,Beam: secondBody.node as! SKSpriteNode, points: 5)
                }else {
                    collisionWithBeam(secondBody.node as! EnemyClass,Beam: firstBody.node as! SKSpriteNode, points: 5)
                }
            }
        }
    }
    
    func collisionWithBullet(Enemy: EnemyClass, Bullet: SKSpriteNode, points: Int){
        Bullet.removeFromParent()
        
        if Enemy.decreaseHealth(1){
            Score += points
            ScoreLabel.text = "Score: \(Score)"
        }
    }
    
    func collisionWithBeam (Enemy: EnemyClass,Beam: SKSpriteNode, points: Int){
        if Enemy.decreaseHealth(1){
            Enemy.removeFromParent()
            Score += points
            ScoreLabel.text = "Score: \(Score)"
        }else{
            Beam.removeFromParent()
        }
        
    }
    
    func collisionWithLazor(Enemy: EnemyClass, points: Int){
        Enemy.removeFromParent()
        Score += points
        ScoreLabel.text = "Score: \(Score)"
    }
    
    func collisionWithBlast(Enemy: SKSpriteNode, points: Int){
        Enemy.removeFromParent()
        Score += points
        ScoreLabel.text = "Score: \(Score)"
    }
    
    func collisionWithPowerUpLazor(PowerUp: SKSpriteNode, points: Int){
        Lazor_head.runAction(SKAction.animateWithTextures(TextureArray_LazorHead, timePerFrame: 0.05))
        Lazor_beam.runAction(SKAction.animateWithTextures(TextureArray_LazorBeam, timePerFrame: 0.05))
        PowerUp.removeFromParent()
        Score += points
        ScoreLabel.text="Score: \(Score)"
        gun_mode = 22
        
    }
    func collisionWithPowerUpBlast(PowerUp: SKSpriteNode, points: Int){
        PowerUp.removeFromParent()
        Score += points
        ScoreLabel.text="Score: \(Score)"
        gun_mode = 21
        
        
    }
    
    func collisionWithPowerUpBeam(PowerUp: SKSpriteNode, points: Int){
        PowerUp.removeFromParent()
        Score += points
        ScoreLabel.text="Score: \(Score)"
        gun_mode = 23
    }
    
    func collisionWithWUp(WUp: SKSpriteNode, points: Int){
        WUp.removeFromParent()
        Score += points
        ScoreLabel.text="Score: \(Score)"
        if base_gun_mode < 3{
            base_gun_mode += 1
            //            if base_gun_mode < 4{
            //                TimerBullets.invalidate()
            //                TimerBullets = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(GameScene.ShowBullet), userInfo: nil, repeats: true)
            //            }
            //            else if base_gun_mode == 4{
            //                TimerBullets.invalidate()
            //                TimerBullets = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(GameScene.ShowBullet), userInfo: nil, repeats: true)
            //            }else if base_gun_mode == 5{
            //                TimerBullets.invalidate()
            //                TimerBullets = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(GameScene.ShowBullet), userInfo: nil, repeats: true)
            //            }
        }
        if gun_mode < 4{
            gun_mode = base_gun_mode
        }
        
        
    }
    
    func collisionWithPlayer(Enemy: SKSpriteNode, Player: SKSpriteNode){
        
        let ScoreDefault = NSUserDefaults.standardUserDefaults()
        ScoreDefault.setValue(Score, forKey: "Score")
        ScoreDefault.synchronize()
        
        if Score > HighScore{
            let HighScoreDefault = NSUserDefaults.standardUserDefaults()
            HighScoreDefault.setValue(Score, forKey: "HighScore")
            HighScoreDefault.synchronize()
        }
        
        Enemy.removeFromParent()
        Player.removeFromParent()
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
        }
        //        self.removeAllChildren()
        self.view?.presentScene(EndScene())
        ScoreLabel.removeFromSuperview()
        
        
    }
    
    
    
    func updadeCounterLazor(){
        if lazorTimer > 0 && gun_mode == 22{
            lazorTimer -= 1
        }else if blastTimer > 0 && gun_mode == 21{
            blastTimer -= 1
            if blastTimer == (count - 1){
                Timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(GameScene.ShowBlast), userInfo: nil, repeats: true)
            }
        }else if beamTimer > 0 && gun_mode == 23{
            if beamTimer == 75 {
                Timer = NSTimer.scheduledTimerWithTimeInterval(0.125, target: self, selector: #selector(GameScene.ShowBeam), userInfo: nil, repeats: true)
            }
            beamTimer -= 1
        }else{
            gun_mode = base_gun_mode
            if Timer != nil{
                Timer.invalidate()
            }
            beamTimer = 75
            lazorTimer = 50
            blastTimer = 45
            count = 45
        }
        
        
        //        if lazorTimer > 0 {
        //            lazorTimer -= 1
        //        }else{
        //            lazor_on=false
        //        lazorTimer = 5
        //        }
    }
    
    func SpawnEnemy1(){
        let Enemy = EnemyClass(imageNamed: "Enemy1.png")
        Enemy.health = 1
        Enemy.setScale(0.1)
        let MinValue = self.size.width / 3.2
        let MaxValue = 2.2*self.size.width / 3.2
        let SpawnPoint = UInt32(MaxValue - MinValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint) + UInt32(self.size.width/3.2)), y: self.size.height)
        
        let action = SKAction.moveToY(-70, duration: 3.0)
        let actionDone = SKAction.removeFromParent()
        Enemy.runAction(SKAction.sequence([action, actionDone]))
        Enemy.zPosition=2
        
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCatagory.Enemy1
        Enemy.physicsBody?.collisionBitMask = 0
        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.Player|PhysicsCatagory.Bullet|PhysicsCatagory.Lazor
        //        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.Lazor
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        
        self.addChild(Enemy)
    }
    
    func SpawnEnemy2(){
        let Enemy = EnemyClass(imageNamed: "Enemy2.png")
        Enemy.health = 10
        Enemy.setScale(0.2)
        let MinValue = self.size.width / 3.2
        let MaxValue = 2.2*self.size.width / 3.2
        let SpawnPoint = UInt32(MaxValue - MinValue)
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint) + UInt32(self.size.width/3.2)), y: self.size.height)
        
        let action = SKAction.moveToY(-70, duration: 10.0)
        let actionDone = SKAction.removeFromParent()
        Enemy.runAction(SKAction.sequence([action, actionDone]))
        Enemy.zPosition=2
        
        Enemy.physicsBody = SKPhysicsBody(rectangleOfSize: Enemy.size)
        Enemy.physicsBody?.categoryBitMask = PhysicsCatagory.Enemy2
        Enemy.physicsBody?.collisionBitMask = 0
        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.Player|PhysicsCatagory.Bullet|PhysicsCatagory.Lazor
        //        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.Lazor
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        
        self.addChild(Enemy)
    }
    
    
    func ShowWUp(){
        let PowerUp = SKSpriteNode(imageNamed: "WUp.png")
        PowerUp.setScale(0.15)
        let MinValue = self.size.width / 3.2
        let MaxValue = 2.2*self.size.width / 3.2
        let SpawnPoint = UInt32(MaxValue - MinValue)
        PowerUp.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint) + UInt32(self.size.width/3.2)), y: self.size.height)
        
        let action = SKAction.moveToY(-70, duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        PowerUp.runAction(SKAction.sequence([action, actionDone]))
        PowerUp.zPosition=2
        
        PowerUp.physicsBody = SKPhysicsBody(rectangleOfSize: PowerUp.size)
        PowerUp.physicsBody?.categoryBitMask = PhysicsCatagory.WUp
        PowerUp.physicsBody?.collisionBitMask = 0
        PowerUp.physicsBody?.contactTestBitMask = PhysicsCatagory.Player
        PowerUp.physicsBody?.affectedByGravity = false
        PowerUp.physicsBody?.dynamic = true
        self.addChild(PowerUp)
    }
    
    
    func ShowPowerUp(){
                let Power = Int(arc4random_uniform(3))
                if Power == 0 {
                    let PowerUp = SKSpriteNode(imageNamed: "PowerUpLazor.png")
                    PowerUp.setScale(0.15)
                    let MinValue = self.size.width / 3.2
                    let MaxValue = 2.2*self.size.width / 3.2
                    let SpawnPoint = UInt32(MaxValue - MinValue)
                    PowerUp.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint) + UInt32(self.size.width/3.2)), y: self.size.height)
        
                    let action = SKAction.moveToY(-70, duration: 4.0)
                    let actionDone = SKAction.removeFromParent()
                    PowerUp.runAction(SKAction.sequence([action, actionDone]))
                    PowerUp.zPosition=2
        
                    PowerUp.physicsBody = SKPhysicsBody(rectangleOfSize: PowerUp.size)
                    PowerUp.physicsBody?.categoryBitMask = PhysicsCatagory.PowerUpLazor
                    PowerUp.physicsBody?.collisionBitMask = 0
                    PowerUp.physicsBody?.contactTestBitMask = PhysicsCatagory.Player
                    PowerUp.physicsBody?.affectedByGravity = false
                    PowerUp.physicsBody?.dynamic = true
        
                    self.addChild(PowerUp)
                }else if Power == 1{
                    let PowerUp = SKSpriteNode(imageNamed: "PowerUpBlast.png")
                    PowerUp.setScale(0.15)
                    let MinValue = self.size.width / 3.2
                    let MaxValue = 2.2*self.size.width / 3.2
                    let SpawnPoint = UInt32(MaxValue - MinValue)
                    PowerUp.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint) + UInt32(self.size.width/3.2)), y: self.size.height)
        
                    let action = SKAction.moveToY(-70, duration: 4.0)
                    let actionDone = SKAction.removeFromParent()
                    PowerUp.runAction(SKAction.sequence([action, actionDone]))
                    PowerUp.zPosition=2
        
                    PowerUp.physicsBody = SKPhysicsBody(rectangleOfSize: PowerUp.size)
                    PowerUp.physicsBody?.categoryBitMask = PhysicsCatagory.PowerUpBlast
                    PowerUp.physicsBody?.collisionBitMask = 0
                    PowerUp.physicsBody?.contactTestBitMask = PhysicsCatagory.Player
                    PowerUp.physicsBody?.affectedByGravity = false
                    PowerUp.physicsBody?.dynamic = true
        
                    self.addChild(PowerUp)
                }else if Power == 2{
        let PowerUp = SKSpriteNode(imageNamed: "PowerUpBeam.png")
        PowerUp.setScale(0.15)
        let MinValue = self.size.width / 3.2
        let MaxValue = 2.2*self.size.width / 3.2
        let SpawnPoint = UInt32(MaxValue - MinValue)
        PowerUp.position = CGPoint(x: CGFloat(arc4random_uniform(SpawnPoint) + UInt32(self.size.width/3.2)), y: self.size.height)
        
        let action = SKAction.moveToY(-70, duration: 4.0)
        let actionDone = SKAction.removeFromParent()
        PowerUp.runAction(SKAction.sequence([action, actionDone]))
        PowerUp.zPosition=2
        
        PowerUp.physicsBody = SKPhysicsBody(rectangleOfSize: PowerUp.size)
        PowerUp.physicsBody?.categoryBitMask = PhysicsCatagory.PowerUpBeam
        PowerUp.physicsBody?.collisionBitMask = 0
        PowerUp.physicsBody?.contactTestBitMask = PhysicsCatagory.Player
        PowerUp.physicsBody?.affectedByGravity = false
        PowerUp.physicsBody?.dynamic = true
        
        self.addChild(PowerUp)
                }
        
    }
    
    func ShowBullet(){
        
        
        if gun_mode == 1 {
            let Bullet = SKSpriteNode(imageNamed: "bullet.png")
            Bullet.setScale(0.5)
            Bullet.zPosition = -5
            Bullet.position = CGPointMake(Player.position.x, Player.position.y+40)
            
            let action = SKAction.moveToY(self.size.height + 300, duration: 0.8)
            let actionDone = SKAction.removeFromParent()
            Bullet.runAction(SKAction.sequence([action, actionDone]))
            
            Bullet.physicsBody = SKPhysicsBody(rectangleOfSize: Bullet.size)
            Bullet.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
            Bullet.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            Bullet.physicsBody?.collisionBitMask = 0
            Bullet.physicsBody?.affectedByGravity = false
            Bullet.physicsBody?.dynamic = false
            
            if pressed == true{
                self.addChild(Bullet)
            }
        }else if gun_mode == 2{
            let BulletR = SKSpriteNode(imageNamed: "bullet.png")
            BulletR.setScale(0.5)
            BulletR.zPosition = -5
            BulletR.position = CGPointMake(Player.position.x + 5, Player.position.y+40)
            let BulletL = SKSpriteNode(imageNamed: "bullet.png")
            BulletL.setScale(0.5)
            BulletL.zPosition = -5
            BulletL.position = CGPointMake(Player.position.x - 5, Player.position.y+40)
            
            let action = SKAction.moveToY(self.size.height + 300, duration: 0.8)
            let actionDone = SKAction.removeFromParent()
            BulletR.runAction(SKAction.sequence([action, actionDone]))
            BulletL.runAction(SKAction.sequence([action, actionDone]))
            
            BulletR.physicsBody = SKPhysicsBody(rectangleOfSize: BulletR.size)
            BulletR.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
            BulletR.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            BulletR.physicsBody?.collisionBitMask = 0
            BulletR.physicsBody?.affectedByGravity = false
            BulletR.physicsBody?.dynamic = false
            BulletL.physicsBody = SKPhysicsBody(rectangleOfSize: BulletL.size)
            BulletL.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
            BulletL.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            BulletL.physicsBody?.collisionBitMask = 0
            BulletL.physicsBody?.affectedByGravity = false
            BulletL.physicsBody?.dynamic = false
            if pressed == true{
                self.addChild(BulletR)
                self.addChild(BulletL)
            }
            
        }else if gun_mode == 3{
            let BulletR = SKSpriteNode(imageNamed: "bullet.png")
            BulletR.setScale(0.5)
            BulletR.zPosition = -5
            BulletR.position = CGPointMake(Player.position.x + 5, Player.position.y+40)
            let BulletL = SKSpriteNode(imageNamed: "bullet.png")
            BulletL.setScale(0.5)
            BulletL.zPosition = -5
            BulletL.position = CGPointMake(Player.position.x - 5, Player.position.y+40)
            
            let action = SKAction.moveToY(self.size.height + 300, duration: 0.8)
            let actionDone = SKAction.removeFromParent()
            BulletR.runAction(SKAction.sequence([action, actionDone]))
            BulletL.runAction(SKAction.sequence([action, actionDone]))
            
            BulletR.physicsBody = SKPhysicsBody(rectangleOfSize: BulletR.size)
            BulletR.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
            BulletR.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            BulletR.physicsBody?.collisionBitMask = 0
            BulletR.physicsBody?.affectedByGravity = false
            BulletR.physicsBody?.dynamic = false
            BulletL.physicsBody = SKPhysicsBody(rectangleOfSize: BulletL.size)
            BulletL.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
            BulletL.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            BulletL.physicsBody?.collisionBitMask = 0
            BulletL.physicsBody?.affectedByGravity = false
            BulletL.physicsBody?.dynamic = false
            
            let BulletRS = SKSpriteNode(imageNamed: "bullet.png")
            BulletRS.setScale(0.5)
            BulletRS.zRotation = -0.7853981634
            BulletRS.zPosition = -5
            BulletRS.position = CGPointMake(Player.position.x + 5, Player.position.y+35)
            let BulletLS = SKSpriteNode(imageNamed: "bullet.png")
            BulletLS.setScale(0.5)
            BulletLS.zRotation = 0.7853981634
            BulletLS.zPosition = -5
            BulletLS.position = CGPointMake(Player.position.x - 5, Player.position.y+35)
            
            
            let action1 = SKAction.moveTo(CGPointMake(Player.position.x + 1000, Player.position.y + 1620), duration: 1.2)
            let action2 = SKAction.moveTo(CGPointMake(Player.position.x - 1000, Player.position.y + 1620), duration: 1.2)
            //            let actionDone = SKAction.removeFromParent()
            BulletRS.runAction(SKAction.sequence([action1, actionDone]))
            BulletLS.runAction(SKAction.sequence([action2, actionDone]))
            
            BulletRS.physicsBody = SKPhysicsBody(rectangleOfSize: BulletRS.size)
            BulletRS.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
            BulletRS.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            BulletRS.physicsBody?.collisionBitMask = 0
            BulletRS.physicsBody?.affectedByGravity = false
            BulletRS.physicsBody?.dynamic = false
            BulletLS.physicsBody = SKPhysicsBody(rectangleOfSize: BulletLS.size)
            BulletLS.physicsBody?.categoryBitMask = PhysicsCatagory.Bullet
            BulletLS.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            BulletLS.physicsBody?.collisionBitMask = 0
            BulletLS.physicsBody?.affectedByGravity = false
            BulletLS.physicsBody?.dynamic = false
            if pressed == true{
                self.addChild(BulletRS)
                self.addChild(BulletLS)
                self.addChild(BulletR)
                self.addChild(BulletL)
            }
            
            
            
        }else if gun_mode == 4{
            
            
        }else if gun_mode == 5{
            
            
        }
        //self.addChild(Bullet)
        
    }
    
    func ShowBlast(){
        if gun_mode == 21 {
            let Blaster = SKSpriteNode(imageNamed: "BlastBullet.png")
            let Blast = SKSpriteNode(imageNamed: "Lazor_ring.png")
            let Blast2 = SKSpriteNode(imageNamed: "Lazor_ring.png")
            let Blast3 = SKSpriteNode(imageNamed: "Lazor_ring.png")
            Blast.setScale(0.3)
            Blast.zPosition = 2
            Blast.position = CGPointMake(Player.position.x, Player.position.y + 40)
            Blast2.setScale(0.1)
            Blast2.zPosition = 2
            Blast2.position = CGPointMake(Player.position.x, Player.position.y + 50)
            Blast3.setScale(0.05)
            Blast3.zPosition = 2
            Blast3.position = CGPointMake(Player.position.x, Player.position.y + 60)
            Blaster.setScale(0.5)
            Blaster.zPosition = -5
            Blaster.position = CGPointMake(Player.position.x, Player.position.y + 40)
            
            var action_b = Array<SKAction>()
            action_b.append(SKAction.sequence([SKAction.scaleTo(1.0, duration: 0.4), SKAction.removeFromParent()]))
            action_b.append(SKAction.fadeAlphaTo(0.0, duration: 0.4))
            action_b.append(SKAction.moveToY(Player.position.y + 60, duration: 0.4))
            var action_c = Array<SKAction>()
            action_c.append(SKAction.sequence([SKAction.scaleTo(0.7, duration: 0.4), SKAction.removeFromParent()]))
            action_c.append(SKAction.fadeAlphaTo(0.0, duration: 0.4))
            action_c.append(SKAction.moveToY(Player.position.y + 90, duration: 0.4))
            var action_d = Array<SKAction>()
            action_d.append(SKAction.sequence([SKAction.scaleTo(0.4, duration: 0.4), SKAction.removeFromParent()]))
            action_d.append(SKAction.fadeAlphaTo(0.0, duration: 0.4))
            action_d.append(SKAction.moveToY(Player.position.y + 130, duration: 0.4))
            
            var group = SKAction.group(action_b)
            //                SKAction.scaleTo(1.0, duration: 0.4)
            //            let action_c = SKAction.fadeAlphaTo(0.0, duration: 0.4)
            //            scaleBy(0.05, duration: 0.8)
            let action = SKAction.moveToY(self.size.height + 300, duration: 0.8)
            let actionDone = SKAction.removeFromParent()
            Blaster.runAction(SKAction.sequence([action, actionDone]))
            Blast.runAction(group)
            group = SKAction.group(action_c)
            Blast2.runAction(group)
            group = SKAction.group(action_d)
            Blast3.runAction(group)
            
            
            Blaster.physicsBody = SKPhysicsBody(rectangleOfSize: Blaster.size)
            Blaster.physicsBody?.categoryBitMask = PhysicsCatagory.Blast
            Blaster.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
            Blaster.physicsBody?.collisionBitMask = 0
            Blaster.physicsBody?.affectedByGravity = false
            Blaster.physicsBody?.dynamic = false
            
            
            self.addChild(Blast)
            self.addChild(Blast2)
            self.addChild(Blast3)
            self.addChild(Blaster)
            
        }
    }
    
    func ShowBeam(){
        if gun_mode == 23{
            
            
            if beam_number == 1{
                drawBeam(-2.8797932658, iden: 1)
                beam_number += 1
            }else if beam_number == 4{
                drawBeam(-2.3561944902, iden: 2)
                beam_number += 1
            }else if beam_number == 2{
                drawBeam(2.3561944902, iden: 2)
                beam_number += 1
            }else if beam_number == 3{
                drawBeam(0.0, iden: 0)
                beam_number += 1
            }else{
                drawBeam(2.8797932658, iden: 1)
                beam_number = 1
            }
        }
    }
    
    func drawBeam(angle: Float, iden:Int){
        
        var TextureArray_BeamFront = [SKTexture]()
        var TextureArray_BeamRear = [SKTexture]()
        var TextureAtlas = SKTextureAtlas()
        TextureAtlas = SKTextureAtlas(named: "Lazor_head")
        
        
        
        
        
        let BeamBack = SKSpriteNode(imageNamed: "back_beam_rear_right1.png")
        let BeamFront = SKSpriteNode(imageNamed: "back_beam_front_right1.png")
        BeamBack.setScale(0.4)
        BeamBack.zPosition = 4
        BeamFront.setScale(0.4)
        BeamFront.zPosition = 5
        
        
        
        
        
        BeamBack.physicsBody = SKPhysicsBody(rectangleOfSize: BeamBack.size)
        BeamBack.physicsBody?.categoryBitMask = PhysicsCatagory.Beam
        BeamBack.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
        BeamBack.physicsBody?.collisionBitMask = 0
        BeamBack.physicsBody?.affectedByGravity = false
        BeamBack.physicsBody?.dynamic = false
        BeamFront.physicsBody = SKPhysicsBody(rectangleOfSize: BeamFront.size)
        BeamFront.physicsBody?.categoryBitMask = PhysicsCatagory.Beam
        BeamFront.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy1|PhysicsCatagory.Enemy2
        BeamFront.physicsBody?.collisionBitMask = 0
        BeamFront.physicsBody?.affectedByGravity = false
        BeamFront.physicsBody?.dynamic = false
        
        BeamBack.zRotation = CGFloat(angle)
        
        if iden==0{
            
            TextureAtlas = SKTextureAtlas(named: "back_beam_front_right")
            for i in 1...TextureAtlas.textureNames.count{
                TextureArray_BeamFront.append(SKTexture(imageNamed: "back_beam_front_right\(i).png"))
                TextureArray_BeamRear.append(SKTexture(imageNamed: "back_beam_rear_right\(i).png"))
            }
            
            BeamBack.position = CGPointMake(Player.position.x, Player.position.y - 39)
            BeamFront.position = CGPointMake(Player.position.x, Player.position.y - 16)
        }else if iden==1{
            if angle<0{
                TextureAtlas = SKTextureAtlas(named: "back_beam_front_right")
                for i in 1...TextureAtlas.textureNames.count{
                    TextureArray_BeamFront.append(SKTexture(imageNamed: "back_beam_front_right\(i).png"))
                    TextureArray_BeamRear.append(SKTexture(imageNamed: "back_beam_rear_right\(i).png"))
                }
                BeamBack.position = CGPointMake(Player.position.x + 12, Player.position.y - 39)
                BeamFront.position = CGPointMake(Player.position.x + 18, Player.position.y - 16)
            }else{
                TextureAtlas = SKTextureAtlas(named: "back_beam_front_left")
                for i in 1...TextureAtlas.textureNames.count{
                    TextureArray_BeamFront.append(SKTexture(imageNamed: "back_beam_front_left\(i).png"))
                    TextureArray_BeamRear.append(SKTexture(imageNamed: "back_beam_rear_left\(i).png"))
                }
                BeamBack.position = CGPointMake(Player.position.x - 12, Player.position.y - 39)
                BeamFront.position = CGPointMake(Player.position.x - 18, Player.position.y - 16)
            }
        }else if iden==2{
            BeamBack.setScale(0.6)
            if angle<0{
                TextureAtlas = SKTextureAtlas(named: "back_beam_front_right")
                for i in 1...TextureAtlas.textureNames.count{
                    TextureArray_BeamFront.append(SKTexture(imageNamed: "back_beam_front_right\(i).png"))
                    TextureArray_BeamRear.append(SKTexture(imageNamed: "back_beam_rear_right\(i).png"))
                }
                BeamBack.setScale(0.6)
                BeamBack.position = CGPointMake(Player.position.x + 23, Player.position.y - 37)
                BeamFront.position = CGPointMake(Player.position.x + 37, Player.position.y - 10)
            }else{
                TextureAtlas = SKTextureAtlas(named: "back_beam_front_left")
                for i in 1...TextureAtlas.textureNames.count{
                    TextureArray_BeamFront.append(SKTexture(imageNamed: "back_beam_front_left\(i).png"))
                    TextureArray_BeamRear.append(SKTexture(imageNamed: "back_beam_rear_left\(i).png"))
                }
                BeamBack.position = CGPointMake(Player.position.x - 23, Player.position.y - 37)
                BeamFront.position = CGPointMake(Player.position.x - 37, Player.position.y - 10)
            }
        }
        let action2 = SKAction.moveToY(self.size.height + 300, duration: 0.6)
        let action1 = SKAction.waitForDuration(0.1)
        
        var action1_front = Array<SKAction>()
        action1_front.append(SKAction.sequence([SKAction.animateWithTextures(TextureArray_BeamFront, timePerFrame: 0.01), action2, SKAction.removeFromParent()]))
        action1_front.append(action1)
        var group_sequence = SKAction.group(action1_front)
        //        let action3 = SKAction.animateWithTextures(TextureArray_BeamFront, timePerFrame: 0.01)
        //        let actionDone = SKAction.removeFromParent()
        BeamFront.runAction(group_sequence)
        var action1_rear = Array<SKAction>()
        action1_rear.append(SKAction.sequence([SKAction.animateWithTextures(TextureArray_BeamRear, timePerFrame: 0.01), action2, SKAction.removeFromParent()]))
        action1_rear.append(action1)
        group_sequence = SKAction.group(action1_rear)
        BeamBack.runAction(group_sequence)
        self.addChild(BeamBack)
        self.addChild(BeamFront)
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        pressed=true
        for touch in touches {
            location = touch.locationInNode(self)
            
            
            
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pressed=false
    }
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            location = touch.locationInNode(self)
            
            
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //        NSLog("\(lazor_on)")
        Player.position.x = Player.position.x + (location.x - Player.position.x)/8
        Jet.position.x = Jet.position.x + (location.x - Jet.position.x)/8
        if location.y < 2*self.size.height/3{
            Player.position.y = Player.position.y + (location.y - Player.position.y)/8
            Jet.position.y = Jet.position.y + (location.y - Jet.position.y-10)/8
        }else{
            Player.position.y = Player.position.y + (2*self.size.height/3 - Player.position.y)/8
            Jet.position.y = Jet.position.y + (2*self.size.height/3 - Jet.position.y-10)/8
        }
        
        //        if lazorTimer <= 0{
        //            lazor_on=false
        //            lazorTimer = 5
        //        }
        
        if gun_mode == 22 {
            
            Lazor_head.position.x = Player.position.x
            Lazor_head.position.y = Player.position.y + 80
            Lazor_beam.position.x = Player.position.x
            Lazor_beam.position.y = Player.position.y + 626
        }else{
            Lazor_head.position.x = self.size.width + 100
            Lazor_head.position.y = self.size.height+2000
            Lazor_beam.position.x = self.size.width + 100
            Lazor_beam.position.y = self.size.height+2000
            //            Lazor_head.position = CGPointMake(self.size.width + 100, self.size.height+2000)
            //            Lazor_beam.position = CGPointMake(self.size.width + 100, self.size.height+2000)
        }
        
        
        if location.y - Jet.position.y >= 0{
            //            let tempora: CGPoint = Jet.position
            //            let JetTemp = SKSpriteNode(imageNamed: "9-inc jet4.png")
            Jet.texture = SKTexture(imageNamed: "9-inc jet4.png")
            //            Jet.setScale(0.2)
            //            Jet.position = tempora
        }else{
            //            let tempora: CGPoint = Jet.position
            Jet.texture = SKTexture(imageNamed: "9-inc jet3.png")
            //            Jet.setScale(0.2)
            //            Jet.position = tempora
        }
        if location.x - Jet.position.x > 5{
            JetR.position.x = Jet.position.x
            JetR.position.y = Jet.position.y
            JetL.position = CGPointMake(self.size.width + 100, self.size.height + 100)
        }else if location.x - Jet.position.x < -5{
            JetL.position.x = Jet.position.x
            JetL.position.y = Jet.position.y
            JetR.position = CGPointMake(self.size.width + 100, self.size.height + 100)
        }else{
            JetR.position = CGPointMake(self.size.width + 100, self.size.height + 100)
            JetL.position = CGPointMake(self.size.width + 100, self.size.height + 100)
        }
    }
}
