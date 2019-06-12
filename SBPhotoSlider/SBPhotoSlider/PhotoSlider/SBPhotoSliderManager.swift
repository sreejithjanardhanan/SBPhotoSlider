/*
 * SBPhotoSliderManager.swift
 * SBPhotoSlider
 *
 * Created by Sreejith Bhatt on 11/06/19.
 * Copyright © 2019 SB Studios. All rights reserved.
 * http://www.sreejithbhatt.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

// MARK: - Protocol

protocol SBPhotoSliderManagerDelegate : class {
    
    // Called after page view controller is created
    func photoSliderManager(_ photoSliderManager:SBPhotoSliderManager, didCreatePageViewController viewController:UIPageViewController)
    
    // Called after page view controller did finish animating
    func photoSliderManager(_ photoSliderManager:SBPhotoSliderManager, didFinishAnimatingPageViewController viewController:UIPageViewController, withCurrentIndex currentIndex:Int)
}

class SBPhotoSliderManager: NSObject {
    
    //MARK: - Variables
    
    var pageViewController: UIPageViewController?
    
    weak  var photoSliderManagerDelegate: SBPhotoSliderManagerDelegate?
    
    var contentController : SBPhotoSliderViewController?
    
    var pendingIndex:Int?
    
    var splashTimer : Timer?
    
    var images = ["PhotoSlider - Background First Image", "PhotoSlider - Background Second Image", "PhotoSlider - Background Third Image"]
    
    var messages = ["First Photo", "Second Photo", "Third Photo"]
    
    //MARK: - Constructors
    
    override init() {
        super.init()
    }
    
    
    init(delegate:Any) {
        super.init()
        self.photoSliderManagerDelegate = delegate as? SBPhotoSliderManagerDelegate
        self.createPageViewController()
    }
    
    //MARK: - Methods
    
    func displayMessageAtIndex(_ index:Int) -> String {
        return messages[index]
    }
    
    func createPageViewController() -> Void {
        
        let storyboard = UIStoryboard(name: "PhotoSlider", bundle: nil)
        let pageController = storyboard.instantiateViewController(withIdentifier: "pageVC") as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        pendingIndex = 0
        
        if (images.count > 0) {
            contentController = getContentViewController(withIndex: 0)
            let contentControllers = [contentController]
            
            pageController.setViewControllers(contentControllers as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated:true, completion: nil)
            self.startTimer(pageController, AndContentViewController: contentController!)
        }
        pageViewController = pageController
        self.photoSliderManagerDelegate?.photoSliderManager(self, didCreatePageViewController: pageController)
    }
    
    
    func getContentViewController(withIndex index:Int) -> SBPhotoSliderViewController? {
        if index < images.count  {
            let storyboard = UIStoryboard(name: "PhotoSlider", bundle: nil)
            let contentVC = storyboard.instantiateViewController(withIdentifier: "contentVC") as! SBPhotoSliderViewController
            contentVC.itemIndex = index
            contentVC.imageName = images[index]
            return contentVC
        }
        return nil
    }
    
    func startTimer(_ pageController:UIPageViewController,AndContentViewController contentController:SBPhotoSliderViewController){
        splashTimer =  Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            
            if (self.pendingIndex! < self.images.count-1) {
                self.pendingIndex = self.pendingIndex! + 1
                let contentController = self.getContentViewController(withIndex:(contentController.itemIndex)+self.pendingIndex!)
                let contentControllers = [contentController]
                pageController.setViewControllers(contentControllers as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated:true, completion: nil)
                let currentIndex = self.pendingIndex
                if let index = currentIndex {
                    self.photoSliderManagerDelegate?.photoSliderManager(self, didFinishAnimatingPageViewController: self.pageViewController!, withCurrentIndex:index)
                }
            } else {
                self.pendingIndex = 0
                let contentController = self.getContentViewController(withIndex:self.pendingIndex!)
                let contentControllers = [contentController]
                pageController.setViewControllers(contentControllers as? [UIViewController], direction: UIPageViewController.NavigationDirection.forward, animated:true, completion: nil)
                let currentIndex = self.pendingIndex
                if let index = currentIndex {
                    self.photoSliderManagerDelegate?.photoSliderManager(self, didFinishAnimatingPageViewController: self.pageViewController!, withCurrentIndex:index)
                }
            }
        }
    }
    
    func stopTimer(){
        splashTimer?.invalidate()
        self.startTimer(pageViewController!, AndContentViewController: contentController!)
    }
}

//MARK: - UIPageViewControllerDataSource

extension SBPhotoSliderManager : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        self.stopTimer()
        let contentVC = viewController as! SBPhotoSliderViewController
        if contentVC.itemIndex > 0  {
            return getContentViewController(withIndex: contentVC.itemIndex-1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        self.stopTimer()
        let contentVC = viewController as! SBPhotoSliderViewController
        if contentVC.itemIndex+1 < images.count  {
            return getContentViewController(withIndex: contentVC.itemIndex+1)
        }
        return nil
    }
}

//MARK: - UIPageViewControllerDelegate

extension SBPhotoSliderManager: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = (pendingViewControllers.first as! SBPhotoSliderViewController).itemIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentIndex = pendingIndex
            if let index = currentIndex {
                self.photoSliderManagerDelegate?.photoSliderManager(self, didFinishAnimatingPageViewController: pageViewController, withCurrentIndex:index)
            }
        }
    }
}
