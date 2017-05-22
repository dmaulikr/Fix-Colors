//
//  HUDNode.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol HUDNodeDelegate {
    func pauseNodeTouched()
    func replayButtonTouched()
    func touchesEnabled()
}

class HUDNode: SKNode {
    var delegate: HUDNodeDelegate?
    private let settings: Settings
    private let LabelTreshold: CGFloat = 6.0
    private let HUDHight: CGFloat = (MainSize.height * 0.5 - MainSize.height * 0.44) * 2.0
    
    private let pauseButton = SKSpriteNode(imageNamed: SpriteNames.PauseButtonName)
    private let replayButton = SKSpriteNode(imageNamed: SpriteNames.ReplayButtonName)
    private let levelLabel = SKLabelNode(fontNamed: MainFont)
    private let movesLabel = SKLabelNode(fontNamed: MainFont)
    private let bestMovesLabel = SKLabelNode(fontNamed: MainFont)
    
    init(settings: Settings) {
        self.settings = settings
        super.init()
        pauseButton.position = CGPoint(x: -MainSize.width * 0.4, y: 0.0)
        addChild(pauseButton)
        
        replayButton.position = CGPoint(x: MainSize.width * 0.4, y: 0.0)
        addChild(replayButton)
        
        updateLabelTexts()
        setupLevelLabel()
        setupMovesLabel()
        setupBestMovesLabel()
    }
    
    private func setupLevelLabel() {
        levelLabel.fontColor = FontColor
        levelLabel.fontSize = 18.0
        levelLabel.setShadow()
        levelLabel.position = CGPoint(x: 0.0, y: HUDHight * 0.28)
        addChild(levelLabel)
    }
    
    private func setupMovesLabel() {
        movesLabel.fontColor = MovesColor
        movesLabel.fontSize = 18.0
        movesLabel.setShadow()
        movesLabel.position = CGPoint(x: 0.0, y: 0.0)
        addChild(movesLabel)
    }
    
    private func setupBestMovesLabel() {
        bestMovesLabel.fontColor = GoldenColor
        bestMovesLabel.fontSize = 18.0
        bestMovesLabel.setShadow()
        bestMovesLabel.position = CGPoint(x: 0.0, y: -HUDHight * 0.28)
        addChild(bestMovesLabel)
    }
    
    func updateLabelTexts() {
        levelLabel.text = "LEVEL: \(settings.level)"
        movesLabel.text = "MOVES: \(settings.moves)"
        bestMovesLabel.text = "BEST: \(settings.returnBestMoves())"
        levelLabel.updateShadowNode()
        movesLabel.updateShadowNode()
        bestMovesLabel.updateShadowNode()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if pauseButton.contains(location) {
                delegate?.touchesEnabled()
                isUserInteractionEnabled = false
                Actions.buttonIsTouched(pauseButton as SKNode, sound: settings.sound, completion: {
                    self.delegate?.pauseNodeTouched()
                })
            }
            if replayButton.contains(location) {
                delegate?.touchesEnabled()
                isUserInteractionEnabled = false
                Actions.buttonIsTouched(replayButton as SKNode, sound: settings.sound, completion: {
                    self.delegate?.replayButtonTouched()
                    self.isUserInteractionEnabled = true
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
