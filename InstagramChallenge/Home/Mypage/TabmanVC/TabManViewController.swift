//
//  TabManViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import UIKit
import Tabman
import Pageboy

//상단탭바 -Tabman라이브러리
class TabManViewController: TabmanViewController {
    private var viewControllers: [UIViewController] = []
    
    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTabmanBar()
    }
    
    //MARK: 탭맨바VC 등록
    func registerTabmanBar() {
        let firstVC = UIStoryboard.init(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "MypageFeedViewController") as! MypageFeedViewController
        let secondVC = UIStoryboard.init(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "MypageTagViewController") as! MypageTagViewController

        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
        
        self.dataSource = self
                
        let bar = TMBar.TabBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
                
        bar.backgroundView.style = .clear
        bar.backgroundColor = .white
             
        addBar(bar, dataSource: self, at: .top)
    }
}



//MARK: 탭맨 데이터
extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        switch index {
        case 0:
            item.title = ""
            item.image = UIImage(named: "icon_mypageFeed")
            return item
            
        case 1:
            item.title = ""
            item.image = UIImage(named: "icon_mypageTag")
            return item
            
        default:
            return item
        }
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
