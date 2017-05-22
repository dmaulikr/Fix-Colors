//
//  LevelSprite.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

class LevelSprite: SKNode {
    private let levelLabel: SKLabelNode = SKLabelNode(fontNamed: MainFont)
    
    init(level: Int) {
        super.init()
        if let levelSprite = makeSprite(level: level) {
            levelSprite.zPosition = 60.0
            levelSprite.position = CGPoint(x: 0.0, y: 0.0)
            addChild(levelSprite)
        }
        
        levelLabel.text = "\(level)"
        levelLabel.fontSize = 28.0
        levelLabel.fontColor = FontColor
        levelLabel.setShadow()
        levelLabel.zPosition = 80.0
        levelLabel.position = CGPoint(x: 0.0, y: 0.0)
        addChild(levelLabel)
    }
    
    private func makeSprite(level: Int) -> SKSpriteNode? {
        if (level <= 20) {
            return SKSpriteNode(imageNamed: "LEVEL_SPRITE_BLUE")
        } else if (level >= 21 && level <= 40) {
            return SKSpriteNode(imageNamed: "LEVEL_SPRITE_RED")
        } else if (level >= 41 && level <= 60) {
            return SKSpriteNode(imageNamed: "LEVEL_SPRITE_GREEN")
        } else if (level >= 61 && level <= 80) {
            return SKSpriteNode(imageNamed: "LEVEL_SPRITE_YELLOW")
        } else if (level >= 81 && level <= 100) {
            return SKSpriteNode(imageNamed: "LEVEL_SPRITE_PURPLE")
        } else if (level >= 101) {
            return SKSpriteNode(imageNamed: "LEVEL_SPRITE_BROWN")
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
