//
//  EnemyClass.swift
//  Galiga 1
//
//  Created by Rodrigo Ferreira on 11/06/16.
//  Copyright © 2016 Rodrigo Ferreira. All rights reserved.
//

import SpriteKit

class EnemyClass: SKSpriteNode {
    var health: Int = 1
    var lazorContact: Bool = false
    var lazorTimer = NSTimer()
    var Points = 1
    var lazorAnimationLeft = Int()
    
    func decreaseHealth(damage:Int) -> Bool{
        self.health -= damage
        self.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(0.04),SKAction.fadeInWithDuration(0.01)]))
        if self.health <= 0{
            self.removeFromParent()
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
