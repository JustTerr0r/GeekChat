//
//  TabBarController.swift
//  GeekChat
//
//  Created by Stanislav Frolov on 24.04.2021.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let chatVC = ChatViewController()
        let listVC = ListViewController()
        
        let chatImage = UIImage(systemName: "bubble.left")!
        let listImage = UIImage(systemName: "gear")!
        
        
        tabBar.tintColor = UIColor(red: 228/255, green: 34/255, blue: 45/255, alpha: 1) // E4222D
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowOpacity = Float(0.38)
        tabBar.layer.shadowRadius = CGFloat(7)
        
        viewControllers = [
            generateNavigationController(rootViewController: chatVC, title: NSLocalizedString("chats", comment: ""), image: chatImage),
            generateNavigationController(rootViewController: listVC, title: NSLocalizedString("settings", comment: ""), image: listImage)
            
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}

extension UITabBarController {
    func setTabBarHidden(_ isHidden: Bool, animated: Bool, completion: (() -> Void)? = nil ) {
        if (tabBar.isHidden == isHidden) {
            completion?()
        }
        
        if !isHidden {
            tabBar.isHidden = false
        }
        
        let height = tabBar.frame.size.height
        let offsetY = view.frame.height - (isHidden ? 0 : height)
        let duration = (animated ? 0.25 : 0.0)
        
        let frame = CGRect(origin: CGPoint(x: tabBar.frame.minX, y: offsetY), size: tabBar.frame.size)
        UIView.animate(withDuration: duration, animations: {
            self.tabBar.frame = frame
        }) { _ in
            self.tabBar.isHidden = isHidden
            completion?()
        }
    }
}

