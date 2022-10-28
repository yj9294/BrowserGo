//
//  TabVC.swift
//  BrowserGo
//
//  Created by yangjian on 2022/10/24.
//

import UIKit

class TabVC: BaseVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var adView: NativeADView!
    
    var dataSource: [BrowseItem] {
        BrowseUtil.shared.items
    }
    
    var adImpressionDate: Date? {
        GADUtil.share.tabNativeAdImpressionDate
    }
    
    var willApear = false

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "TabCell", bundle: .main), forCellWithReuseIdentifier: "TabCell")
        FirebaseUtil.logEvent(name: .tabShow)
        
        NotificationCenter.default.addObserver(forName: .nativeUpdate, object: nil, queue: .main) { [weak self] noti in
            
            // native ad is being display.
            if let ad = noti.object as? NativeADModel, self?.willApear == true {

                // view controller impression ad date betwieen 10s to show ad
                if Date().timeIntervalSince1970 - (self?.adImpressionDate ?? Date(timeIntervalSinceNow: -11)).timeIntervalSince1970 > 10 {
                    self?.adView.nativeAd = ad.nativeAd
                    GADUtil.share.tabNativeAdImpressionDate = Date()
                } else {
                    SLog("[AD] 10s tab 原生广告刷新或数据填充间隔.")
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

        GADUtil.share.load(.interstitial)
        GADUtil.share.load(.native)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willApear = false
        GADUtil.share.close(.native)
    }

    @IBAction func newAction() {
        BrowseUtil.shared.add()
        self.dismiss(animated: true)
        FirebaseUtil.logEvent(name: .tabNew, params: ["lig": "tab"])
    }
    
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
}

extension TabVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 40 - 16) / 2.0
        return CGSize(width: width, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.item]
        BrowseUtil.shared.select(item)
        self.dismiss(animated: true)
    }
}

extension TabVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCell", for: indexPath)
        if let cell = cell as? TabCell {
            let item = dataSource[indexPath.item]
            cell.item = item
            cell.deleteHandle = { [weak self] in
                BrowseUtil.shared.remove(item)
                self?.collectionView.reloadData()
            }
        }
        return cell
    }
}
