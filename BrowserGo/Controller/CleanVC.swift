//
//  CleanVC.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit
import Lottie

class CleanVC: BaseVC {
    
    var completion: (()->Void)? = nil
    
    init(_ completion: (()->Void)? = nil) {
        self.completion = completion
        super.init(nibName: "CleanVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var animationView: AnimationView = {
        let view = AnimationView(name: "data")
        view.loopMode = .loop
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        GADUtil.share.load(.interstitial)
        
        // Do any additional setup after loading the view.
        view.insertSubview(animationView, at: 1)
        animationView.play()
        animationView.center = CGPoint(x: view.center.x, y: view.center.y - 150)
        animationView.bounds = CGRect(x: 0, y: 0, width: 198, height: 198)
        
        var duration = 15.6
        var needShowAD = false
        var progress = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if progress >= 1.0 {
                timer.invalidate()
                GADUtil.share.show(.interstitial, vc: self) { _ in
                    self.animationView.stop()
                    self.completion?()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.dismiss(animated: true)
                    }
                }
            } else {
                progress += 1.0 / (duration * 100)
            }
            if needShowAD, GADUtil.share.isLoaded(.interstitial) {
                duration = 0.1
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            timer.invalidate()
            needShowAD = true
            duration = 15.6
        }
    }
    
}
