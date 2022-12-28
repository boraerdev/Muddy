//
//  ExploreViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import LBTATools
import CollectionViewSlantedLayout

protocol ExploreDisplayLogic: AnyObject {
    func displayDiscover(viewModel: Explore.FetchDiscover.ViewModel)
    func displaySearcg(viewModel: Explore.FetchSearch.ViewModel)
}

class ExploreViewController: UIViewController, ExploreDisplayLogic {
    
    
    var interactor: ExploreBusinessLogic?
    var router: (NSObjectProtocol & ExploreRoutingLogic & ExploreDataPassing)?
    
    //MARK: Def
    var discoverMovies: [Result] = []
    
    //MARK: UI Components
    private lazy var collectionView: UICollectionView = {
        let slantedLayout = CollectionViewSlantedLayout()
        slantedLayout.slantingSize = 60
        let cv = UICollectionView(frame: .zero, collectionViewLayout: slantedLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return cv
    }()
    
    private lazy var noResultLabel: UILabel = {
      let lbl = UILabel(text: "No Result", textColor: .secondaryLabel, textAlignment: .center)
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var clearBtn: UIButton = {
        let btn = UIButton(image: .init(systemName: "xmark")!, tintColor: .white, target: self, action: #selector(didTapClear))
        btn.isHidden = true
        return btn
    }()
    
    private lazy var searchField: IndentedTextField = {
        let field = IndentedTextField(
            placeholder: "Search Movie, Genre, Actor...",
            padding: 0,
            cornerRadius: 0,
            backgroundColor: .clear,
            isSecureTextEntry: false)
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
        let interactor = ExploreInteractor()
        let presenter = ExplorePresenter()
        let router = ExploreRouter()
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
        fetchDiscover()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Fetch
    private func fetchDiscover() {
        let request = Explore.FetchDiscover.Request()
        Task { await interactor?.fetchDiscover(request:request) }
    }
    
    private func fetchSearch() {
        let text = searchField.text!
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let request = Explore.FetchSearch.Request(query: text)
        Task { await interactor?.fetchSearch(request:request)}
    }
    
    //MARK: Display
    func displayDiscover(viewModel: Explore.FetchDiscover.ViewModel) {
        discoverMovies = viewModel.moviesList
        DispatchQueue.main.async { [unowned self] in
            collectionView.reloadData()
        }
    }
    
    func displaySearcg(viewModel: Explore.FetchSearch.ViewModel) {
        guard !viewModel.moviesList.isEmpty else {
            showNoResultLabel(true)
            return
        }
        discoverMovies = viewModel.moviesList
        DispatchQueue.main.async { [unowned self] in
            showNoResultLabel(false)
            collectionView.reloadData()
        }
    }


}

extension ExploreViewController {
    private func showNoResultLabel(_ bool: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) { [unowned self] in
                noResultLabel.isHidden = !bool
            }
        }
    }
    
    private func showClearBtn(_ bool: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) { [unowned self] in
                clearBtn.isHidden = !bool
            }
        }
    }
}

// MARK: UI Funcs
extension ExploreViewController {
    private func setupUI() {
        let _ = header()
        let container = mainContainer()
        
        container.stack(
            collectionView
        )
        
    }
    
    private func header() -> UIView {
        let container = UIView()
        view.addSubview(container)
        container.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        container.withHeight(60)
        
        container.hstack(
            noResultLabel,
            searchField,
            clearBtn,
             spacing: 10
        ).withMargins(.init(top: 5, left: 16, bottom: 5, right: 16))
        
        return container
    }
    
    private func mainContainer() -> UIView {
        let container = UIView()
        view.addSubview(container)
        container.anchor(top: header().bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        return container
    }
    
}

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        discoverMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {return .init()}
        cell.configure(movie: discoverMovies[indexPath.row])
        
        if let _ = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: 75)
        }
        
        return cell
    }
    
}

extension ExploreViewController: CollectionViewDelegateSlantedLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewSlantedLayout, sizeForItemAt indexPath: IndexPath) -> CGFloat {
        225
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ExploreViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionView = collectionView
        guard let visibleCells = collectionView.visibleCells as? [MovieCollectionViewCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = (collectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight
            let xOffset = (collectionView.contentOffset.x - parallaxCell.frame.origin.x) / parallaxCell.imageWidth
            parallaxCell.offset(CGPoint(x: xOffset * xOffsetSpeed, y: yOffset * yOffsetSpeed))
            
        }
    }
}

extension ExploreViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard textField.text != "" else {
            showClearBtn(true)
            return false
        }
        showClearBtn(true)
        fetchSearch()
        return true
    }
}

//MARK: Objc
extension ExploreViewController {
    @objc func didTapClear() {
        fetchDiscover()
        searchField.text = nil
        showClearBtn(false)
        showNoResultLabel(false)
    }
}
