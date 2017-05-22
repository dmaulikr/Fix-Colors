//
//  LevelsNode.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol LevelsNodeDelegate {
    func playWithLevel(level: Int)
    func backButtonTouched()
}

class LevelsNode: SKNode {
    private let settings: Settings
    
    var delegate: LevelsNodeDelegate?
    
    private let levelLabel = SKLabelNode(fontNamed: MainFont)
    private let backButton = SKSpriteNode(imageNamed: SpriteNames.BackButtonName)
    private let MaxLevels: Int = 120
    private let RowCount: Int = 5
    private let ColumnCount: Int = 4
    private let Treshold: CGFloat = 6.0
    private let levelsGridNode = SKNode()
    private var levelsSprite = [SKNode]()
    private var nodes = [SKNode]()
    private var currentNode: Int = 1
    private var dots = [SKSpriteNode]()
    
    private var levelNumber: Int = 0
    
    init(settings: Settings) {
        self.settings = settings
        super.init()
        levelsGridNode.position = CGPoint(x: 0.0, y: 0.0)
        addChild(levelsGridNode)
        
        setupLevelLabel()
        setupBackButton()
        makeNodes()
        makeLevelGrids()
        makeSwipeDots()
    }
    
    private func setupLevelLabel() {
        levelLabel.text = Titles.LevelTitle
        levelLabel.fontColor = FontColor
        levelLabel.fontSize = 28.0
        levelLabel.setShadow()
        levelLabel.position = CGPoint(x: 0.0, y: MainSize.height * 0.446)
        addChild(levelLabel)
    }
    
    private func setupBackButton() {
        backButton.position = CGPoint(x: -MainSize.width * 0.4, y: -MainSize.height * 0.446)
        addChild(backButton)
    }
    
    private func makeNodes() {
        let numberOfNodes = Int(ceil(Double(MaxLevels) / (Double(ColumnCount) * Double(RowCount))))
        
        for i in 0..<numberOfNodes {
            let node = SKNode()
            let width = MainSize.width
            node.position = CGPoint(x: width * CGFloat(i), y: 0.0)
            nodes.append(node)
            levelsGridNode.addChild(node)
        }
    }
    
    private func makeLevelGrids() {
        let lastLevel = returnLastLevel()
        let sprite = SKSpriteNode(imageNamed: "LEVEL_SPRITE_BLUE")
        let width = sprite.frame.size.width
        for node in nodes {
            for i in 0..<RowCount {
                for k in 0..<ColumnCount {
                    levelNumber += 1
                    
                    let avail = levelsAvailability(levelNumber: levelNumber)
                    
                    let x = (width + Treshold) * CGFloat(ColumnCount) / 2.0 - (width + Treshold) / 2.0
                    let y = (width + Treshold) * CGFloat(RowCount) / 2.0 - (width + Treshold) / 2.0
                    
                    let levelSprite = LevelSprite(level: levelNumber)
                    
                    if !avail {
                        levelSprite.alpha = 0.4
                    } else {
                        levelSprite.alpha = 1.0
                    }
                    
                    if levelNumber == lastLevel + 1 {
                        levelSprite.alpha = 1.0
                    }
                    
                    if levelNumber == 1 {
                        levelSprite.alpha = 1.0
                    }
                    
                    levelSprite.position = CGPoint(x: -x + CGFloat(k) * (width + Treshold), y: y - CGFloat(i) * (width + Treshold))
                    
                    levelsSprite.append(levelSprite)
                    node.addChild(levelSprite)
                    
                    if levelNumber > MaxLevel {
                        if (levelNumber == 61 || levelNumber == 81 || levelNumber == 101) {
                            let label = makeComingSoonLabel()
                            node.addChild(label)
                        }
                    }
                }
            }
        }
    }
    
    private func makeComingSoonLabel() -> SKLabelNode {
        let label = SKLabelNode(text: Titles.ComingSoonTitle)
        label.fontName = MainFont
        label.fontColor = SKColor.black
        label.fontSize = 48.0
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zRotation = CGFloat(.pi / 4.0)
        label.zPosition = 100.0
        label.alpha = 0.5
        label.position = CGPoint(x: 0.0, y: 0.0)
        return label
    }
    
