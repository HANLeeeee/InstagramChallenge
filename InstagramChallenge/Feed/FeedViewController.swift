//
//  FeedViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/31.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var feedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func registerTableView() {
        let storytableViewCellNib = UINib(nibName: "StoryTableViewCell", bundle: nil)
        self.feedTableView.register(storytableViewCellNib, forCellReuseIdentifier: "StoryTableViewCell")
        
        let feedtableViewCellNib = UINib(nibName: "FeedTableViewCell", bundle: nil)
        self.feedTableView.register(feedtableViewCellNib, forCellReuseIdentifier: "FeedTableViewCell")
        
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        feedTableView.separatorStyle = .none
    }
    
    func setNavigationBackBtn() {
        let backBarButtonItem = UIBarButtonItem(title: "취소", style: .done, target: self, action: nil)
            backBarButtonItem.tintColor = .black  // 색상 변경
            self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 10
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "StoryTableViewCell", for: indexPath) as! StoryTableViewCell

            cell.selectionStyle = .none
            return cell
            
        case 1:
            let cell = feedTableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell

            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 120

        case 1:
            return UITableView.automaticDimension

        default:
            return UITableView.automaticDimension
        }
    }
}
