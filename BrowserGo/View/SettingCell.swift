//
//  SettingCell.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var titleLeading: NSLayoutConstraint!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var item: SettingItem? = nil {
        didSet {
            self.title.text = item?.title
            if let image = UIImage(named: item?.image ?? "") {
                icon.image = image
                titleLeading.constant = 42
            } else {
                titleLeading.constant = 16
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
