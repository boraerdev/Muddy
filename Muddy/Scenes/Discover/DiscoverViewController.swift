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

final class DiscoverViewController: UIViewController, DiscoverDisplayLogic {
    var interactor: DiscoverBusinessLogic?
    var router: (NSObjectProtocol & DiscoverRoutingLogic & DiscoverDataPassing)?
    
    // MARK: Def
    private var timer: Timer!
    
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
    
    private lazy var bg = AnimatedBgView()
    
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
        view.addSubview(bg)
        bg.fillSuperview()
        doSomething()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
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
        view.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0.9), endPoint: .init(x: 0.5, y: 0.7))
        view.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 0.3))
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
        let scroll = UIScrollView(backgroundColor: .clear)
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
    
    func shakeLabel(label: UILabel) {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true

        let fromValue = -8
        let toValue = 8

        shake.values = [fromValue, toValue]

        CATransaction.begin()
        label.layer.add(shake, forKey: "shake")
        CATransaction.setCompletionBlock {
            label.transform = CGAffineTransform.identity
        }
        CATransaction.commit()
    }
    
    private func topView() -> UIView {
        let container = createContainer()
        
        let logo = UIImageView(image: .init(named: "logo"), contentMode: .scaleAspectFit)

        let title = UILabel(text: "Welcome to Muddy", font: .systemFont(ofSize: 34, weight: .semibold), textColor: .white, textAlignment: .center, numberOfLines: 0)
        
        let overview = UILabel(
            text: "Get personalized movie recommendations based on your mood! Simply describe your current emotional state, and our AI will suggest a selection of films to match. Try it out and find the perfect movie to suit your mood.",
            font: .systemFont(ofSize: 13, weight: .light),
            textColor: .secondaryLabel,
            textAlignment: .center,
            numberOfLines: 0)
        
        let circle1 = drawCircle(size: 5, color: .white)
        let circle2 = drawCircle(size: 5, color: .secondaryLabel)
        let circle3 = drawCircle(size: 5, color: .secondaryLabel)
        
        let swipeBtn = MainButton(title: "Swipe Down", imgName: "chevron.down", tintColor: .white, backgroundColor: .clear)
        swipeBtn.titleLabel?.font = .systemFont(ofSize: 13, weight: .light)
        
        container.stack(
            UIView(),
            logo.withHeight(300),
            UIView(),
            title,
            container.hstack(overview).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16)),
            swipeBtn,
            container.stack(
                circle1,circle2,circle3, spacing: 5, alignment: .center
            ),
            spacing: 10
        ).padBottom(50)
        
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            shakeImageView(imageView: logo)
        }
        
        return container
    }
    
    
}
