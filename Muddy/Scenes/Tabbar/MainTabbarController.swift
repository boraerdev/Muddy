//
//  MainTabbarController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//

import UIKit
import LBTATools

class MainTabbarController: UITabBarController  {
    
    private lazy var discoverBtn: UIButton = {
        let btn = UIButton(image: .init(systemName: "bolt.horizontal")!, action: #selector(didTapMain))
        btn.backgroundColor = .red
        btn.tintColor = .white
        btn.layer.cornerRadius = 8
        btn.layer.cornerCurve = .continuous
        return btn
    }()
    @objc func didTapMain() {
        selectedIndex = 1
    }
    
    let tabItemModels: [TabItemModel] = [
        .init(title: "Feed", controller: HomeViewController(), systemImageName: "film.stack"),
        .init(title: "Discover", controller: DiscoverViewController(), systemImageName: "bolt.horizontal"),
        .init(title: "Profile", controller: ProfileViewController(), systemImageName: "person")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = createViewControllers()

        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.shadowImage = nil
        tabBar.backgroundImage = nil
        
        //makeTabBar()
        
        //Main Button
        view.addSubview(discoverBtn)
        discoverBtn.withSize(.init(width: 60, height: 45))
        discoverBtn.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -30).isActive = true
        discoverBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func makeTabBar() {
        let tabHeight: CGFloat = 85
        let bgView = UIView(backgroundColor: .clear)
        let gradientLayer = CAGradientLayer()
        view.addSubview(bgView)
        bgView.frame = .init(x: 0, y: view.frame.size.height - tabHeight, width: view.frame.width, height: tabHeight)
        
        gradientLayer.frame = bgView.bounds
        
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = .init(x: 0.5, y: 1)
        gradientLayer.endPoint = .init(x: 0.5, y: 0)
        
        bgView.layer.addSublayer(gradientLayer)
        
        view.bringSubviewToFront(tabBar)
    }
    
    private func createViewControllers() -> [UIViewController] {
        var vcs: [UIViewController] = []
        tabItemModels.enumerated().forEach { index, vc in
            if index != 1 {
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

