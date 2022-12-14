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
        let duration = 2.5
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] timer in
            guard let self  = self else { return }
            if self.progress >= 1.0 {
                timer.invalidate()
                NotificationCenter.default.post(name: .didLaunhced, object: nil)
            } else {
                self.progress += 1.0 / (duration * 100)
            }
        }
    }
}

extension Notification.Name {
    static let didLaunhced = Notification.Name("com.didLaunched")
    static let willLaunhceing = Notification.Name("com.willLaunching")

}
