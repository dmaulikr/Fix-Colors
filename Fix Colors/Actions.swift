//
//  Actions.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

public struct Actions {
    static func buttonIsTouched(_ button: SKNode, sound: Bool, completion: @escaping () -> ()) {
        if button.hasActions() { return }
        if sound {
            GameAudio.shared.playButtonClickSound()
        }
        button.run(touchedButtonAction(scaleFactor: button.returnScaleFactor()), completion: completion)
    }
    
    static func touchedButtonAction(scaleFactor: CGFloat) -> SKAction {
        let actionOne = SKAction.fadeAlpha(to: 0.7, duration: 0.05)
        let actionTwo = SKAction.fadeAlpha(to: 1.0, duration: 0.05)
        let scaleOne = SKAction.scale(to: scaleFactor * 0.95, duration: 0.05)
        let scaleTwo = SKAction.scale(to: scaleFactor, duration: 0.05)
        scaleOne.timingMode = .easeIn
        scaleTwo.timingMode = .easeOut
        let groupOne = SKAction.group([actionOne, scaleOne])
        let groupTwo = SKAction.group([actionTwo, scaleTwo])
        return SKAction.sequence([groupOne, groupTwo])
    }
    
    static func waitAction(duration: TimeInterval) -> SKAction {
        return SKAction.wait(forDuration: duration)
    }
    
    static func removeSpriteAction(scaleFactor: CGFloat) -> SKAction {
        let action = SKAction.scale(to: scaleFactor * 1.1, duration: 0.2)
        action.timingMode = .easeIn
        let colorizeAction = SKAction.colorize(with: SKColor.white, colorBlendFactor: 1.0, duration: 0.2)
        colorizeAction.timingMode = .easeOut
        let group = SKAction.group([action, colorizeAction])
        let removeAction = SKAction.removeFromParent()
        return SKAction.sequence([group, removeAction])
    }
    
    static func moveOvalAction(position: CGPoint, scaleFactor: CGFloat) -> SKAction {
        let action = SKAction.move(to: position, duration: 0.3)
        let scaleOne = SKAction.scale(to: scaleFactor * 0.6, duration: 0.05)
        let waitAction = SKAction.wait(forDuration: 0.2)
        let scaleTwo = SKAction.scale(to: scaleFactor, duration: 0.05)
        action.timingMode = .easeIn
        scaleOne.timingMode = .easeOut
        scaleTwo.timingMode = .easeIn
        let seq = SKAction.sequence([scaleOne, waitAction, scaleTwo])
        let group = SKAction.group([seq, action])
        return group
    }
    
    static func fadeOutAction(duration: TimeInterval) -> SKAction {
        let action = SKAction.fadeOut(withDuration: duration)
        action.timingMode = .easeIn
        return action
    }
    
    static func fadeInAction(duration: TimeInterval) -> SKAction {
        let action = SKAction.fadeIn(withDuration: duration)
        action.timingMode = .easeOut
        return action
    }
    
    static func moveNode(x: CGFloat, duration: TimeInterval) -> SKAction {
        let action = SKAction.moveTo(x: x, duration: duration)
        action.timingMode = .easeIn
        return action
    }
    
    static func scaleOval(scaleFactor: CGFloat) -> SKAction {
        let actionOne = SKAction.scale(to: scaleFactor * 1.1, duration: 0.3)
        let actionTwo = SKAction.scale(to: scaleFactor * 0.8, duration: 0.3)
        actionOne.timingMode = .easeIn
        actionTwo.timingMode = .easeOut
        let seq = SKAction.sequence([actionOne, actionTwo])
        let repeatForever = SKAction.repeatForever(seq)
        return repeatForever
    }
    
    static func removeGridAction() -> SKAction {
        let actionTwo = SKAction.moveTo(x: -MainSize.width * 1.5, duration: 0.25)
        actionTwo.timingMode = .easeIn
        return actionTwo
    }
    
    static func addGridAction(location: CGPoint) -> SKAction {
        let action = SKAction.move(to: location, duration: 0.4)
        action.timingMode = .easeOut
        return action
    }
}
