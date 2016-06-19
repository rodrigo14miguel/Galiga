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
    
    func decreaseHealth(damage:Int) -> Bool{
        self.health -= damage
        self.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.04),SKAction.fadeInWithDuration(0.01)]))
        if self.health <= 0{
            if self.physicsBody?.categoryBitMask == PhysicsCatagory.Enemy2{
                self.physicsBody?.categoryBitMask = PhysicsCatagory.DeadBody
                let path1 = NSBundle.mainBundle().pathForResource("gameSounds/explosionFar2.wav", ofType:nil)!
                let url1 = NSURL(fileURLWithPath: path1)
                let path2 = NSBundle.mainBundle().pathForResource("gameSounds/engineDown1.wav", ofType:nil)!
                let url2 = NSURL(fileURLWithPath: path2)
                
                
                do {
                    
                    let sound1 = try AVAudioPlayer(contentsOfURL: url1)
                    let sound2 = try AVAudioPlayer(contentsOfURL: url2)

                    audioPlayer2 = sound1
                    audioPlayer3 = sound2
                    
                    sound1.play()
                    
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        sound2.volume = 0.5
                        sound2.play()
                    })
                    
                } catch {
                    // couldn't load file :(
                }
                self.removeAllActions()
                self.runAction(SKAction.fadeOutWithDuration(1.5))
                let dispatchTime1 = dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC)))
                
                dispatch_after(dispatchTime1, dispatch_get_main_queue(), {
                    self.removeFromParent()
                })
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
                self.runAction(SKAction.fadeOutWithDuration(0.5))
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    self.removeFromParent()
                })

            }
            //            self.lazorTimer.invalidate()
            return true
        }else{
            return false
        }
    }
    
    //    func lazorDamage_on(animationTimeLeft: Int) {
    //        if self.health > 0 && lazorContact == false {
    //            lazorContact = true
    //            lazorAnimationLeft = animationTimeLeft
    //            lazorTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(EnemyClass.blinkEnemy), userInfo: nil, repeats: true)
    //
    //        }
    //    }
    
    //    func lazorDamage_off(){
    //        self.lazorTimer.invalidate()
    //        lazorContact = false
    //        NSLog("INVALIDATE")
    //    }
    
    
    //    func blinkEnemy() {
    //        NSLog("\(self.health)")
    //        lazorAnimationLeft -= 2
    //        if self.decreaseHealth() == false  && lazorAnimationLeft >= 1{
    //        self.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.05),SKAction.fadeInWithDuration(0.01)]))
    //        }else{
    //            self.lazorTimer.invalidate()
    ////            let ScoreDefault = NSUserDefaults.standardUserDefaults()
    ////            var Score = ScoreDefault.valueForKey("Score") as! NSInteger
    ////            Score += Points
    //        }
    ////        if self.health <= 0{
    ////            self.lazorTimer.invalidate()
    ////            
    ////        }
    //    }
    
}
