//
//  HtmlVC.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit

class HtmlVC: BaseVC {

    
    @IBOutlet weak var textView: UITextView!
    
    var item: HtmlItem = .privacy
    
    init(_ item: HtmlItem = .privacy) {
        self.item = item
        super.init(nibName: "HtmlVC", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = item.body
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(backAction))
        let label = UILabel()
        label.text = item.title
        label.textColor = textView.textColor
        self.navigationItem.titleView = label
    }
    
    @objc func backAction() {
        self.dismiss(animated: true)
    }
}


enum HtmlItem {
    case privacy, terms
    var title: String {
        switch self {
        case .privacy:
            return "Privacy Policy"
        case .terms:
            return "Terms of User"
        }
    }
    
    var body: String {
        switch self {
        case .privacy:
            return """
We (the folks & Automatic 81 on ล mission 1omake the web ฉ better place W hope you love our products ลกd service = from website publishing1ools 1๐ eCommerce solutions to security tackupsyรtens t0 กmอกลg many tools far distributed companies to the next gree ideร that we haven’t even thought of yet- ฃร much จร we Iovc creating them

The Terms at Service {" Terms" describe our commitments 1o you, ard you ศighls and

reporsilites when using our services Piaso1ed therm carefully and reach out 10 บร if you Iaveอาy questions these ems mc UDC mandatory arbitration provision ท 5ection 16 if you don

agree &0 these Terns dor uร- our services we’ve made these Terres available und ๏Creative Commons Sharealixe license which means that you're more than welcome t0 copy them, adapt them and repurpose them for ycurดพา uร฿; Just make sure 1o eรe them $0 that

you Term ยf Sevice reflect yจur actual practicesASD t you do u5e these Terms, we'd appreciate credit ลาย lirk 10 Auto Mattie somewhere or your website
"""
            
            
        case .terms:
            return """
We (the folks & Automatic 81 on ล mission 1omake the web ฉ better place W hope you love our products ลกd service = from website publishing1ools 1๐ eCommerce solutions to security tackupsyรtens t0 กmอกลg many tools far distributed companies to the next gree ideร that we haven’t even thought of yet- ฃร much จร we Iovc creating them

The Terms at Service {" Terms" describe our commitments 1o you, ard you ศighls and

reporsilites when using our services Piaso1ed therm carefully and reach out 10 บร if you Iaveอาy questions these ems mc UDC mandatory arbitration provision ท 5ection 16 if you don

agree &0 these Terns dor uร- our services we’ve made these Terres available und ๏Creative Commons Sharealixe license which means that you're more than welcome t0 copy them, adapt them and repurpose them for ycurดพา uร฿; Just make sure 1o eรe them $0 that

you Term ยf Sevice reflect yจur actual practicesASD t you do u5e these Terms, we'd appreciate credit ลาย lirk 10 Auto Mattie somewhere or your website
"""
        }
    }
}
