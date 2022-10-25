//
//  SettingVC.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit
import MobileCoreServices

class SettingVC: BaseVC {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshHandle: (()->Void)? = nil
    
    var item: BrowseItem {
        BrowseUtil.shared.item
    }
    
    lazy var dataSource: [SettingItem] = {
        return SettingItem.allCases
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SettingCell", bundle: .main), forCellReuseIdentifier: "SettingCell")
        tableView.separatorStyle = .none
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
    
    func newAction() {
        BrowseUtil.shared.add()
        self.dismiss(animated: true)
        refreshHandle?()
        FirebaseUtil.logEvent(name: .tabNew, params: ["lig": "setting"])
    }
    
    func shareAction() {
        var url = "https://itunes.apple.com/cn/app/id"
        if !BrowseUtil.shared.item.isNavigation {
            url = item.webView.url?.absoluteString ?? "https://itunes.apple.com/cn/app/id"
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(vc, animated: true)
        
        FirebaseUtil.logEvent(name: .shareClick)
    }
    
    func copyAction() {
        if !BrowseUtil.shared.item.isNavigation {
            UIPasteboard.general.setValue(item.webView.url?.absoluteString ?? "", forPasteboardType: kUTTypePlainText as String)
            self.alert("Copy successfully.")
            return
        }
        UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
        self.alert("Copy successfully.")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
        
        FirebaseUtil.logEvent(name: .copyClick)
    }
    
    func rateAction() {
        let url = URL(string: "https://itunes.apple.com/cn/app/id")
        if let url = url {
            UIApplication.shared.open(url)
        }
        self.dismiss(animated: true)
    }
    
    func termsAction() {
        self.navigationController?.pushViewController(HtmlVC(.terms), animated: true)
    }
    
    func privacyAction() {
        self.navigationController?.pushViewController(HtmlVC(.privacy), animated: true)
    }

}

extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        if let cell = cell as? SettingCell {
            cell.item = dataSource[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            newAction()
        case 1:
            shareAction()
        case 2:
            copyAction()
        case 3:
            rateAction()
        case 4:
            termsAction()
        case 5:
            privacyAction()
        default:
            break
        }
    }
    
}


enum SettingItem: CaseIterable {
    case new, share, copy, rate, terms, privacy
    var title: String {
        switch self {
        case .new:
            return "New"
        case .share:
            return "Share"
        case .copy:
            return "Copy"
        case .rate:
            return "Rate Us"
        case .terms:
            return "Terms of Users"
        case .privacy:
            return "Privacy Policy"
        }
    }
    var image: String {
        switch self {
        case .new:
            return "setting_new"
        case .share:
            return "setting_share"
        case .copy:
            return "setting_copy"
        default:
            return ""
        }
    }
}
