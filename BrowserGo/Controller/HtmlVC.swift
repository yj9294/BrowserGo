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
Privacy Policy
This page is used to inform visitors of our policies regarding the collection, use and disclosure of personal information if someone decides to use our services.
If you choose to use our services, you agree to the collection and use of information in connection with this policy. The information we collect is used to provide and improve services. We will not use or share your information with anyone other than as described in this Privacy Policy.
Terms used in this Privacy Policy have the same meanings as our Terms and Conditions, which are accessible on the browser unless otherwise defined in this Privacy Policy.

Information Collection and Use
For a better experience, we may ask you to provide us with certain personally identifiable information when using our services, including but not limited to mobile applications. The information we request will be retained by us and used as described in this Privacy Policy.
The app does use third-party services that may collect information that can be used to identify you.
Links to the privacy policies of third-party service providers used by the app

AdMob：https://support.google.com/admob
Google Analytics for Firebase：https://firebase.google.com/policies/analytics
Firebase Crashlytics：https://firebase.google.com/support/privacy/
Facebook：https://www.facebook.com/about/privacy/
Service  provider
We may employ third-party companies and individuals for the following reasons:
to promote our services;
to provide services on our behalf;
perform services in connection with the services; or
To assist us in analyzing how our services are used.
We would like to inform users of this service that these third parties have access to their personal information. The reason is to perform the tasks assigned to them on our behalf. However, they are obliged not to disclose or use this information for any other purpose.

Safety
We value the trust you place in providing us with your personal information, so we are working hard to protect it using commercially acceptable means. Remember, however, that no method of transmission over the Internet or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.
"""
            
            
        case .terms:
            return """
Terms of use
Please read these terms and conditions ("Terms", "Terms and Conditions") carefully before using the app, the desktop application developed and operated by us.

Your access to and use of the Services is subject to your acceptance and compliance with these Terms. These terms apply to all visitors, users and others who wish to access or use the Services.

By accessing or using the Services, you agree to be bound by these terms. If you do not agree to any part of the terms, you do not have access to the service.

Services
Our Services allow you to post, link to, store, share and otherwise make available certain information, text, graphics, video or other materials ("Content"). You are responsible for the content you post on or through the Services, including its legality, reliability and appropriateness.

By posting content on or through the Service, you should do
Absolutely prohibited:
· Violate or encourage the violation of the legal rights of others engage in, facilitate or encourage illegal activities;
· For any unlawful, intrusive, tortuous, defamatory or fraudulent purpose;
· Intentionally distribute viruses, worms, Trojan horses, corrupted files, hoaxes or other destructive or deceptive items;
· Interfere with Customer, Authorized Reseller or other Authorized User's use of the Services or the equipment used to provide the Services;
· Disable, interfere with or circumvent any aspect of the Services;
· Use the Service or any interface provided by the Service to access any other product or service in a manner that violates the terms of service of such other product or service.
"""
        }
    }
}
