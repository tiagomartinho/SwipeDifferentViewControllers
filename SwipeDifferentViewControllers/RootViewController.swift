import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let vcStoryboardAndRestorationId = ["FirstViewController","SecondViewController","ThirdViewController"]
    
    let startingViewControllerIndex = 1
    
    var pageViewController: UIPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initPageViewController()
    }
    
    func initPageViewController() {
        self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController!.delegate = self
        let startingViewController = self.viewControllerAtIndex(startingViewControllerIndex, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: {done in })
        self.pageViewController!.dataSource = self
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.view.frame = self.view.bounds
        self.pageViewController!.didMoveToParentViewController(self)
        self.view.gestureRecognizers = self.pageViewController!.gestureRecognizers
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController? {
        if index >= self.vcStoryboardAndRestorationId.count {
            return nil
        }
        return storyboard.instantiateViewControllerWithIdentifier(vcStoryboardAndRestorationId[index]) as? UIViewController
    }
    
    func indexOfViewController(viewController: UIViewController) -> Int {
        var i = 0
        for id in vcStoryboardAndRestorationId {
            if id == viewController.restorationIdentifier {
                return i
            }
            i+=1
        }
        return  NSNotFound
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController)
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index == self.vcStoryboardAndRestorationId.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
}

