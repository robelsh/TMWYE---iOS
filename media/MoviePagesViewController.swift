//
//  MoviePagesViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 12/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class MoviePagesViewController: UIPageViewController, UIPageViewControllerDataSource {

    var arrPageTitle: NSArray = NSArray()
    var arrPagePhoto: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrPageTitle = ["This is The App Guruz", "This is Table Tennis 3D", "This is Hide Secrets"];
        arrPagePhoto = ["1.jpg", "2.jpg", "3.jpg"];
        
        self.dataSource = self
        
        self.setViewControllers([getViewControllerAtIndex(0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: ViewController = viewController as! ViewController
        
        var index = pageContent.pageIndex
        
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: ViewController = viewController as! ViewController
        
        var index = pageContent.pageIndex
        
        if (index == NSNotFound)
        {
            return nil;
        }
        
        index += 1;
        if (index == arrPageTitle.count)
        {
            return nil;
        }
        return getViewControllerAtIndex(index)
    }
    
    // MARK:- Other Methods
    func getViewControllerAtIndex(_ index: NSInteger) -> ViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        pageContentViewController.strTitle = "\(arrPageTitle[index])"
        pageContentViewController.strPhotoName = "\(arrPagePhoto[index])"
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }

}
