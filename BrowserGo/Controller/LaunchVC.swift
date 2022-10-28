//
//  LaunchVC.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit

class LaunchVC: BaseVC {

    @IBOutlet weak var progressView: UIProgressView!
    
    var progress = 0.0 {
        didSet {
            progressView.progress = Float(progress)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .willLaunhceing, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.startAnimation()
        }
    }

    func startAnimation() {
        progress = 0
        var duration = 2.5 / 0.6
        var needShowAD = false
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self  = self else { return }
            if self.progress >= 1.0 {
                timer.invalidate()
                GADUtil.share.show(.interstitial) { _ in
                    NotificationCenter.default.post(name: .didLaunhced, object: nil)
                }
            } else {
                self.progress += 1.0 / (duration * 100)
            }
            if needShowAD, GADUtil.share.isLoaded(.interstitial) {
                duration = 1.0
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { timer in
            timer.invalidate()
            needShowAD = true
            duration = 15.6
        }
        
        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
    }
}

extension Notification.Name {
    static let didLaunhced = Notification.Name("com.didLaunched")
    static let willLaunhceing = Notification.Name("com.willLaunching")

}
