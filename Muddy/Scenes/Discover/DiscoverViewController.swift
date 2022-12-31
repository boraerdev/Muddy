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
    
    private lazy var bg = bgView()
    
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
//            topView(),
//            topView()
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
    
    private func topView() -> UIView {
        let container = createContainer()
        
        let cona = UIView()
        let a = UIView(backgroundColor: .red)
        a.transform = .init(rotationAngle: -Double.pi/20)
        
        cona.stack(
            a,
            a,
            UIView(backgroundColor: .yellow),
            spacing: 10,
            distribution: .fillEqually
        )
        
        cona.clipsToBounds = true
        
        container.stack(
            cona.withHeight(500),
            UIView()
        )
        
        return container
    }
}

final class bgView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let container = UIView()
        let reds = UIView()
        let blues = UIView()
        let greens = UIView()
        addSubview(container)
        container.fillSuperview()
        reds.addSubview(c1)
        reds.addSubview(c2)
        reds.addSubview(c3)
        blues.addSubview(c1blue)
        blues.addSubview(c2blue)
        blues.addSubview(c3blue)
        greens.addSubview(c1green)
        greens.addSubview(c2green)
        greens.addSubview(c3green)
        addSubview(greens)
        addSubview(reds)
        addSubview(blues)
        
        
        [c1,c2,c3,c1blue,c2blue,c3blue,c1green,c2green,c3green, reds,blues, greens].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false
        }

        reds.anchor(.top(topAnchor), .leading(leadingAnchor, constant: -20))
        NSLayoutConstraint.activate([
            
            c1.centerXAnchor.constraint(equalTo: reds.centerXAnchor),
            c1.centerYAnchor.constraint(equalTo: reds.centerYAnchor),

            
            c2.centerXAnchor.constraint(equalTo: reds.centerXAnchor),
            c2.centerYAnchor.constraint(equalTo: reds.centerYAnchor),
            
            c3.centerXAnchor.constraint(equalTo: reds.centerXAnchor),
            c3.centerYAnchor.constraint(equalTo: reds.centerYAnchor)
        ])
        
        blues.anchor(.trailing(trailingAnchor,constant: -50), .bottom(bottomAnchor,constant: -100))
        NSLayoutConstraint.activate([
            
            c1blue.centerXAnchor.constraint(equalTo: blues.centerXAnchor),
            c1blue.centerYAnchor.constraint(equalTo: blues.centerYAnchor),

            
            c2blue.centerXAnchor.constraint(equalTo: blues.centerXAnchor),
            c2blue.centerYAnchor.constraint(equalTo: blues.centerYAnchor),
            
            c3blue.centerXAnchor.constraint(equalTo: blues.centerXAnchor),
            c3blue.centerYAnchor.constraint(equalTo: blues.centerYAnchor)
        ])
        
        greens.anchor(.trailing(trailingAnchor))
        NSLayoutConstraint.activate([
            
            c1green.centerXAnchor.constraint(equalTo: greens.centerXAnchor),
            c1green.centerYAnchor.constraint(equalTo: greens.centerYAnchor),

            
            c2green.centerXAnchor.constraint(equalTo: greens.centerXAnchor),
            c2green.centerYAnchor.constraint(equalTo: greens.centerYAnchor),
            
            c3green.centerXAnchor.constraint(equalTo: greens.centerXAnchor),
            c3green.centerYAnchor.constraint(equalTo: greens.centerYAnchor)
        ])
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [unowned self] timer in
            makeAnimation(for: reds)
            makeAnimation(for: blues)
            makeAnimation(for: greens)
        }
        
        
        addSubview(blur)
        addSubview(dark)
        dark.fillSuperview()
        blur.layer.opacity = 1
        blur.fillSuperview()
    }
    
    private func makeAnimation(for view: UIView)  {
        let randomY = Int(arc4random() % (UInt32(frame.height)+1))
        let randomX = Int(arc4random() % (UInt32(frame.width)+1))
        
        let newX = randomX - Int(view.frame.width) / 2
        let newY = randomY - Int(view.frame.height) / 2
        
            DispatchQueue.main.async {
                UIView.animate(withDuration: 2, delay: 0) {
                    view.frame = .init(x: CGFloat(newX) , y: CGFloat(newY), width: view.frame.width, height: view.frame.height)
                }
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let dark = UIView(backgroundColor: .black.withAlphaComponent(0.5))
    var blur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    var  c1 = drawCircle(size: 350, color: .red.withAlphaComponent(0.2))
    var  c2 = drawCircle(size: 250, color: .red.withAlphaComponent(0.25))
    var  c3 = drawCircle(size: 150, color: .red.withAlphaComponent(0.3))
    
    var  c1blue = drawCircle(size: 350, color: .blue.withAlphaComponent(0.2))
    var  c2blue = drawCircle(size: 250, color: .blue.withAlphaComponent(0.25))
    var  c3blue = drawCircle(size: 150, color: .blue.withAlphaComponent(0.3))
    
    var  c1green = drawCircle(size: 350, color: .purple.withAlphaComponent(0.2))
    var  c2green = drawCircle(size: 250, color: .purple.withAlphaComponent(0.25))
    var  c3green = drawCircle(size: 150, color: .purple.withAlphaComponent(0.3))

    
}

func drawCircle(size: CGFloat, color: UIColor) -> UIView {
  let circleView = UIView()
  let circlePath = UIBezierPath(arcCenter: CGPoint(x: size / 2, y: size / 2), radius: size / 2, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)

  let shapeLayer = CAShapeLayer()
  shapeLayer.path = circlePath.cgPath
  shapeLayer.fillColor = color.cgColor
    shapeLayer.strokeColor = UIColor.red.cgColor
  shapeLayer.lineWidth = 0

  circleView.layer.addSublayer(shapeLayer)
    circleView.frame = .zero
    circleView.withSize(.init(width: size, height: size))
  return circleView
}
