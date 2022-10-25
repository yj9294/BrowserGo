//
//  BaseView.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit

class BaseView: UIView, NibLoadable {

    @IBAction func dismiss() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0
        } completion: { isSuccess in
            if isSuccess {
                self.removeFromSuperview()
            }
        }
    }
    
    func present(){
        if let window = UIApplication.shared.windows.first {
            window.addSubview(self)
            self.frame = window.bounds
            self.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.alpha = 1
            }
        }
    }

}
