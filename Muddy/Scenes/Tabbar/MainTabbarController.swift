//
//  MainTabbarController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import UIKit
import RAMAnimatedTabBarController

class MainTabbarController: RAMAnimatedTabBarController  {
    
    let tabItemModels: [TabItemModel] = [
        .init(title: "Home", controller: HomeViewController(), systemImageName: "house"),
        .init(title: "Discover", controller: DiscoverViewController(), systemImageName: "wand.and.rays"),
        .init(title: "Profile", controller: ProfileViewController(), systemImageName: "person")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        viewControllers = createViewControllers()
    }
    
    private func createViewControllers() -> [UIViewController] {
        
        var vcs: [UIViewController] = []
        tabitemmode.forEach { i in
            let controller =  ViewController()
            let vc = UINavigationController(rootViewController: controller)
            let item: RAMAnimatedTabBarItem = .init(title: "House", image: .init(systemName: "house"), tag: i)
            item.animation = RAMBounceAnimation()
            vc.tabBarItem = item
            vcs.append(vc)
        }
        return vcs
    }
}

struct TabItemModel {
    var title: String
    var controller: UIViewController
    var systemImageName: String
}
