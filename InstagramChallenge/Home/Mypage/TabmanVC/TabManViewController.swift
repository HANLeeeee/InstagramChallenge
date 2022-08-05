//
//  TabManViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/08/05.
//

import UIKit
import Tabman
import Pageboy

class TabManViewController: TabmanViewController {
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstVC = UIStoryboard.init(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "MypageFeedViewController") as! MypageFeedViewController
        let secondVC = UIStoryboard.init(name: "Mypage", bundle: nil).instantiateViewController(withIdentifier: "MypageTagViewController") as! MypageTagViewController

        viewControllers.append(firstVC)
        viewControllers.append(secondVC)
        
        self.dataSource = self
                
        let bar = TMBar.TabBar()
                
        //탭바 레이아웃 설정
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
//        bar.layout.contentMode = .intrinsic
        //        .fit : indicator가 버튼크기로 설정됨
//        bar.layout.interButtonSpacing = view.bounds.width / 8

                
        //배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = .white
        
                
        //간격설정
        bar.layout.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
             
        //indicator
//        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = .blue
        bar.indicator.isHidden = false
        

        addBar(bar, dataSource: self, at: .top)
    }
}

extension TabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        let item = TMBarItem(title: "")
        switch index {
        case 0:
            item.title = ""
            item.image = UIImage(named: "icon_heart")
            return item
            
        case 1:
            item.title = ""
            item.image = UIImage(named: "icon_heart")
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
