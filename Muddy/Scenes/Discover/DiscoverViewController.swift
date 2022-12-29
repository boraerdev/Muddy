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
    private lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.size.width, height: view.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
        collection.showsHorizontalScrollIndicator = false
        //collection.isScrollEnabled = false
        collection.isPagingEnabled = true
        return collection
    }()
    
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
            view1(color: .red, supView: container),
            view1(color: .black, supView: container),
            view1(color: .orange, supView: container),
            spacing: 0
        )
        
        
    }
    @objc func didTapScroll() {
        print("a")
        mainCollectionView.scrollToItem(at: .init(item: 1, section: 0), at: .centeredVertically, animated: true)
    }
    
    private func view1(color: UIColor, supView: UIView) -> UIView {
        let container = UIView(backgroundColor: color)
        let guide = view.safeAreaLayoutGuide
        
        return container.withSize(.init(width: view.frame.size.width, height: guide.layoutFrame.height - (tabBarController?.tabBar.frame.height ?? 0)))
    }
    
    private func prepareMainContainer() -> UIView {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
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
}

extension DiscoverViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = indexPath.row % 2 == 0 ? .red:.yellow
        return cell
    }
    
    
}
