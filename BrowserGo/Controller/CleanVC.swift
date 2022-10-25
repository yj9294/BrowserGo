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

        // Do any additional setup after loading the view.
        view.insertSubview(animationView, at: 1)
        animationView.play()
        animationView.center = CGPoint(x: view.center.x, y: view.center.y)
        animationView.bounds = CGRect(x: 0, y: 0, width: 198, height: 198)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.animationView.stop()
            self.completion?()
            self.dismiss(animated: true)
        }
    }
    
}
