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
    func displayMovies(viewModel: Discover.FetchMovies.ViewModel)
}

final class DiscoverViewController: UIViewController, DiscoverDisplayLogic {
    
    var interactor: DiscoverBusinessLogic?
    var router: (NSObjectProtocol & DiscoverRoutingLogic & DiscoverDataPassing)?
    
    // MARK: Def
    private var timer: Timer!
    var movies: [Result] = []
    
    // MARK: UI Components
    let scroll = UIScrollView()

    private lazy var moviesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.size.width - 32 - 20)/3
        layout.itemSize = .init(width: width, height: width*1.48)
        layout.minimumInteritemSpacing = 10
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .clear
        collection.isHidden = true
        collection.register(DiscoverMoviesCollectionViewCell.self, forCellWithReuseIdentifier: DiscoverMoviesCollectionViewCell.identifier)
        return collection
    }()
    
    private lazy var bg = AnimatedBgView()
    
    private lazy var textField: IndentedTextField = {
        let field = IndentedTextField(
            placeholder: "What are you in the mood for? Comedy, drama, action, romance?",
            padding: 10,
            cornerRadius: 8,
            keyboardType: .default,
            backgroundColor: .systemGray5.withAlphaComponent(0.5),
            isSecureTextEntry: false
        )
        field.delegate = self
        return field
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
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    // MARK: Fetch
    func fetchMovies(for text: String) {
        let request = Discover.FetchMovies.Request(text: text)
        Task {await interactor?.fetchMovies(request:request)}
    }
    
    // MARK: Display
    func displayMovies(viewModel: Discover.FetchMovies.ViewModel) {
        movies = viewModel.movies
        DispatchQueue.main.async { [unowned self] in
            moviesCollection.reloadData()
            
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) { [unowned self] in
                moviesCollection.isHidden = false
            }
        }
        
        
    }

}

//MARK : UI
extension DiscoverViewController {
    
    private func setupUI() {
        
        //BG
        view.addSubview(bg)
        bg.anchor(.top(view.topAnchor), .leading(view.leadingAnchor),.trailing(view.trailingAnchor), .bottom(view.safeAreaLayoutGuide.bottomAnchor))
        
        let container = prepareMainContainer()
        
        //Pages
        container.stack(
            topView(),
            inputView()
        )
        
        //Gradient
        prepareGradient()
        
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
        scroll.delegate = self
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        view.addSubview(scroll)
        scroll.fillSuperviewSafeAreaLayoutGuide()
        return scroll
    }
    
    private func prepareGradient() {
        DispatchQueue.main.async { [unowned self] in
            view.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 1), endPoint: .init(x: 0.5, y: 0.8))
            view.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 0.2))
        }
    }
    
    private func topView() -> UIView {
        
        let container = createContainer()
        
        //Content
        let logo = UIImageView(
            image: .init(named: "logo"), contentMode: .scaleAspectFit)
        let title = UILabel(
            text: "Let's Muddy!", font: .systemFont(ofSize: 34, weight: .semibold), textColor: .white, textAlignment: .center, numberOfLines: 0)
        let overview = UILabel(
            text: "Get personalized movie recommendations based on your mood! Simply describe your current emotional state, and our AI will suggest a selection of films to match. Try it out and find the perfect movie to suit your mood.",
            font: .systemFont(ofSize: 13, weight: .light),
            textColor: .secondaryLabel,
            textAlignment: .center,
            numberOfLines: 0)
        
        //Swpie button
        let swipeBtn = UIImageView(image: .init(systemName: "chevron.down"), contentMode: .scaleAspectFit)
        swipeBtn.withHeight(25)
        swipeBtn.tintColor = .white

        //Swipe circles
        let circle1 = drawCircle(size: 5, color: .white)
        let circle2 = drawCircle(size: 5, color: .secondaryLabel)
        let swipeCircles = UIView()
        swipeCircles.stack(circle1,circle2,swipeBtn, spacing: 5, alignment: .center)
        
        //Layout
        container.stack(
            UIView(),
            logo.withHeight(300),
            UIView(),
            title,
            container.hstack(overview).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16)),
            swipeCircles.withHeight(45),
            spacing: 10
        ).padBottom(50)
        
        //Animation
        shakeImageView(imageView: logo)
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            shakeImageView(imageView: logo)
        }
        
        return container
    }
    
    private func inputView() -> UIView {
        let container = createContainer()
        
        //Swipe btn
        let swipeBtn = UIImageView(image: .init(systemName: "chevron.up"), contentMode: .scaleAspectFit)
        swipeBtn.withHeight(25)
        swipeBtn.tintColor = .white
        
        //Input container
        textField.withBorder(width: 1, color: .systemGray5)
        let micBtn = UIButton(
            image: .init(systemName: "mic.fill")!,
            tintColor: .secondaryLabel,
            target: self,
            action: #selector(didTapMic)
        )
        let inputContainer = UIView()
        inputContainer.hstack(
            textField.withHeight(45), micBtn.withWidth(25), spacing: 10
        ).padLeft(16).padRight(16)
        
        //SwipeCircles
        let circle1 = drawCircle(size: 5, color: .secondaryLabel)
        let circle2 = drawCircle(size: 5, color: .white)
        let swipeCircles = UIView()
        swipeCircles.withHeight(45)
        swipeCircles.stack( swipeBtn, circle1,circle2, spacing: 5, alignment: .center)
        
        //CollectionView
        let collectionView = UIView()
        collectionView.stack(
            moviesCollection
        ).padLeft(16).padRight(16)

        container.stack(
            swipeCircles,
            inputContainer,
            collectionView,
            spacing: 10
        ).padTop(10)
        
        return container
    }
    
}

extension DiscoverViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView {
        case scroll:
            let offsetY = scrollView.contentOffset.y
            guard let tabBarController = tabBarController as? MainTabbarController else {
                return
            }
            
            if offsetY > 150 {
                tabBarController.discoverBtn.isHidden = true
                tabBarController.tabBar.isHidden = true
                tabBarController.tabBar.layer.zPosition = -1
            }
            
            if offsetY < 450 {
                tabBarController.discoverBtn.isHidden = false
                tabBarController.tabBar.isHidden = false
                tabBarController.tabBar.layer.zPosition = 0
            }
        default:
            break
        }
    }
}

extension DiscoverViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverMoviesCollectionViewCell.identifier, for: indexPath) as? DiscoverMoviesCollectionViewCell else {return .init()}
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
    
    
}

extension DiscoverViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != nil, textField.text != "" else {
            return true
        }
        fetchMovies(for: textField.text!)
        return true
    }
}


// MARK: Objc
extension DiscoverViewController {
    @objc func didTapMic() {
        
    }
}
