//
//  MenuSceneNode.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit

protocol MenuSceneNodeDelegate {
    func beginGame()
    func playWithLevel(lvl: Int)
    func removeGestures()
    func setupGestures()
    func share(completion: @escaping () -> ())
    func rate(completion: @escaping (Bool) -> Void)
    func disableUserInteraction()
    func enableUserInteraction()
}

enum MenuSceneNodeState {
    case MenuNode, LevelsNode, TutorialsNode
}

class MenuSceneNode: SKNode, LevelsNodeDelegate, MenuNodeDelegate, TutorialsNodeDelegate {
    var delegate: MenuSceneNodeDelegate?
    
    private let settings: Settings
    let menuNode: MenuNode
    var levelsNode: LevelsNode?
    var tutorialsNode: TutorialsNode?
    
    var state: MenuSceneNodeState = .MenuNode {
        didSet {
            switch state {
            case .MenuNode:
                delegate?.removeGestures()
            case .LevelsNode:
                delegate?.setupGestures()
            default: break
            }
            
            if oldValue == .TutorialsNode {
                removeTutorialsNode()
            } else if oldValue == .LevelsNode {
                removeLevelsNode()
            }
            
            changeNodes()
        }
    }
    
    init(settings: Settings) {
        self.settings = settings
        self.menuNode = MenuNode(settings: settings)
        super.init()
        
        menuNode.position = CGPoint(x: 0.0, y: 0.0)
        menuNode.isUserInteractionEnabled = true
        menuNode.delegate = self
        addChild(menuNode)
    }
    
    func makeLevelsNode() {
        levelsNode = LevelsNode(settings: settings)
        levelsNode!.position = CGPoint(x: 0.0, y: 0.0)
        levelsNode!.isUserInteractionEnabled = false
        levelsNode!.delegate = self
        levelsNode!.alpha = 0.0
        addChild(levelsNode!)
    }
    
    func makeTutorialsNode() {
        tutorialsNode = TutorialsNode(sound: settings.sound)
        tutorialsNode!.position = CGPoint(x: 0.0, y: 0.0)
        tutorialsNode!.isUserInteractionEnabled = false
        tutorialsNode!.delegate = self
        tutorialsNode?.alpha = 0.0
        addChild(tutorialsNode!)
    }
    
    func removeLevelsNode() {
        levelsNode?.removeAllChildren()
        levelsNode?.removeFromParent()
        levelsNode = nil
    }
    
    func removeTutorialsNode() {
        tutorialsNode?.removeAllChildren()
        tutorialsNode?.removeFromParent()
        tutorialsNode = nil
    }
    
    internal func backButtonTouched() {
        state = .MenuNode
    }
    
    internal func levelButtonTouched() {
        if levelsNode == nil { makeLevelsNode() }
        state = .LevelsNode
    }
    
    internal func tutButtonTouched() {
        if tutorialsNode == nil { makeTutorialsNode() }
        state = .TutorialsNode
    }
    
    internal func playWithLevel(level: Int) {
        isUserInteractionEnabled = false
        delegate?.removeGestures()
        delegate?.playWithLevel(lvl: level)
    }
    
    internal func playButtonTouched() {
        isUserInteractionEnabled = false
        delegate?.beginGame()
    }
    
    internal func shareButtonTouched() {
        isUserInteractionEnabled = false
        delegate?.share(completion: {
            self.isUserInteractionEnabled = true
        })
    }
    
    internal func rateUsButtonTouched() {
        isUserInteractionEnabled = false
        delegate?.rate(completion: { _ in
            self.isUserInteractionEnabled = true
        })
    }
    
    internal func backToMenuScene() {
        state = .MenuNode
    }
    
    internal func disableUserInteraction() {
        delegate?.disableUserInteraction()
    }
    
    internal func enableUserInteraction() {
        delegate?.enableUserInteraction()
    }
    
    private func changeNodesAction(alpha: CGFloat) -> SKAction {
        let action = SKAction.fadeAlpha(to: alpha, duration: 0.2)
        action.timingMode = .easeIn
        return action
    }
    
    private func changeNodes() {
        self.isUserInteractionEnabled = false
        switch state {
        case .MenuNode:
            tutorialsNode?.run(changeNodesAction(alpha: 0.0))
            levelsNode?.run(changeNodesAction(alpha: 0.0))
            menuNode.run(changeNodesAction(alpha: 1.0), completion:{
                self.isUserInteractionEnabled = true
            })
        case .LevelsNode:
            menuNode.run(changeNodesAction(alpha: 0.0))
            levelsNode!.run(changeNodesAction(alpha: 1.0), completion: {
                self.isUserInteractionEnabled = true
            })
        case .TutorialsNode:
            menuNode.run(changeNodesAction(alpha: 0.0))
            tutorialsNode!.run(changeNodesAction(alpha: 1.0), completion: {
                self.isUserInteractionEnabled = true
            })
        }
    }
    
    func immadiatelyChangeNodes() {
        if state == .LevelsNode {
            levelsNode!.alpha = 0.0
            menuNode.alpha = 1.0
            isUserInteractionEnabled = true
            menuNode.isUserInteractionEnabled = true
            state = .MenuNode
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch state {
        case .MenuNode:
            menuNode.touchesEnded(touches, with: event)
        case .LevelsNode:
            levelsNode?.touchesEnded(touches, with: event)
        case .TutorialsNode:
            tutorialsNode?.touchesEnded(touches, with: event)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
