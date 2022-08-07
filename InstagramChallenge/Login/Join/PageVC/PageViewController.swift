//
//  PageViewController.swift
//  InstagramChallenge
//
//  Created by 최하늘 on 2022/07/28.
//

import UIKit

class PageViewController: UIPageViewController {
    var completeHandler: ((Int)->())?
    let pageVCs: [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let pagePhone = storyBoard.instantiateViewController(withIdentifier: "PagePhoneViewController")
        let pageEmail = storyBoard.instantiateViewController(withIdentifier: "PageEmailViewController")
        
        return [pagePhone, pageEmail]
    }()
    
    var currentIndex: Int {
        guard let page = viewControllers?.first else {
            return 0
        }
        return pageVCs.firstIndex(of: page) ?? 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    //MARK: 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        registerPageController()
    }
    
    //MARK: 페이지뷰셀 등록
    func registerPageController() {
        self.dataSource = self
        self.delegate = self
        
        if let firstPage = pageVCs.first {
            self.setViewControllers([firstPage], direction: .forward, animated: false)
        }
    }
}




//MARK: 페이지뷰 데이터
extension PageViewController: UIPageViewControllerDataSource , UIPageViewControllerDelegate {
    func setViewControllersIndex(index: Int) {
        if index < 0 && index >= pageVCs.count {
            return
        }
        self.setViewControllers([pageVCs[index]], direction: .forward, animated: false, completion: nil)
        completeHandler?(currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            completeHandler?(currentIndex)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageVCs.firstIndex(of: viewController) else {
            return nil
        }
        
        let preIndex = index-1
        if preIndex < 0 {
            return nil
        }
        
        return pageVCs[preIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageVCs.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = index+1
        if nextIndex == pageVCs.count {
            return nil
        }
        
        return pageVCs[nextIndex]
    }
}
