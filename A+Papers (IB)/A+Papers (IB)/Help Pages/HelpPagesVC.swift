//
//  HelpPagesVC.swift
//  A+Papers (IB)
//
//  Created by Danesh Rajasolan on 2020-01-19.
//  Copyright © 2020 Danesh Rajasolan. All rights reserved.
//

import UIKit

class HelpPagesVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pageControl = UIPageControl()
        
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Help", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
        
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "sb_help1"), self.newVc(viewController: "sb_help4"), self.newVc(viewController: "sb_help5"), self.newVc(viewController: "sb_help6"), self.newVc(viewController:"sb_help2"), self.newVc(viewController:"sb_help3")]
//            , self.newVc(viewController: "sb_help4")]
    }()
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
            
        let previousIndex = viewControllerIndex - 1
            
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
            
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
            
        return orderedViewControllers[previousIndex]
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
            
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
            
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
            
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
            
        return orderedViewControllers[nextIndex]
    }

    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.red
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
        
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
    }
        
    override func viewDidAppear(_ animated: Bool) {
        configurePageControl()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("Help", comment: "")
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
                setViewControllers([firstViewController],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
        }
    }
}
