//
//  MovieDetailViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MovieDetailDisplayLogic: AnyObject {
    func displaySomething(viewModel: MovieDetail.Something.ViewModel)
}

class MovieDetailViewController: UIViewController, MovieDetailDisplayLogic {
    var interactor: MovieDetailBusinessLogic?
    var router: (NSObjectProtocol & MovieDetailRoutingLogic & MovieDetailDataPassing)?
    
    //UI
    private lazy var movieBackgropImage: UIImageView = {
        let view = UIImageView(image: nil, contentMode: .scaleAspectFill)
        view.contentMode = .scaleAspectFill
        
        return view
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
    
    private var headerContainer: UIView?
    private var mainContainer: UIView?
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter()
        let router = MovieDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        doSomething()
        fetchMovieImage()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async { [unowned self] in
            movieBackgropImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 1), endPoint: .init(x: 0.5, y: 0.5))
            movieBackgropImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 0.5))
        }
    }
    
    // MARK: Do something
    func doSomething() {
        let request = MovieDetail.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: MovieDetail.Something.ViewModel) {
        //nameTextField.text = viewModel.name
    }
}

extension MovieDetailViewController {
    private func setupUI() {
        view.backgroundColor = .black
        headerContainer = prepareHeader()
        mainContainer = prepareMainContainer()

        mainContainer?.stack(
            movieHeader().withWidth(view.frame.width)
        )
        
        
    }
    
    @objc func didTapBack() {
        dismiss(animated: true)
    }
    
    private func fetchMovieImage() {
        guard let url = URL(string: APIEndpoint.Image.mediumBackdropImage(path: router?.dataStore?.selectedMovie.backdropPath ?? "").toString) else {
            return
        }
        movieBackgropImage.kf.setImage(with: url)
    }
    
    private func prepareHeader() -> UIView{
        let safeAreaContainer = UIView()
        let container = UIView()
        let padding: CGFloat = 50
        
        view.addSubview(safeAreaContainer)
        safeAreaContainer.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.topAnchor,
            trailing: view.trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: -padding, right: 0)
        )
        safeAreaContainer.addSubview(container)
        container.fillSuperviewSafeAreaLayoutGuide()
        
        let backBtn = UIButton(
            image: .init(systemName: "chevron.down")!,
            tintColor: .white,
            target: self,
            action: #selector(didTapBack)
        )
        backBtn.imageView?.contentMode = .scaleAspectFit
        container.hstack(
            backBtn.withWidth(25),
            UIView()
        ).withMargins(.allSides(16))
        
        let titleLabel = UILabel(text: router?.dataStore?.selectedMovie.title,font: .systemFont(ofSize: 17, weight: .bold), textColor: .white)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        return safeAreaContainer
    }
    
    private func prepareMainContainer() -> UIView {
        let container = UIView()
        view.addSubview(container)
        container.anchor(top: headerContainer?.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        let scroll = UIScrollView()
        scroll.contentSize = .init(width: view.frame.width, height: 100)
        scroll.clipsToBounds = true
        container.addSubview(scroll)
        scroll.fillSuperview()
        return scroll
    }
    
    private func movieHeader() -> UIView {
        let container = UIView()
        container.stack(movieBackgropImage)
        return container.withHeight(400)
    }
    
}
