//
//  StoryTableViewCell.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/02.
//

import UIKit

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var storyCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerXib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func registerXib() {
        let collectionCell = UINib(nibName: "StoryCollectionViewCell", bundle: nil)
        storyCollectionView.register(collectionCell, forCellWithReuseIdentifier: "StoryCollectionViewCell")
                
        storyCollectionView.delegate = self
        storyCollectionView.dataSource = self
                
        storyCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}

extension StoryTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = storyCollectionView.dequeueReusableCell(withReuseIdentifier: "StoryCollectionViewCell", for: indexPath) as! StoryCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 80, height: 100)
        }
    
    
}
