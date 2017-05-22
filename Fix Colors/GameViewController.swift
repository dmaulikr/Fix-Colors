//
//  GameViewController.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import UIKit
import SpriteKit
import UserNotifications
import GoogleMobileAds

class GameViewController: UIViewController, AdsDelegate, GADInterstitialDelegate {
    
    var settings = Settings()
    var interstitialAd: GADInterstitial?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let s = settings.loadGame() {
            settings = s
        }
        GameAudio.shared.setupSounds()
        interstitialAd = createAndLoadInterstitial()
        let skView = self.view as! SKView
        skView.ignoresSiblingOrder = true
        let scene = MainScene(size: skView.bounds.size, settings: settings)
        scene.gameSceneNode.adsDelegate = self
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    internal func showAds() {
        if interstitialAd != nil {
            if interstitialAd!.isReady {
                interstitialAd?.present(fromRootViewController: self)
            }
        } else {
            print("Ad wasn't ready...")
        }
    }
    
    private func createAndLoadInterstitial() -> GADInterstitial {
        let request = GADRequest()
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-5734038369870188/8416800553")
        interstitial.delegate = self
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitialAd = createAndLoadInterstitial()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