    private func levelsAvailability(levelNumber: Int) -> Bool {
        if levelNumber > MaxLevel { return false }
        let availableLevel = settings.returnCompletedLevels()
        for (level, completed) in availableLevel {
            if level == levelNumber {
                if completed {
                    return true
                }
                return false
            }
        }
        return false
    }
    
    private func returnLastLevel() -> Int {
        var lvl: Int = 0
        let completedLevels = settings.returnCompletedLevels()
        for (level, completed) in completedLevels {
            if level > lvl {
                if completed {
                    lvl = level
                }
            }
        }
        return lvl
    }
    
    private func makeSwipeDots() {
        let dotsTreshold:CGFloat = 6.0
        for i in 0..<nodes.count {
            let dot = SKSpriteNode(imageNamed: SpriteNames.DotSpriteName)
            dot.alpha = currentNode - 1 == i ? 0.8 : 0.3
            let width = dot.frame.size.width
            let x = (width + dotsTreshold) * CGFloat(nodes.count) / 2.0 - (width + dotsTreshold) / 2.0
            dot.position = CGPoint(x: -x + CGFloat(i) * (width + dotsTreshold), y: -MainSize.height * 0.44)
            
            dots.append(dot)
            addChild(dot)
        }
    }
    
    private func changeDots(old: Int, new: Int) {
        dots[old].alpha = 0.3
        dots[new].alpha = 0.8
    }
    
    private func chooseLevel(sprite: SKNode, level: Int) {
        Actions.buttonIsTouched(sprite, sound: settings.sound, completion: {
            self.delegate?.playWithLevel(level: level + 1)
        })
    }
    
    func swiped(direction: UISwipeGestureRecognizerDirection) {
        if levelsGridNode.hasActions() { return }
        let duration: TimeInterval = 0.2
        switch direction {
        case UISwipeGestureRecognizerDirection.left:
            if currentNode < nodes.count {
                let x = levelsGridNode.position.x - MainSize.width
                levelsGridNode.run(Actions.moveNode(x: x, duration: duration), completion: {
                    self.currentNode += 1
                    self.changeDots(old: self.currentNode - 2, new: self.currentNode - 1)
                    self.isUserInteractionEnabled = true
                })
            }
        case UISwipeGestureRecognizerDirection.right:
            if currentNode > 1 {
                let x = levelsGridNode.position.x + MainSize.width
                levelsGridNode.run(Actions.moveNode(x: x, duration: duration), completion: {
                    self.currentNode -= 1
                    self.changeDots(old: self.currentNode, new: self.currentNode - 1)
                    self.isUserInteractionEnabled = true
                })
            }
        default: break
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if backButton.contains(location) {
                Actions.buttonIsTouched(backButton as SKNode, sound: settings.sound, completion: {
                    self.isUserInteractionEnabled = false
                    self.delegate?.backButtonTouched()
                })
            } else {
                for (level, sprite) in levelsSprite.enumerated() {
                    if sprite.contains(location) {
                        if sprite.alpha > 0.9 {
                            if level + 1 <= MaxLevel {
                                switch currentNode {
                                case 1:
                                    if level + 1 >= 1 && level + 1 <= 20 {
                                        chooseLevel(sprite: sprite, level: level)
                                    }
                                case 2:
                                    if level + 1 >= 21 && level + 1 <= 40 {
                                        chooseLevel(sprite: sprite, level: level)
                                    }
                                case 3:
                                    if level + 1 >= 41 && level + 1 <= 60 {
                                        chooseLevel(sprite: sprite, level: level)
                                    }
                                case 4:
                                    if level + 1 >= 61 && level + 1 <= 80 {
                                        chooseLevel(sprite: sprite, level: level)
                                    }
                                case 5:
                                    if level + 1 >= 81 && level + 1 <= 100 {
                                        chooseLevel(sprite: sprite, level: level)
                                    }
                                case 6:
                                    if level + 1 >= 101 && level + 1 <= 120 {
                                        chooseLevel(sprite: sprite, level: level)
                                    }
                                default:
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
