//
//  RootVC.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit

class RootVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [LaunchVC(), HomeVC()]
        tabBar.isHidden = true
        NotificationCenter.default.addObserver(forName: .didLaunhced, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 1
        }
        
        NotificationCenter.default.addObserver(forName: .willLaunhceing, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.selectedIndex = 0
        }
        
        FirebaseUtil.logProperty(name: .local)
        FirebaseUtil.logEvent(name: .open)
        FirebaseUtil.logEvent(name: .openCold)
    }
}
