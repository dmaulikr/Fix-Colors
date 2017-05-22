//
//  CompletionNode.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol CompletionNodeDelegate {
    func continueButtonTouched()
}

class CompletionNode: SKNode {
    
    var delegate: CompletionNodeDelegate?
    private let settings: Settings
    
    private let completionLabel = SKLabelNode(fontNamed: MainFont)
    private let levelLabel = SKLabelNode(fontNamed: MainFont)
    private let movesLabel = SKLabelNode(fontNamed: MainFont)
    private let bestMovesLabel = SKLabelNode(fontNamed: MainFont)
    private let continueButton = SKSpriteNode(imageNamed: SpriteNames.PlayButtonName)
    
    init(settings: Settings) {
        self.settings = settings
        super.init()
        isUserInteractionEnabled = false
        
        completionLabel.text = Titles.CompletedTitle
        completionLabel.fontSize = 46.0
        completionLabel.fontColor = GoldenColor
        completionLabel.setShadow()
        completionLabel.alpha = 0.0
        completionLabel.xScale = 0.0
        completionLabel.yScale = 0.0
        completionLabel.position = CGPoint(x: 0.0, y: 0.0)
        addChild(completionLabel)
        
        continueButton.alpha = 0.0
        continueButton.xScale = 0.0
        continueButton.yScale = 0.0
        continueButton.position = CGPoint(x: 0.0, y: -MainSize.height * 0.25)
        addChild(continueButton)
    }
    
    func animate(scaleFactor: CGFloat, alpha: CGFloat, completion: @escaping () -> ()) {
        let scaleAction = SKAction.scale(to: scaleFactor, duration: 0.3)
        scaleAction.timingMode = .easeInEaseOut
        let fadeAction = SKAction.fadeAlpha(to: alpha, duration: 0.3)
        fadeAction.timingMode = .easeIn
        let groupAction = SKAction.group([scaleAction, fadeAction])
        completionLabel.run(groupAction, completion: completion)
        continueButton.run(groupAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if continueButton.contains(location) {
                isUserInteractionEnabled = false
                Actions.buttonIsTouched(continueButton as SKNode, sound: settings.sound, completion: {
                    self.animate(scaleFactor: 0.0, alpha: 0.0, completion: {
                        self.delegate?.continueButtonTouched()
                    })
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
