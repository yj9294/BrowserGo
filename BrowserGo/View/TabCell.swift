//
//  TabCell.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit
import WebKit

class TabCell: UICollectionViewCell {

    @IBOutlet weak var navigationLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var deleteHandle: (()->Void)? = nil
    
    var item: BrowseItem? = nil {
        didSet {
            layer.cornerRadius = 8
            layer.masksToBounds = true
            if item?.isSelect == true {
                layer.borderColor = UIColor.blue.cgColor
                layer.borderWidth = 2
                
            } else {
                layer.borderColor = UIColor.gray.cgColor
                layer.borderWidth = 1
            }
            
            self.subviews.forEach {
                if $0 is WKWebView {
                    $0.removeFromSuperview()
                }
            }

            if let webView = item?.webView, item?.isNavigation == false{
                navigationLabel.isHidden = true
                self.insertSubview(webView, at: 0)
            } else {
                navigationLabel.isHidden = false
            }
            
            closeButton.isHidden = BrowseUtil.shared.items.count == 1
        }
    }
    
    override func layoutSubviews() {
        if let webView = item?.webView {
            webView.frame = self.bounds
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deleteAction() {
        deleteHandle?()
    }

}
