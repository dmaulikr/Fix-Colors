//
//  Oval.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

class Oval {
    var column: Int
    var row: Int
    let sprite: SKSpriteNode
    let color: Colors
    var aboveRightTile: Bool? {
        didSet {
            if let right = aboveRightTile {
                if right {
                    let waitAction = Actions.waitAction(duration: 0.4)
                    let scaleAction = Actions.scaleOval(scaleFactor: self.sprite.xScale)
                    let seq = SKAction.sequence([waitAction, scaleAction])
                    self.sprite.run(seq, withKey: ActionNames.BlinkOvalName)
                } else {
                    removeOvalsActions()
                }
            }
        }
    }
    init(column: Int, row: Int, sprite: SKSpriteNode, color: Colors) {
        self.column = column
        self.row = row
        self.sprite = sprite
        self.color = color
    }
    
    func removeOvalsActions() {
        self.sprite.removeAction(forKey: ActionNames.BlinkOvalName)
        self.sprite.xScale = 1.0
        self.sprite.yScale = 1.0
    }
}
