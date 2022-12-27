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
        tv.backgroundColor = .white.withAlphaComponent(0.2)
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
        view.addSubview(backgroundImage)
        backgroundImage.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor)
        prepareGradient()
        
        let container = prepareMainContainer()

        container.stack(
            textInput()
        )
        
        
    }
    
    private func prepareMainContainer() -> UIView {
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.fillSuperviewSafeAreaLayoutGuide()
        return scroll
    }
    
    private func textInput() -> UIView {
        let container = UIView()
        
        lazy var title = UILabel(
            text: "Explain Your Mood",
            font: .systemFont(ofSize: 22, weight: .bold),
            textColor: .white,
            textAlignment: .center,
            numberOfLines: 1)
        
        container.stack(
            title,
            container.hstack(
                textView.withSize(.init(width: view.frame.width - 36, height: 100))
            ).withMargins(.init(top: 0, left: 16, bottom: 00, right: 16))
        )

        
        return container
    }
    
    private func prepareGradient() {
        DispatchQueue.main.async { [unowned self] in
            backgroundImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 1), endPoint: .init(x: 0.5, y: 0))
            backgroundImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 0.3))
            
        }
    }
}
