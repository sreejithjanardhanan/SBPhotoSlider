/*
 * ViewController.swift
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

class ViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var aMessageLabel: UILabel!
    
    @IBOutlet weak var aLogoLabel: UILabel!
    
    // Page control
    @IBOutlet weak var aPageControl: UIPageControl!
    
    //MARK: - Variables
    
    var  photoSliderManager :SBPhotoSliderManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        photoSliderManager = SBPhotoSliderManager(delegate: self)
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Methods
    
    func bringSubViewsToFront() -> Void {
        self.view.bringSubviewToFront(self.aPageControl)
        self.view.bringSubviewToFront(self.aLogoLabel)
        self.view.bringSubviewToFront(self.aMessageLabel)
    }
}

// MARK: - Photo slider Manager Delegate

extension ViewController: SBPhotoSliderManagerDelegate {
    func photoSliderManager(_ photoSliderManager: SBPhotoSliderManager, didCreatePageViewController viewController: UIPageViewController) {
        let pageViewController = viewController
        self.addChild(pageViewController)
        pageViewController.view.frame = self.view.frame
        self.view.addSubview(pageViewController.view)
        self.bringSubViewsToFront()
    }
    
    func photoSliderManager(_ photoSliderManager: SBPhotoSliderManager, didFinishAnimatingPageViewController viewController: UIPageViewController, withCurrentIndex currentIndex: Int) {
        self.aPageControl.currentPage = currentIndex
        self.aMessageLabel.text = photoSliderManager.displayMessageAtIndex(currentIndex)
    }
}

