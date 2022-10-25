//
//  SparkyTabBarController.swift
//  Sparky-iOS
//
//  Created by SeungMin on 2022/10/25.
//

import UIKit


class SparkyTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    func setupTabBar() {
        tabBar.tintColor = .sparkyBlack
        tabBar.unselectedItemTintColor = .gray400
        tabBar.isTranslucent = false
        
        view.backgroundColor = .white
        delegate = self
        
        self.viewControllers = [
            createTabBarItem(image: "home", viewController: HomeVC()),
            createTabBarItem(image: "folder", viewController: MyScrapVC()),
        ]
    }
    
//    func setupStatusBarBackgroundView(statusBarHeight: CGFloat) {
//        let statusBarBackgroundView = UIView()
//        statusBarBackgroundView.backgroundColor = .white
//        statusBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(statusBarBackgroundView)
//        statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        statusBarBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        statusBarBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        statusBarBackgroundView.heightAnchor.constraint(equalToConstant: statusBarHeight).isActive = true
//    }
    
    func createTabBarItem(
        image: String,
        viewController: UIViewController
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: image)!
        
        navigationController.view.backgroundColor = .background
//        navigationController.navigationBar.shadowImage?.withTintColor(.sparkyOrange)
//        navigationController.navigationBar.backgoun
//        navigationController.navigationBar.backgroundColor = .white
//        navigationController.navigationBar.tintColor = .lightGray
//        navigationController.navigationBar.barTintColor = .white
//        navigationController.navigationBar.setBackgroundImage(UIImage(named: "vector")!, for: .default)
//        navigationController.navigationBar.shadowImage = UIImage()
//        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
}

extension SparkyTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTabBarTransition(viewControllers: tabBarController.viewControllers)
    }
}

class CustomTabBarTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.3
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromViewController.view,
            let fromIndex = getIndex(fromViewController: fromViewController),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toViewController.view,
            let toIndex = getIndex(fromViewController: toViewController) else {
                transitionContext.completeTransition(false)
                return
            }
        
        let frame = transitionContext.initialFrame(for: fromViewController)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(
                withDuration: self.transitionDuration,
                animations: {
                    fromView.frame = fromFrameEnd
                    toView.frame = frame
                },
                completion: { success in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(success)
                }
            )
        }
    }
    
    func getIndex(fromViewController viewController: UIViewController) -> Int? {
        guard let viewControllers = self.viewControllers else { return nil }
        for (index, thisViewController) in viewControllers.enumerated() {
            if thisViewController == viewController { return index }
        }
        return nil
    }
}
