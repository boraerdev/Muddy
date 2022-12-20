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
        .init(title: "Feed", controller: HomeViewController(), systemImageName: "film.stack"),
        .init(title: "Discover", controller: DiscoverViewController(), systemImageName: "bolt.horizontal"),
        .init(title: "Profile", controller: ProfileViewController(), systemImageName: "person")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = createViewControllers()
        bottomLineColor = .white
    }
    
    private func createViewControllers() -> [UIViewController] {
        var vcs: [UIViewController] = []
        tabItemModels.enumerated().forEach { index, model in
            let vc = UINavigationController(rootViewController: model.controller)
            let item: RAMAnimatedTabBarItem = .init(title: model.title, image: .init(systemName: model.systemImageName), tag: index)
            item.animation = RAMFumeAnimation()
            if index != tabBar.selectedItem?.tag {
                item.textColor = .systemGray
                item.iconColor = .systemGray
            }
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
