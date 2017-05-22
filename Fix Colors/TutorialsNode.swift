//
//  TutorialsNode.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol TutorialsNodeDelegate {
    func backToMenuScene()
}

class TutorialsNode: SKNode {
    var delegate: TutorialsNodeDelegate?
    let sound: Bool!
    
    private let backButton = SKSpriteNode(imageNamed: SpriteNames.BackButtonName)
    private let bgSprite = SKSpriteNode(texture: nil, color: SKColor.black, size: MainSize)
    
    private let tutorialsNode = SKNode()
    private var tilesArray: [[Int]] = [[0, 1, 2, 3],
                                       [2, 3, 0, 1]]
    private var ovalsArray: [[Int]] = [[2, 0, 0, 2],
                                       [3, 1, 1, 3]]
    private var directions: [[Int]] = [[1, 0, 1]]
    
    private var tiles = [Tile]()
    private var ovals = [Oval]()
    private var dirs = [Direction]()
    private var tileWidth: CGFloat?
    private let columns: Int = 4
    private let rows: Int = 2
    
    private let fadeDuration: TimeInterval = 0.4
    private let waitAction = Actions.waitAction(duration: 1.0)
    
    init(sound: Bool) {
        self.sound = sound
        super.init()
        
        let label = SKLabelNode(text: Titles.TutorialsTitle)
        label.fontName = MainFont
        label.fontColor = FontColor
        label.fontSize = 28.0
        label.setShadow()
        label.zPosition = 20.0
        label.position = CGPoint(x: 0.0, y: MainSize.height * 0.44)
        addChild(label)
        
        bgSprite.zPosition = 5.0
        bgSprite.alpha = 0.7
        bgSprite.position = CGPoint(x: 0.0, y: 0.0)
        addChild(bgSprite)
        
        setupBackButton()
        setupGrid()
        makeDirections()
        
        let x: CGFloat = -(tileWidth! + Treshold) * CGFloat(columns) / 2.0
        let y: CGFloat = -(tileWidth! + Treshold) * CGFloat(rows) / 2.0
        let position = CGPoint(x: x, y: y)
        tutorialsNode.alpha = 0.0
        tutorialsNode.position = position
        addChild(tutorialsNode)
        
        for d in self.dirs {
            d.sprite.zPosition = 10.0
            d.sprite.run(self.animateDirs(scale: d.sprite.xScale, times: 2))
        }
        let fadeIn = Actions.fadeInAction(duration: fadeDuration)
        tutorialsNode.run(fadeIn, completion: {
            self.animateFirstScene()
        })
    }
    
    private func setupBackButton() {
        backButton.zPosition = 10.0
        backButton.position = CGPoint(x: -MainSize.width * 0.4, y: -MainSize.height * 0.446)
        addChild(backButton)
    }
    
