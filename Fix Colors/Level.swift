//
//  Level.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

struct PreloadOvals {
    private static let blueOval = SKTexture(imageNamed: SpriteNames.BlueOvalName)
    private static let redOval = SKTexture(imageNamed: SpriteNames.RedOvalName)
    private static let greenOval = SKTexture(imageNamed: SpriteNames.GreenOvalName)
    private static let yellowOval = SKTexture(imageNamed: SpriteNames.YellowOvalName)
    private static let purpleOval = SKTexture(imageNamed: SpriteNames.PurpleOvalName)
    private static let orangeOval = SKTexture(imageNamed: SpriteNames.OrangeOvalName)
    
    private static let ovalArray = [blueOval, redOval, greenOval, yellowOval, purpleOval, orangeOval]
    
    static func getOval(c: Colors) -> SKTexture {
        return ovalArray[c.rawValue]
    }
}

struct PreloadTiles {
    private static let blueTile = SKTexture(imageNamed: SpriteNames.BlueTileName)
    private static let redTile = SKTexture(imageNamed: SpriteNames.RedTileName)
    private static let greenTile = SKTexture(imageNamed: SpriteNames.GreenTileName)
    private static let yellowTile = SKTexture(imageNamed: SpriteNames.YellowTileName)
    private static let purpleTile = SKTexture(imageNamed: SpriteNames.PurpleTileName)
    private static let orangeTile = SKTexture(imageNamed: SpriteNames.OrangeTileName)
    
    private static let tileArray = [blueTile, redTile, greenTile, yellowTile, purpleTile, orangeTile]
    
    static func getTile(c: Colors) -> SKTexture {
        return tileArray[c.rawValue]
    }
}

struct PreloadDirs {
    private static let right = SKTexture(imageNamed: SpriteNames.RightName)
    private static let left = SKTexture(imageNamed: SpriteNames.LeftName)
    
    static func getDir(d: Directions) -> SKTexture {
        return d == .Left ? left : right
    }
}

class Level {
    static let DocumentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentDirectory.appendingPathComponent("level")
    
    private var tilesArray: [[Int]]?
    private var ovalsArray: [[Int]]?
    private var directions: [[Int]]?
    
    private var addedTiles = [Tile]()
    private var addedOvals = [Oval]()
    private var addedDirs = [Direction]()
    
    private var tileWidth: CGFloat?
    private var columns: Int?
    private var rows: Int?
    
    private func load(levelName: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONfromBundle(filename: levelName) else { return }
        columns = dictionary["columns"] as? Int
        rows = dictionary["rows"] as? Int
        tilesArray = dictionary["tiles"] as? [[Int]]
        ovalsArray = dictionary["ovals"] as? [[Int]]
        directions = dictionary["directions"] as? [[Int]]
    }
    
    private func makeTiles() {
        for (row, rowTiles) in tilesArray!.enumerated() {
            for (column, color) in rowTiles.enumerated() {
                if let tileColor = Colors(rawValue: color) {
                    if let ovalColor = Colors(rawValue: ovalsArray![row][column]) {
                        let tileSprite = SKSpriteNode(texture: PreloadTiles.getTile(c: tileColor))
                        tileSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        let tile = Tile(column: column, row: row, sprite: tileSprite, color: tileColor)
                        tileWidth = tile.sprite.frame.size.width
                        
                        tile.sprite.position = pointForC(column, r: row, tWidth: tile.sprite.frame.size.width)
                        
                        let ovalSprite = SKSpriteNode(texture: PreloadOvals.getOval(c: ovalColor))
                        let oval = Oval(column: column, row: row, sprite: ovalSprite, color: ovalColor)
                        oval.sprite.zPosition = 15.0
                        oval.sprite.position = tile.sprite.position
                        
                        addedTiles.append(tile)
                        addedOvals.append(oval)
                    }
                }
            }
        }
    }
    
    private func pointForC(_ c: Int, r: Int, tWidth: CGFloat) -> CGPoint {
        let x = CGFloat(c) * (tWidth + Treshold) + (tWidth + Treshold) / 2.0
        let y = CGFloat(r) * (tWidth + Treshold) + (tWidth + Treshold) / 2.0
        return CGPoint(x: x, y: y)
    }
    
    private func makeDirections() {
        if let width = tileWidth {
            for (row, rowDir) in directions!.enumerated() {
                for (column, direction) in rowDir.enumerated() {
                    if let d = Directions(rawValue: direction) {
                        let x = CGFloat(column) * (width + Treshold) + width + Treshold
                        let y = CGFloat(row) * (width + Treshold) + width + Treshold
                        
                        let sprite = SKSpriteNode(texture: PreloadDirs.getDir(d: d))
                        sprite.position = CGPoint(x: x, y: y)
                        sprite.zPosition = 20.0
                        
                        let dir = Direction(directions: direction == 0 ? .Left : .Right, sprite: sprite)
                        addedDirs.append(dir)
                    }
                }
            }
        }
    }
    
    private func changeAddedOval(_ oval: Oval, index: Int) {
        addedOvals[index] = oval
        if addedOvals[index].color == addedTiles[index].color {
            addedOvals[index].aboveRightTile = true
        } else {
            addedOvals[index].aboveRightTile = false
        }
    }
    
    func loadLevelFile(levelName: String) {
        load(levelName: levelName)
    }
    
    func setupGrid() {
        makeTiles()
        makeDirections()
    }
    
    func changeOval(_ oval: Oval, index: Int) {
        changeAddedOval(oval, index: index)
    }
    
    func get() -> (tiles: [Tile], ovals: [Oval], dirs: [Direction]) {
        return (addedTiles, addedOvals, addedDirs)
    }
    
    func getColumnsAndRows() -> (Int, Int) {
        return (columns!, rows!)
    }
    
    func getWidth() -> CGFloat {
        return tileWidth!
    }
    
    func clean() {
        tilesArray = nil
        ovalsArray = nil
        directions = nil
        columns = nil
        rows = nil
        tileWidth = nil
        addedTiles.removeAll()
        addedOvals.removeAll()
        addedDirs.removeAll()
    }
}
