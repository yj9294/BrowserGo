//
//  BrowseUtil.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit
import WebKit

class BrowseUtil: NSObject {
    static let shared = BrowseUtil()
    var items:[BrowseItem] = [.navgationItem]
    var item: BrowseItem {
        items.filter {
            $0.isSelect == true
        }.first ?? .navgationItem
    }
}

extension BrowseUtil {
    
    func remove(_ item: BrowseItem) {
        if item.isSelect {
            items = items.filter {
                $0 != item
            }
            items.first?.isSelect = true
        } else {
            items = items.filter {
                $0 != item
            }
        }
    }
    
    func select(_ item: BrowseItem) {
        if items.contains(item) {
            items.forEach {
                if $0 == item {
                    $0.isSelect = true
                } else {
                    $0.isSelect = false
                }
            }
        }
    }
    
    func add(_ item: BrowseItem = .navgationItem) {
        items.forEach {
            if $0.isSelect {
                $0.webView.removeFromSuperview()
            }
            $0.isSelect = false
        }
        items.insert(item, at: 0)
    }
    
    func clean() {
        items.forEach {
            $0.webView.removeFromSuperview()
        }
        items = [.navgationItem]
    }
}


class BrowseItem: NSObject {
    init(webView: WKWebView, isSelect: Bool) {
        self.webView = webView
        self.isSelect = isSelect
    }
    var webView: WKWebView
    var isSelect: Bool

    var isNavigation: Bool {
        webView.url == nil
    }
    
    var backEnableHandle: ((BrowseItem?, Bool)->Void)? = nil
    var nextEnableHandle: ((BrowseItem?, Bool)->Void)? = nil
    var progressExchangedHandle: ((BrowseItem, Float)->Void)? = nil
    var urlExchangedHandle: ((BrowseItem, String)->Void)? = nil
    
    static var navgationItem: BrowseItem {
        let webView = WKWebView()
        webView.isHidden = true
        webView.backgroundColor = .white
        let item = BrowseItem(webView: webView, isSelect: true)
        webView.uiDelegate = item
        webView.navigationDelegate = item
        webView.addObserver(item, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
        webView.addObserver(item, forKeyPath: #keyPath(WKWebView.url), context: nil)
        return item
    }
}

extension BrowseItem {
    func loadUrl(_ url: String) {
        webView.isHidden = false
        if url.isUrl, let Url = URL(string: url) {
            let request = URLRequest(url: Url)
            webView.load(request)
        } else {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let reqString = "https://www.google.com/search?q=" + urlString
            self.loadUrl(reqString)
        }
    }
    
    func stopLoad() {
        webView.stopLoading()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard let webView =  object as? WKWebView else { return }
        
        // url重定向
        if keyPath == #keyPath(WKWebView.url) {
            if let item = webView.navigationDelegate as? BrowseItem {
                DispatchQueue.main.async {
                    self.urlExchangedHandle?(item, webView.url?.absoluteString ?? "")
                }
            }
        }
        
        // 进度
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            let progress: Float = Float(webView.estimatedProgress)
            if let item = webView.navigationDelegate as? BrowseItem {
                DispatchQueue.main.async {
                    self.progressExchangedHandle?(item, progress)
                }
            }
        }
    }
}


extension BrowseItem: WKUIDelegate, WKNavigationDelegate {
    /// 跳转链接前是否允许请求url
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let item = webView.uiDelegate as? BrowseItem {
            backEnableHandle?(item, webView.canGoBack)
            nextEnableHandle?(item, webView.canGoForward)
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        if let item = webView.uiDelegate as? BrowseItem {
            backEnableHandle?(item, webView.canGoBack)
            nextEnableHandle?(item, webView.canGoForward)
        }
        decisionHandler(.allow)
    }
    
    /// 响应后是否跳转
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        if let item = webView.uiDelegate as? BrowseItem {
            backEnableHandle?(item, webView.canGoBack)
            nextEnableHandle?(item, webView.canGoForward)
        }
        webView.load(navigationAction.request)
        FirebaseUtil.logEvent(name: .webStart)
        return nil
    }
    
}
