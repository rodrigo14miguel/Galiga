//
//  EnemyClass.swift
//  Galiga 1
//
//  Created by Rodrigo Ferreira on 11/06/16.
//  Copyright © 2016 Rodrigo Ferreira. All rights reserved.
//

import SpriteKit
import AVFoundation

class EnemyClass: SKSpriteNode {
    var health: Int = 1
    var lazorContact: Bool = false
    var lazorTimer = NSTimer()
    var Points = 1
    var lazorAnimationLeft = Int()
    var audioPlayer1: AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    var audioPlayer3: AVAudioPlayer!
    var explosion = [SKTexture]()
    var enemy_explosion = SKSpriteNode()
    var timerTime = 3
    
    func decreaseHealth(damage:Int) -> Bool{
        self.health -= damage
        self.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.04),SKAction.fadeInWithDuration(0.01)]))
        if self.health <= 0{
            if self.physicsBody?.categoryBitMask == PhysicsCatagory.Enemy2{
                self.physicsBody?.categoryBitMask = PhysicsCatagory.DeadBody
                let path1 = NSBundle.mainBundle().pathForResource("gameSounds/explosionFar2.wav", ofType:nil)!
                let url1 = NSURL(fileURLWithPath: path1)
  
                do {
                    let sound1 = try AVAudioPlayer(contentsOfURL: url1)

                    audioPlayer2 = sound1
                    sound1.play()
                    _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(EnemyClass.playSoundEnemy2), userInfo: nil, repeats: false)
                    
                } catch {
                    // couldn't load file :(
                }
                self.removeAllActions()
                
                var TextureAtlas = SKTextureAtlas()
                TextureAtlas = SKTextureAtlas(named: "Enemy2_explosion")
                
                for i in 1...TextureAtlas.textureNames.count{
                    explosion.append(SKTexture(imageNamed: "Enemy2_explosion\(i).png"))
                }
                
                enemy_explosion = SKSpriteNode(imageNamed: "Enemy2_explosion1.png")
//                enemy_explosion.setScale(0.2)
                self.texture = SKTexture(imageNamed: "Enemy2_explosion1.png")
                self.size = CGSize(width: enemy_explosion.size.width, height: enemy_explosion.size.height)
                self.alpha = 1
                self.runAction(SKAction.animateWithTextures(explosion, timePerFrame: 0.037))
                
                _ = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(EnemyClass.deleteNodeTimer), userInfo: nil, repeats: true)
//                let dispatchTime1 = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
//                
//                dispatch_after(dispatchTime1, dispatch_get_main_queue(), {
//                    self.removeFromParent()
//                })
            }else if self.physicsBody?.categoryBitMask == PhysicsCatagory.Enemy1{
                self.physicsBody?.categoryBitMask = PhysicsCatagory.DeadBody
                let path1 = NSBundle.mainBundle().pathForResource("gameSounds/explosionFar1.wav", ofType:nil)!
                let url1 = NSURL(fileURLWithPath: path1)
                do {
                    let sound1 = try AVAudioPlayer(contentsOfURL: url1)
                    audioPlayer1 = sound1
                    
                    sound1.play()
                    
                } catch {
                    // couldn't load file :(
                }
                self.removeAllActions()
                
                var TextureAtlas = SKTextureAtlas()
                TextureAtlas = SKTextureAtlas(named: "Enemy1_explosion")
                
                for i in 1...TextureAtlas.textureNames.count{
                    explosion.append(SKTexture(imageNamed: "Enemy1_explosion\(i).png"))
                }
                
                enemy_explosion = SKSpriteNode(imageNamed: "Enemy1_explosion1.png")
//                enemy_explosion.setScale(0.1)
                self.texture = SKTexture(imageNamed: "Enemy1_explosion1.png")
                self.size = CGSize(width: enemy_explosion.size.width, height: enemy_explosion.size.height)
                self.runAction(SKAction.animateWithTextures(explosion, timePerFrame: 0.037))
                
                
                _ = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: #selector(EnemyClass.deleteNodeTimer), userInfo: nil, repeats: true)

            }
            return true
        }else{
            return false
        }
    }
    
    func playSoundEnemy2(){
        let path2 = NSBundle.mainBundle().pathForResource("gameSounds/engineDown1.wav", ofType:nil)!
        let url2 = NSURL(fileURLWithPath: path2)
        do{
        let sound2 = try AVAudioPlayer(contentsOfURL: url2)
        audioPlayer3 = sound2
            sound2.volume = 0.5
            sound2.play()
        } catch {
            // couldn't load file :(
        }
        
    }
    
    func deleteNodeTimer(){
        timerTime-=1
        if timerTime<=0{
            self.removeFromParent()
        }
    }
    
    
    
}
