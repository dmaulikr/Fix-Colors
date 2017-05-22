//
//  Grid.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol GridDelegate {
    func updateMovesLabel()
    func completionLevel()
    func disableHUD()
    func enableHUD()
}

class Grid: SKNode {
    var delegate: GridDelegate?
    let level: Level
    let settings: Settings
    
    let gridNode = SKNode()
    
    init(settings: Settings, level: Level, columns: Int, rows: Int, width: CGFloat) {
        self.settings = settings
        self.level = level
        super.init()
        let x: CGFloat = -(width + Treshold) * CGFloat(columns) / 2.0
        let y: CGFloat = -(width + Treshold) * CGFloat(rows) / 2.0
        let position = CGPoint(x: x + MainSize.width, y: y)
        gridNode.position = position
        addChild(gridNode)
    }
    
    func addSpritesToScene() {
        let (tiles, ovals, dirs) = level.get()
        checkColorsOf(tiles: tiles, ovals: ovals)
        
        for tile in tiles {
            gridNode.addChild(tile.sprite)
        }
        for oval in ovals {
            gridNode.addChild(oval.sprite)
        }
        for dir in dirs {
            gridNode.addChild(dir.sprite)
        }
        let location = CGPoint(x: gridNode.position.x - MainSize.width, y: gridNode.position.y)
        let waitAction = Actions.waitAction(duration: 0.7)
        let blockAction = SKAction.run {
            GameAudio.shared.playGridSwishSound()
        }
        let groupAction = settings.sound ?  SKAction.group([blockAction, Actions.addGridAction(location: location)]) : Actions.addGridAction(location: location)
        let seq = SKAction.sequence([waitAction, groupAction])
        gridNode.run(seq)
    }
    
    private func moveOval(_ oval: SKSpriteNode, position: CGPoint) {
        oval.run(Actions.moveOvalAction(position: position, scaleFactor: oval.returnScaleFactor()))
    }
    
    private func swipeOvals(_ ovals: [Oval], dirs: Directions, index: Int, completion: @escaping () -> ()) {
        let (columns, _) = level.getColumnsAndRows()
        let i = calcIndexWith(columns: columns, index: index)
        switch dirs {
        case .Left:
            moveLeftWith(ovals: ovals, columns: columns, index: i)
        case .Right:
            moveRightWith(ovals: ovals, columns: columns, index: i)
        }
        run(SKAction.wait(forDuration: 0.3), completion: completion)
    }
    
    private func moveLeftWith(ovals: [Oval], columns: Int, index: Int) {
        let firstOval = ovals[index]
        let secondOval = ovals[index + 1]
        let thirdOval = ovals[index + columns]
        let fourthOval = ovals[index + columns + 1]
        
        firstOval.removeOvalsActions()
        secondOval.removeOvalsActions()
        thirdOval.removeOvalsActions()
        fourthOval.removeOvalsActions()
        
        moveOval(firstOval.sprite, position: secondOval.sprite.position)
        moveOval(secondOval.sprite, position: fourthOval.sprite.position)
        moveOval(thirdOval.sprite, position: firstOval.sprite.position)
        moveOval(fourthOval.sprite, position: thirdOval.sprite.position)
        
        level.changeOval(firstOval, index: index + 1)
        level.changeOval(secondOval, index: index + columns + 1)
        level.changeOval(thirdOval, index: index)
        level.changeOval(fourthOval, index: index + columns)
    }
    
    private func moveRightWith(ovals: [Oval], columns: Int, index: Int) {
        let firstOval = ovals[index]
        let secondOval = ovals[index + 1]
        let thirdOval = ovals[index + columns]
        let fourthOval = ovals[index + columns + 1]
        
        firstOval.removeOvalsActions()
        secondOval.removeOvalsActions()
        thirdOval.removeOvalsActions()
        fourthOval.removeOvalsActions()
        
        moveOval(firstOval.sprite, position: thirdOval.sprite.position)
        moveOval(secondOval.sprite, position: firstOval.sprite.position)
        moveOval(thirdOval.sprite, position: fourthOval.sprite.position)
        moveOval(fourthOval.sprite, position: secondOval.sprite.position)
        
        level.changeOval(firstOval, index: index + columns)
        level.changeOval(secondOval, index: index)
        level.changeOval(thirdOval, index: index + columns + 1)
        level.changeOval(fourthOval, index: index + 1)
    }
    
    private func calcIndexWith(columns: Int, index: Int) -> Int {
        let times = columns - 1
        if index < times {
            return index
        }
        if index >= times && index < times * 2 {
            return index + 1
        } else if index >= times * 2 && index < times * 3 {
            return index + 2
        } else if index >= times * 3 && index < times * 4 {
            return index + 3
        } else if index >= times * 4 && index < times * 5 {
            return index + 4
        } else if index >= times * 5 && index < times * 6 {
            return index + 5
        }
        return index
    }
    
    private func checkForCompletionWith(tiles: [Tile], ovals: [Oval], dirs: [Direction]) -> Bool {
        var count = 0
        for oval in ovals {
            if let completed = oval.aboveRightTile {
                if completed {
                    count += 1
                }
            }
        }
        if count == ovals.count {
            completeLevelWith(tiles: tiles, ovals: ovals, dirs: dirs)
            return true
        }
        return false
    }
    
    private func checkColorsOf(tiles: [Tile], ovals: [Oval]) {
        if tiles.count != ovals.count { return }
        for i in 0..<ovals.count {
            if tiles[i].color == ovals[i].color {
                ovals[i].aboveRightTile = true
            } else {
                ovals[i].aboveRightTile = false
            }
        }
    }
    
    private func completeLevelWith(tiles: [Tile], ovals: [Oval], dirs: [Direction]) {
        settings.update()
        let waitAction = SKAction.wait(forDuration: 1.5)
        let blockAction = SKAction.run {
            let soundAction = SKAction.run {
                GameAudio.shared.playGridSwishSound()
            }
            let groupAction = self.settings.sound ? SKAction.group([soundAction, Actions.removeGridAction()]) : Actions.removeGridAction()
            self.gridNode.run(groupAction, completion: {
                self.gridNode.removeAllChildren()
                self.delegate?.completionLevel()
            })
        }
        let ovalBlockAction = SKAction.run {
            self.ovalActions(ovals, dirs: dirs)
        }
        let seq = SKAction.sequence([waitAction, blockAction])
        let groupAction = SKAction.group([ovalBlockAction, seq])
        run(groupAction)
    }
    
    private func ovalActions(_ ovals: [Oval], dirs: [Direction]) {
        for oval in ovals {
            oval.sprite.removeAction(forKey: ActionNames.BlinkOvalName)
            oval.removeOvalsActions()
        }
        
        for dir in dirs {
            let action = SKAction.scale(to: 0.0, duration: 0.3)
            action.timingMode = .easeIn
            
            dir.sprite.run(action)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let (tiles, ovals, dirs) = level.get()
        
        for touch in touches {
            let location = touch.location(in: self.gridNode)
            for (index, dir) in dirs.enumerated() {
                if dir.sprite.contains(location) {
                    if dir.sprite.hasActions() { return }
                    settings.moves += 1
                    delegate?.updateMovesLabel()
                    delegate?.disableHUD()
                    if settings.sound {
                        GameAudio.shared.playSwishSound()
                    }
                    swipeOvals(ovals, dirs: dir.directions, index: index, completion: {
                        if !self.checkForCompletionWith(tiles: tiles, ovals: ovals, dirs: dirs) {
                            self.delegate?.enableHUD()
                        }
                    })
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
