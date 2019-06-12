# SBPhotoSlider

This is an implementation of a photo slider component for iOS written in Swift 4.0. 
It features both manual and automatic transition of view controllers.

# Requirements

* iOS 8.0+
* XCode 9.0+
* Swift 4.2

# Installation

#### Manual

The files needed to be included are in the **PhotoSlider** subfolder of this project.

# Setup

1. Declare photo slider manager class variable :

        var  photoSliderManager :SBPhotoSliderManager?

2. Set photo slider manager class delegate

        photoSliderManager = SBPhotoSliderManager(delegate: self)

3. Implement delegate of photo slider manager

        extension ViewController: SBPhotoSliderManagerDelegate {
        func photoSliderManager(_ photoSliderManager: SBPhotoSliderManager, didCreatePageViewController viewController:     UIPageViewController) {
    
   4. Create page view controller instance and add it in view
   
             let pageViewController = viewController
             self.addChild(pageViewController)
             pageViewController.view.frame = self.view.frame
            self.view.addSubview(pageViewController.view)
            self.bringSubViewsToFront()
    }
    
        func photoSliderManager(_ photoSliderManager: SBPhotoSliderManager, didFinishAnimatingPageViewController viewController: UIPageViewController, withCurrentIndex currentIndex: Int) {

5. set page index for page control

        self.aPageControl.currentPage = currentIndex
        self.aMessageLabel.text = photoSliderManager.displayMessageAtIndex(currentIndex)
         }
        }


