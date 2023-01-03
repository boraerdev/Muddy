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
    func displayGenres(viewModel: Explore.FetchGenres.ViewModel)
}

class ExploreViewController: UIViewController, ExploreDisplayLogic {
    
    var interactor: ExploreBusinessLogic?
    var router: (NSObjectProtocol & ExploreRoutingLogic & ExploreDataPassing)?
    
    //MARK: Def
    var discoverMovies: [Result] = []
    var genres: [Genre] = []
    var lastSelectedGenreIndexPath: IndexPath?
    
    //MARK: UI Components
    private lazy var moviesCollectionView: UICollectionView = {
        let slantedLayout = CollectionViewSlantedLayout()
        slantedLayout.slantingSize = 60
        slantedLayout.isFirstCellExcluded = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: slantedLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return cv
    }()
    
    private lazy var sliderMenuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let vc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vc.delegate = self
        vc.showsHorizontalScrollIndicator = false
        vc.dataSource = self
        vc.backgroundColor = .clear
        vc.register(SliderMenuCell.self, forCellWithReuseIdentifier: SliderMenuCell.identifier)
        return vc
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
            padding: 10,
            cornerRadius: 0,
            backgroundColor: .clear,
            isSecureTextEntry: false)
        field.delegate = self
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
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
        fetchGenres()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        moviesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: Fetch
    private func fetchDiscover() {
        let request = Explore.FetchDiscover.Request(params: "&sort_by=revenue.desc")
        Task { await interactor?.fetchDiscover(request:request) }
    }
    
    private func fetchGenreMovies(params: String) {
        let request = Explore.FetchDiscover.Request(params: params)
        Task { await interactor?.fetchDiscover(request:request)}
    }
    
    private func fetchSearch() {
        let text = searchField.text!
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        let request = Explore.FetchSearch.Request(query: text)
        Task { await interactor?.fetchSearch(request:request)}
    }
    
    private func fetchGenres() {
        let request = Explore.FetchGenres.Request()
        Task { await interactor?.fetchGenres(request:request)}
    }
    
}

// MARK: Display
extension ExploreViewController {
    func displayDiscover(viewModel: Explore.FetchDiscover.ViewModel) {
        discoverMovies = viewModel.moviesList
        DispatchQueue.main.async { [unowned self] in
            moviesCollectionView.reloadData()
        }
    }
    
    func displaySearcg(viewModel: Explore.FetchSearch.ViewModel) {
        discoverMovies = viewModel.moviesList
        DispatchQueue.main.async { [unowned self] in
            showNoResultLabel(viewModel.moviesList.isEmpty ? true : false)
            moviesCollectionView.reloadData()
        }
    }
    
    func displayGenres(viewModel: Explore.FetchGenres.ViewModel) {
        genres = viewModel.genres
        DispatchQueue.main.async { [unowned self] in
            sliderMenuCollectionView.reloadData()
        }
    }

}

// MARK: Update UI
extension ExploreViewController {
    private func showNoResultLabel(_ bool: Bool) {
        DispatchQueue.main.async(group: nil, qos: .userInteractive, flags: .enforceQoS) {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) { [unowned self] in
                noResultLabel.isHidden = !bool
            }
        }
    }
    
    private func showClearBtn(_ bool: Bool) {
        DispatchQueue.main.async {  [unowned self] in
            clearBtn.isHidden = !bool
        }
    }
}

// MARK: UI Funcs
extension ExploreViewController {
    private func setupUI() {
        let _ = header()
        let container = mainContainer()
        view.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0.15), endPoint: .init(x: 0.5, y: 0.3))
        prepareGenreCollectionView()
        
        container.stack(
            moviesCollectionView
        )
        
    }
    
    private func header() -> UIView {
        let container = UIView()
        view.addSubview(container)
        container.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        container.withHeight(40)
        
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
        container.anchor(
            top: header().bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.safeAreaLayoutGuide.bottomAnchor,
            trailing: view.trailingAnchor)
        return container
    }
    
    private func prepareGenreCollectionView() {
        view.addSubview(sliderMenuCollectionView)
        sliderMenuCollectionView.withHeight(40)
        sliderMenuCollectionView.anchor(
            top: header().bottomAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: view.trailingAnchor,
            padding: .init(top: 5, left: 0, bottom: 0, right: 0))
    }
    
}

//MARK: Funcs
extension ExploreViewController {
    private func updateSelectedGenreBorder(_ indexPath: IndexPath, _ collectionView: UICollectionView) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) { [weak self] in
            collectionView.cellForItem(at: indexPath)?.withBorder(width: 1, color: .white)
            if let last = self?.lastSelectedGenreIndexPath {
                collectionView.cellForItem(at: last)?.withBorder(width: 1, color:.systemGray5 )
            }
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case moviesCollectionView:
            return discoverMovies.count
        case sliderMenuCollectionView:
            return genres.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case moviesCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {return .init()}
            cell.configure(movie: discoverMovies[indexPath.row])
            
            if let _ = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
                cell.contentView.transform = CGAffineTransform(rotationAngle: 75)
            }
            
            return cell
        case sliderMenuCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderMenuCell.identifier, for: indexPath) as? SliderMenuCell else {return .init()}
            cell.configure(genres[indexPath.item].name.orNil)
            return cell
        default:
            return .init()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard !genres.isEmpty else {return .init(width: 0, height: 0)}
        if collectionView == sliderMenuCollectionView {
            let estimatedCell = SliderMenuCell(frame: .init(x: 0, y: 0, width: 1000, height: 40))
            estimatedCell.configure(genres[indexPath.row].name.orNil)
            estimatedCell.layoutIfNeeded()
            let estimatedSizeCell = estimatedCell.systemLayoutSizeFitting(.init(width: 1000, height: 40))
            return .init(width: estimatedSizeCell.width, height: 40)
        }
        return .init(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case sliderMenuCollectionView:
            return .init(top: 0, left: 16, bottom: 0, right: 16)
        default:
            return .init()
        }
    }
    
}


extension ExploreViewController: CollectionViewDelegateSlantedLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: CollectionViewSlantedLayout, sizeForItemAt indexPath: IndexPath) -> CGFloat {
        225
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case sliderMenuCollectionView:
            discoverMovies.removeAll(keepingCapacity: false)
            fetchGenreMovies(params: "&with_genres=\(genres[indexPath.row].id ?? 1)")
            updateSelectedGenreBorder(indexPath,collectionView)
            lastSelectedGenreIndexPath = indexPath
        case moviesCollectionView:
            interactor?.setSelectedMovie(discoverMovies[indexPath.row])
            router?.routeToDetail(target: MovieDetailViewController())
        default:
            break
        }
    }
}

extension ExploreViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionView = moviesCollectionView
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
        discoverMovies.removeAll(keepingCapacity: false)
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
