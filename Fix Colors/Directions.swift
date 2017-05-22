//
//  Directions.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

enum Directions: Int {
    case Left = 0, Right
}

class Direction {
    let directions: Directions
    let sprite: SKSpriteNode
    
    init(directions: Directions, sprite: SKSpriteNode) {
        self.directions = directions
        self.sprite = sprite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