    private func setupGrid() {
        for (row, rowTiles) in tilesArray.enumerated() {
            for (column, color) in rowTiles.enumerated() {
                if let tileColor = Colors(rawValue: color) {
                    if let ovalColor = Colors(rawValue: ovalsArray[row][column]) {
                        let tileSprite = SKSpriteNode(texture: PreloadTiles.getTile(c: tileColor))
                        tileSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                        let tile = Tile(column: column, row: row, sprite: tileSprite, color: tileColor)
                        tile.sprite.zPosition = 1.0
                        tileWidth = tile.sprite.frame.size.width
                        
                        tile.sprite.position = pointForC(column, r: row, tWidth: tile.sprite.frame.size.width)
                        
                        let ovalSprite = SKSpriteNode(texture: PreloadOvals.getOval(c: ovalColor))
                        let oval = Oval(column: column, row: row, sprite: ovalSprite, color: ovalColor)
                        oval.sprite.zPosition = 1.0
                        oval.sprite.position = tile.sprite.position
                        
                        tiles.append(tile)
                        ovals.append(oval)
                        tutorialsNode.addChild(tile.sprite)
                        tutorialsNode.addChild(oval.sprite)
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
            for (row, rowDir) in directions.enumerated() {
                for (column, direction) in rowDir.enumerated() {
                    if let d = Directions(rawValue: direction) {
                        let sprite = SKSpriteNode(texture: PreloadDirs.getDir(d: d))
                        let dir = Direction(directions: direction == 0 ? .Left : .Right, sprite: sprite)
                        let x = CGFloat(column) * (width + Treshold) + width + Treshold
                        let y = CGFloat(row) * (width + Treshold) + width + Treshold
                        dir.sprite.position = CGPoint(x: x, y: y)
                        
                        dirs.append(dir)
                        tutorialsNode.addChild(dir.sprite)
                    }
                }
            }
        }
    }
    
    private func animateDirs(scale: CGFloat, times: Int) -> SKAction {
        let wait = SKAction.wait(forDuration: 0.4)
        
        let scaleOne = SKAction.scale(to: scale * 1.25, duration: 0.18)
        let scaleTwo = SKAction.scale(to: scale, duration: 0.18)
        
        scaleOne.timingMode = .easeIn
        scaleTwo.timingMode = .easeOut
        
        let scaleWaitAction = SKAction.wait(forDuration: 0.1)
        let scaleSeq = SKAction.sequence([scaleOne, scaleTwo, scaleWaitAction])
        let repeatAction = SKAction.repeat(scaleSeq, count: times)
        
        let seq = SKAction.sequence([wait, repeatAction])
        return seq
    }
    
    private func animateFirstScene() {
        let waitSceneAction = Actions.waitAction(duration: 2.0)
        let blockAction = SKAction.run {
            for (i, d) in self.dirs.enumerated() {
                d.sprite.removeAllActions()
                d.sprite.xScale = 1.0
                d.sprite.yScale = 1.0
                if (i == 1 || i == 2) { d.sprite.zPosition = 1.0 }
            }
            for (i, o) in self.ovals.enumerated() {
                if (i == 0 || i == 1 || i == 4 || i == 5) {
                    o.sprite.zPosition = 10.0
                }
            }
            for (i, t) in self.tiles.enumerated() {
                if (i == 0 || i == 1 || i == 4 || i == 5) {
                    t.sprite.zPosition = 10.0
                }
            }
            self.animateSecondScene()
        }
        run(waitSceneAction, completion: {
            self.run(blockAction)
        })
    }
    
    private func animateSecondScene() {
        let waitSceneAction = Actions.waitAction(duration: 2.0)
        let blinkDirsBlockAction = SKAction.run {
            self.dirs[0].sprite.run(self.animateDirs(scale: self.dirs[0].sprite.xScale, times: 1))
        }
        let waitAnimating = Actions.waitAction(duration: 1.5)
        let animateSpritesBlockAction = SKAction.run {
            self.moveRightWith(index: 0)
        }
        let runNextAnimation = SKAction.run {
            for (i, d) in self.dirs.enumerated() {
                if (i == 0 || i == 1) {
                    d.sprite.zPosition = 1.0
                } else {
                    d.sprite.zPosition = 10.0
                }
            }
            for (i, o) in self.ovals.enumerated() {
                if (i == 2 || i == 3 || i == 6 || i == 7) {
                    o.sprite.zPosition = 10.0
                } else {
                    o.sprite.zPosition = 1.0
                }
            }
            for (i, t) in self.tiles.enumerated() {
                if (i == 2 || i == 3 || i == 6 || i == 7) {
                    t.sprite.zPosition = 10.0
                } else {
                    t.sprite.zPosition = 1.0
                }
            }
            self.animateThirdScene()
        }
        let seq = SKAction.sequence([waitAction, blinkDirsBlockAction, waitAnimating, animateSpritesBlockAction, waitSceneAction])
        run(seq, completion: {
            self.run(runNextAnimation)
        })
    }
    
    private func animateThirdScene() {
        let waitSceneAction = Actions.waitAction(duration: 2.0)
        let blinkDirsBlockAction = SKAction.run {
            self.dirs[2].sprite.run(self.animateDirs(scale: self.dirs[2].sprite.xScale, times: 1))
        }
        let waitAnimating = Actions.waitAction(duration: 1.5)
        let blockAction = SKAction.run {
            self.moveRightWith(index: 2)
        }
        let seq = SKAction.sequence([waitAction, blinkDirsBlockAction, waitAnimating, blockAction, waitSceneAction])
        run(seq, completion: {
            self.bgSprite.run(Actions.fadeOutAction(duration: self.fadeDuration))
        })
    }
    
    private func back() {
        let waitAction = Actions.waitAction(duration: 3.0)
        let blockAction = SKAction.run {
            self.isUserInteractionEnabled = false
            self.delegate?.backToMenuScene()
        }
        let seq = SKAction.sequence([waitAction, blockAction])
        run(seq, withKey: ActionNames.BackActionName)
    }
    
    private func moveRightWith(index: Int) {
        GameAudio.shared.playSwishSound()
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
        
        changeAddedOval(firstOval, index: index + columns)
        changeAddedOval(secondOval, index: index)
        changeAddedOval(thirdOval, index: index + columns + 1)
        changeAddedOval(fourthOval, index: index + 1)
    }
    
    private func moveOval(_ oval: SKSpriteNode, position: CGPoint) {
        oval.run(Actions.moveOvalAction(position: position, scaleFactor: oval.returnScaleFactor()))
    }
    
    private func changeAddedOval(_ oval: Oval, index: Int) {
        ovals[index] = oval
        if ovals[index].color == tiles[index].color {
            ovals[index].aboveRightTile = true
        } else {
            ovals[index].aboveRightTile = false
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if backButton.contains(location) {
                if let _ = action(forKey: ActionNames.BackActionName) {
                    removeAction(forKey: ActionNames.BackActionName)
                }
                isUserInteractionEnabled = false
                removeAllActions()
                Actions.buttonIsTouched(backButton as SKNode, sound: sound, completion: {
                    self.delegate?.backToMenuScene()
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
