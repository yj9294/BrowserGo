//
//  HomeVC.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit
import AppTrackingTransparency

class HomeVC: BaseVC {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchPlaceholderLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tabButton: UIButton!
    
    @IBOutlet weak var adView: NativeADView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var item: BrowseItem{
        BrowseUtil.shared.item
    }
    
    var adImpressionDate: Date? {
        GADUtil.share.homeNativeAdImpressionDate
    }
    
    var startLoadDate: Date = Date()
    var willApear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ATTrackingManager.requestTrackingAuthorization { _ in
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] _ in
            self?.keyboardWillShow()
        }
        NotificationCenter.default.addObserver(forName: UIApplication.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.keyboardWillHidden()
        }
        
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            
            // native ad is being display.
            if let ad = noti.object as? NativeADModel, self?.willApear == true {

                // view controller impression ad date betwieen 10s to show ad
                if Date().timeIntervalSince1970 - (self?.adImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADUtil.share.homeNativeAdImpressionDate = Date()
                } else {
                    SLog("[AD] 10s home 原生广告刷新或数据填充间隔.")
                }
            } else {
                self?.adView.nativeAd = nil
            }
        }
        
        // native ad enterbackground
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [weak self] _ in
            GADUtil.share.close(.native)
            self?.willApear = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willApear = true
        refreshUI()
        FirebaseUtil.logEvent(name: .homeShow)
        if item.isNavigation {
            FirebaseUtil.logEvent(name: .navigaShow)
            GADUtil.share.load(.native)
            GADUtil.share.load(.interstitial)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willApear = false
        GADUtil.share.close(.native)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        item.webView.frame = contentView.bounds
    }

    @IBAction func searchOrCancel() {
        if searchButton.isSelected == false {
            // search
            if !canSearh() {
                return
            }
            searchButton.isSelected = !searchButton.isSelected
        } else {
           // stop search
            item.webView.stopLoading()
        }
        refreshUI()
    }
    
    @IBAction func navigationClick(btn: UIButton) {
        if HomeNavigationItem.allCases.count > btn.tag - 1 {
            let item = HomeNavigationItem.allCases[btn.tag - 1]
            let text = item.url
            search(text)
            FirebaseUtil.logEvent(name: .navigaClick, params: ["lig": "\(item)"])
        }
    }
    
    @IBAction func tabAction()  {
        let vc = TabVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func backAction() {
        item.webView.goBack()
    }
    
    @IBAction func fowordAction() {
        item.webView.goForward()
    }
    
    @IBAction func cleanAction() {
        alert("Tips") { [weak self] in
            guard let self = self else { return }
            let vc = CleanVC {
                FirebaseUtil.logEvent(name: .cleanSuccess)
                BrowseUtil.shared.clean()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if AppRootVC?.selectedIndex == 1 {
                        self.alert("Cleaned successful.")
                        FirebaseUtil.logEvent(name: .cleanAlert)
                    }
                }
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
        
        FirebaseUtil.logEvent(name: .cleanClick)
    }
    
    @IBAction func settingAction() {
        self.definesPresentationContext = true
        let vc = SettingVC()
        vc.refreshHandle = { [weak self] in
            self?.refreshUI()
        }
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        let navi = UINavigationController(rootViewController: vc)
        navi.view.backgroundColor = .clear
        navi.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.present(navi, animated: true)
    }
}

extension HomeVC {
    
    func refreshUI () {
        searchTextField.text = item.webView.url?.absoluteString ?? ""
        searchButton.isSelected = item.webView.isLoading
        searchPlaceholderLabel.isHidden = searchTextField.text?.count != 0
        progressView.isHidden = !item.webView.isLoading
        tabButton.setTitle("\(BrowseUtil.shared.items.count)", for: .normal)
        
        backButton.isEnabled = item.webView.canGoBack
        nextButton.isEnabled = item.webView.canGoForward
        item.backEnableHandle = { [weak self] (i,canGoBack) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            DispatchQueue.main.async {
                self.backButton.isEnabled = canGoBack
            }
        }
        
        item.nextEnableHandle = { [weak self] (i,canGoForward) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            DispatchQueue.main.async {
                self.nextButton.isEnabled = canGoForward
            }
        }
        
        item.progressExchangedHandle = { [weak self] (i,progress) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            debugPrint(progress)
            self.progressView.isHidden = false
            self.progressView.progress = progress
            self.searchButton.isSelected = true
            if progress >= 1.0 {
                self.progressView.isHidden = true
                self.searchButton.isSelected = false
                let time = Date().timeIntervalSince1970 - self.startLoadDate.timeIntervalSince1970
                FirebaseUtil.logEvent(name: .webSuccess, params: ["lig": "\(ceil(time))"])
            } else if progress == 0.1 {
                self.startLoadDate = Date()
            }
        }
        
        if let url = item.webView.url?.absoluteString {
            item.webView.isHidden = url.count == 0
        } else {
            item.webView.isHidden = true
        }
        item.urlExchangedHandle = { [weak self] (i,url) in
            guard let self = self else { return }
            if self.item != i {
                return
            }
            self.searchTextField.text = url
            self.searchPlaceholderLabel.isHidden = url.count > 0
            self.item.webView.isHidden = url.count == 0
        }
        
        contentView.addSubview(item.webView)
    }
    
    @discardableResult
    func canSearh() -> Bool {
        self.view.endEditing(true)
        if let text = searchTextField.text, text.count > 0 {
            if item.isNavigation {
                FirebaseUtil.logEvent(name: .navigaSearch, params: ["lig": text])
                
            }
            search(text)
            return true
        }
        alert("Please enter your search content.")
        return false
    }
    
    func search(_ text: String) {
        self.view.endEditing(true)
        item.loadUrl(text)
        refreshUI()
        
        startLoadDate = Date()
        FirebaseUtil.logEvent(name: .webStart)
    }
}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        canSearh()
        return true
    }
}

extension HomeVC {
    func keyboardWillShow() {
        searchPlaceholderLabel.isHidden = true
    }
    
    func keyboardWillHidden() {
        if searchTextField.text?.count == 0 {
            searchPlaceholderLabel.isHidden = false
        }
    }
}

enum HomeNavigationItem: CaseIterable {
    case facebook, google, youtube, twitter, instagram, amazone, gmail, yahoo
    var url: String {
        return "https://www.\(self).com"
    }
}

