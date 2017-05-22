//
//  Tile.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

enum Colors: Int {
    case blue = 0, red, green, yellow, purple, orange
}

class Tile {
    let column: Int
    let row: Int
    let sprite: SKSpriteNode
    let color: Colors
    
    init(column: Int, row: Int, sprite: SKSpriteNode, color: Colors) {
        self.column = column
        self.row = row
        self.sprite = sprite
        self.color = color
    }
}
