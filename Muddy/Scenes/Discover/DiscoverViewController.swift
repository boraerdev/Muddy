//
//  DiscoverViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import LBTATools

protocol DiscoverDisplayLogic: AnyObject {
    func displaySomething(viewModel: Discover.Something.ViewModel)
}

class DiscoverViewController: UIViewController, DiscoverDisplayLogic {
    var interactor: DiscoverBusinessLogic?
    var router: (NSObjectProtocol & DiscoverRoutingLogic & DiscoverDataPassing)?
    
    // MARK: UI Components
    
    private lazy var backgroundImage = UIImageView(image: .init(named: "collectionBG"), contentMode: .scaleAspectFill)
    
    private lazy var textView: UITextView = {
        let tv = UITextView(backgroundColor: .clear)
        tv.withBorder(width: 1, color: .white)
        tv.layer.cornerRadius = 8
        tv.font = .systemFont(ofSize: 15)
        tv.layer.cornerCurve = .continuous
        tv.backgroundColor = .systemGray5.withAlphaComponent(0.5)
        tv.withBorder(width: 1, color: .systemGray5)
        return tv
    }()
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = DiscoverInteractor()
        let presenter = DiscoverPresenter()
        let router = DiscoverRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        setupUI()
    }
    
    // MARK: Do something
    func doSomething() {
        let request = Discover.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Discover.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

//MARK : UI Funcs
extension DiscoverViewController {
    private func setupUI() {
        let container = prepareMainContainer()
        
        container.stack(
            topView(),
            topView()
        )
        
        
    }
    
    private func createContainer() -> UIView {
        let container = UIView()
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let top    = window?.safeAreaInsets.top ?? 0
        let height = self.tabBarController?.tabBar.frame.height ?? 49.0
        return container.withSize(.init(width: view.frame.size.width, height: view.frame.height - top  - height))
    }
    
    private func prepareMainContainer() -> UIView {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)
        scroll.fillSuperviewSafeAreaLayoutGuide()
        return scroll
    }
    
    private func prepareGradient() {
        DispatchQueue.main.async { [unowned self] in
            backgroundImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0.5), endPoint: .init(x: 0.5, y: 0))
            backgroundImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 0.3))
            
        }
    }
    
    private func topView() -> UIView {
        let container = createContainer()
        
        let cona = UIView()
        
        cona.hstack(
            UIView(backgroundColor: .red),
            UIView(backgroundColor: .blue),
            UIView(backgroundColor: .yellow),
            spacing: 10,
            distribution: .fillEqually
        )
        
        container.stack(
            cona.withHeight(200),
            UIView()
        )
        
        return container
    }
}
