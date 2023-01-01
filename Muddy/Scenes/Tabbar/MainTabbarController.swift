//
//  MainTabbarController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import UIKit
import LBTATools

class MainTabbarController: UITabBarController  {
    
    public var discoverBtn: UIButton = {
        let btn = UIButton(image: .init(named: "logo")!, action: #selector(didTapMain))
        btn.backgroundColor = .red
        
        btn.tintColor = .white
        btn.layer.cornerRadius = 8
        btn.layer.cornerCurve = .continuous
        return btn
    }()
    @objc func didTapMain() {
        selectedIndex = 2
    }
    
    let tabItemModels: [TabItemModel] = [
        .init(title: "Feed", controller: HomeViewController(), systemImageName: "film.stack"),
        .init(title: "Explore", controller: ExploreViewController(), systemImageName: "magnifyingglass"),
        .init(title: "Discover", controller: DiscoverViewController(), systemImageName: "bolt.horizontal"),
        .init(title: "Contacts", controller: ContactViewController(), systemImageName:  "person.line.dotted.person"),
        .init(title: "Profile", controller: ProfileViewController(), systemImageName: "person")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = createViewControllers()

        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.shadowImage = nil
        tabBar.backgroundImage = nil
        tabBar.backgroundColor = .black

        //Main Button
        view.addSubview(discoverBtn)
        discoverBtn.withSize(.init(width: 60, height: 60))
        discoverBtn.withBorder(width: 2, color: .black)
        discoverBtn.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -30).isActive = true
        discoverBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func createViewControllers() -> [UIViewController] {
        var vcs: [UIViewController] = []
        tabItemModels.enumerated().forEach { index, vc in
            if index != 2 {
                vc.controller.tabBarItem = .init(title: vc.title, image: .init(systemName: vc.systemImageName), tag: index)
            }
            vcs.append(vc.controller)
        }
        return vcs
    }
    
}

struct TabItemModel {
    var title: String
    var controller: UIViewController
    var systemImageName: String
}

