//
//  MainScene.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import SpriteKit
import AVFoundation

enum MainSceneState {
    case MenuState, GameState
}

class MainScene: SKScene, MenuSceneNodeDelegate, GameSceneNodeDelegate {
    
    let settings: Settings
    var level = Level()
    let gameSceneNode: GameSceneNode
    let menuSceneNode: MenuSceneNode
    
    var state: MainSceneState = .MenuState {
        didSet {
            changeSceneNode()
        }
    }
    
    init(size: CGSize, settings: Settings) {
        self.settings = settings
        self.menuSceneNode = MenuSceneNode(settings: settings)
        self.gameSceneNode = GameSceneNode(settings: settings)
        super.init(size: size)
        backgroundColor = BgColor
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        setupMenuSceneNode()
        setupGameSceneNode()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        fadeIn.timingMode = .easeIn
        menuSceneNode.run(fadeIn, completion: {
            self.menuSceneNode.isUserInteractionEnabled = true
        })
    }
    
    internal func pauseButtonPressed() {
        menuSceneNode.immadiatelyChangeNodes()
        state = .MenuState
    }
    
    internal func beginGame() {
        state = .GameState
    }
    
    internal func playWithLevel(lvl: Int) {
        if gameSceneNode.completionOn {
            gameSceneNode.completionOn = false
        }
        cleanGameSceneNode()
        gameSceneNode.gameScenePaused = false
        settings.level = lvl
        state = .GameState
    }
    
    private func changeSceneNode() {
        let duration: TimeInterval = 0.5
        let waitAction = Actions.waitAction(duration: 0.4)
        switch state {
        case .GameState:
            switch gameSceneNode.gameScenePaused {
            case false:
                prepareLevel()
                settings.moves = 0
                let firstBlock = SKAction.run({
                    self.menuSceneNode.run(Actions.fadeOutAction(duration: duration))
                })
                let secondBlock = SKAction.run({
                    let blockAction = SKAction.run({
                        self.gameSceneNode.level = self.level
                        self.gameSceneNode.setup()
                    })
                    let fadeIn = Actions.fadeInAction(duration: duration)
                    let seq = SKAction.sequence([blockAction, fadeIn])
                    self.gameSceneNode.run(seq, completion: {
                        self.gameSceneNode.isUserInteractionEnabled = true
                        self.gameSceneNode.hudNode.isUserInteractionEnabled = true
                    })
                })
                let seq = SKAction.sequence([firstBlock, waitAction, secondBlock])
                run(seq)
            case true:
                let firstBlock = SKAction.run({
                    self.menuSceneNode.run(Actions.fadeOutAction(duration: duration))
                })
                let secondBlock = SKAction.run({
                    self.gameSceneNode.run(Actions.fadeInAction(duration: duration), completion: {
                        self.gameSceneNode.gameScenePaused = false
                        self.gameSceneNode.isUserInteractionEnabled = true
                        self.gameSceneNode.hudNode.isUserInteractionEnabled = true
                    })
                })
                let seq = SKAction.sequence([firstBlock, waitAction, secondBlock])
                run(seq)
            }
        case .MenuState:
            let firstBlock = SKAction.run({
                self.gameSceneNode.run(Actions.fadeOutAction(duration: duration))
            })
            let secondBlock = SKAction.run({
                self.menuSceneNode.run(Actions.fadeInAction(duration: duration), completion: {
                    self.menuSceneNode.makeLevelsNode()
                    self.menuSceneNode.isUserInteractionEnabled = true
                })
            })
            let seq = SKAction.sequence([firstBlock, waitAction, secondBlock])
            run(seq)
        }
    }
    
    internal func prepareLevel() {
        level.clean()
        level.loadLevelFile(levelName: settings.level.getLevelName())
        level.setupGrid()
    }
    
    internal func levelCompleted() {
        cleanGameSceneNode()
        gameSceneNode.level = level
        gameSceneNode.setup()
    }
    
    internal func replay() {
        settings.moves = 0
        cleanGameSceneNode()
        prepareLevel()
        gameSceneNode.level = level
        gameSceneNode.setup()
    }
    
    internal func endOfGame() {
        menuSceneNode.immadiatelyChangeNodes()
        state = .MenuState
        cleanGameSceneNode()
    }
    
    internal func share(completion: @escaping () -> ()) {
        let objectsToShare = ["Try this amazing new puzzle game! Now I'm at level: \(settings.returnLastLevel()). https://itunes.apple.com/app/id1225642042"]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .addToReadingList]
        let currentVC: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        currentVC.present(activityVC, animated: true, completion: {
            self.menuSceneNode.isUserInteractionEnabled = true
        })
    }
    
    internal func rate(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "itms-apps://itunes.apple.com/app/id1225642042") else { return }
        guard #available(iOS 10, *) else {
            UIApplication.shared.openURL(url)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    internal func removeGestures() {
        if let gestures = self.view?.gestureRecognizers {
            for recognizer in gestures {
                self.view?.removeGestureRecognizer(recognizer)
            }
        }
    }
    
    internal func setupGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MainScene.handleSwipe))
        swipeRight.direction = .right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MainScene.handleSwipe))
        swipeLeft.direction = .left
        self.view?.addGestureRecognizer(swipeLeft)
    }
    
    internal func disableUserInteraction() {
        isUserInteractionEnabled = false
    }
    
    internal func enableUserInteraction() {
        isUserInteractionEnabled = true
    }
    
    private func cleanGameSceneNode() {
        gameSceneNode.grid?.removeAllChildren()
        gameSceneNode.grid?.removeFromParent()
        gameSceneNode.level = nil
        gameSceneNode.grid = nil
    }
    
    private func setupMenuSceneNode() {
        menuSceneNode.alpha = 0.0
        menuSceneNode.isUserInteractionEnabled = false
        menuSceneNode.position = CGPoint(x: 0.0, y: 0.0)
        menuSceneNode.delegate = self
        addChild(menuSceneNode)
    }
    
    private func setupGameSceneNode() {
        gameSceneNode.alpha = 0.0
        gameSceneNode.isUserInteractionEnabled = false
        gameSceneNode.position = CGPoint(x: 0.0, y: 0.0)
        gameSceneNode.delegate = self
        addChild(gameSceneNode)
    }
    
    @objc private func handleSwipe(gesture: UISwipeGestureRecognizer) {
        switch menuSceneNode.state {
        case .MenuNode, .TutorialsNode:
            return
        case .LevelsNode:
            menuSceneNode.levelsNode!.swiped(direction: gesture.direction)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
