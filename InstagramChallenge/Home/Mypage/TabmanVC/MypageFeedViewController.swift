//
//  MypageFeedViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import UIKit

class MypageFeedViewController: UIViewController {
    let userInfo = UserDefaultsData.shared.getToken()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var feedsResult = [FeedResponseResult]()
    var pageIdx = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //피드초기화
        pageIdx = 0
        feedsResult.removeAll()
        getFeedImage()
    }
    
    func registerXib() {
        let collectionCell = UINib(nibName: "MypageFeedCollectionViewCell", bundle: nil)
        collectionView.register(collectionCell, forCellWithReuseIdentifier: "MypageFeedCollectionViewCell")
                
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func getFeedImage() {
        APIFeedGet().getFeedsUser(accessToken: userInfo.jwt!, pageIndex: pageIdx, size: 12, loginId: userInfo.loginId!, completion: { result in
            switch result {
            case .success(let result):
                if self.pageIdx == 0 {
                    self.feedsResult = result

                } else {
                    self.feedsResult += result
                }
                self.collectionView.reloadData()
//                self.refreshControl.endRefreshing()
                
            case .failure(let error):
                print(error)
            }
            
        })
    }
}

//MARK: 컬렉션뷰
extension MypageFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedsResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MypageFeedCollectionViewCell", for: indexPath) as! MypageFeedCollectionViewCell
        
        setCellValue(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {

            let interval:CGFloat = 3
            let width: CGFloat = ( UIScreen.main.bounds.width - interval * 2 ) / 3
            return CGSize(width: width , height: width )
    }

    //2
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 3
    }

    //3
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 3
    }
    
    
    func setCellValue(cell: MypageFeedCollectionViewCell, indexPath: IndexPath) {
        guard let imageUrl = URL(string: self.feedsResult[indexPath.row].contentsList![0].contentsUrl!) else {
            cell.imageView.image = UIImage()
            return }
        cell.imageView.kf.setImage(with: imageUrl)
    }
}
