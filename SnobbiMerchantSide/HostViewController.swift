
//View HostAllViewController of Slide Menu

import UIKit
import InteractiveSideMenu
class HostViewController: MenuContainerViewController {
    
    //MARK- Variable
    
    //MARK- ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let screenSize: CGRect = UIScreen.main.bounds
        self.transitionOptions = TransitionOptions(duration: 0.4, visibleContentWidth: screenSize.width / 6)
        //UpdateDeviceToken
       
        // Instantiate menu view controller by identifier
        self.menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "NavigationMenu") as! MenuViewController
        
        // Gather content items controllers
        self.contentViewControllers = contentControllers()
        
        // Select initial content controller. It's needed even if the first view controller should be selected.
        self.selectContentViewController(contentViewControllers.first!)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /*
         Options to customize menu transition animation.
         */
        var options = TransitionOptions()
        
        // Animation duration
        options.duration = size.width < size.height ? 0.4 : 0.6
        
        // Part of item content remaining visible on right when menu is shown
        options.visibleContentWidth = size.width / 6
        self.transitionOptions = options
    }
    private func contentControllers() -> [UIViewController] {
        //ViewController StoryBoarId array
        let controllersIdentifiers = ["ID_ManageCoupon_VC","ID_ManageMenuVC","ID_SettingVC","ID_ProfileVC"]
        var contentList = [UIViewController]()
        
        /*
         Instantiate items controllers from storyboard.
         */
        for identifier in controllersIdentifiers {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: identifier) {
                contentList.append(viewController)
            }
        }
        
        return contentList
    }
}
