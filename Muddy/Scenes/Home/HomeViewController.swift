//
//  HomeViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import LBTATools

protocol HomeDisplayLogic: AnyObject {
    func displayMovies(viewModel: Home.HomeMovies.ViewModel)
}

//TODO: Refactor UI codes like ExploreViewController.swift
final class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    //MARK: UI Components
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
    
    private lazy var searchField: IndentedTextField = {
       let field = IndentedTextField(
        placeholder: "Search Movie, Genre, Actor...",
        padding: 10,
        cornerRadius: 20,
        keyboardType: .default,
        backgroundColor: .clear,
        isSecureTextEntry: false
       )
        field.addTarget(self, action: #selector(didTapSearch), for: .touchDown)
        return field
    }()
    
    private lazy var homeCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        cv.delegate = self
        cv.dataSource = self
        cv.register(HomeGenderListCell.self, forCellWithReuseIdentifier: HomeGenderListCell.identifier)
        cv.register(MainHomeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHomeHeaderReusableView.identifier)
        cv.register(GenreHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GenreHeaderCollectionReusableView.identifier)
        cv.clipsToBounds = false
        cv.layer.masksToBounds = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    //DEF
    lazy var movies: [MovieGender : [Result]] = [.popular:[MockData.Result]] {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                setupUI(resultMovies: self.movies)
                homeCollectionView.reloadData()
                sliderMenuCollectionView.reloadData()
            }
        }
    }
    
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
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
        fetchMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: Fetch
    func fetchMovies() {
        let request = Home.HomeMovies.Request()
        Task { await interactor?.fetchHomeMovies(request: request) }
    }
    
}

//MARK: Display Funcs
extension HomeViewController: HomeDisplayLogic {
    func displayMovies(viewModel: Home.HomeMovies.ViewModel) {

        var list: [MovieGender: [Result]] = [:]
        list[.popular] = viewModel.popularMovies?.results
        list[.nowPlaying] = viewModel.nowPlayingMovies?.results
        list[.trendsToday] = viewModel.topRatedMovies?.results
        list[.upcoming] = viewModel.upcomingMovies?.results
        movies = list
    }
}

extension HomeViewController {
    @objc func didTapSearch() {
        tabBarController?.selectedIndex = 1
    }
}

//MARK: UI Funcs
extension HomeViewController {
    
    private func setupUI(resultMovies: [MovieGender:[Result]]) {

        view.stack(
            homeCollectionView
        )
        
        view.insertGradient(colors: [.black,.clear], startPoint: .init(x: 0.5, y: 0.15), endPoint: .init(x: 0.5, y: 0.35))
        topNavigaion()
    }
    
    private func topNavigaion() {
        DispatchQueue.main.async { [unowned self] in
            let container = UIView()
            
            let searchBtn = UIButton(
                image: .init(systemName: "magnifyingglass")!,
                tintColor: .white,
                target: self,
                action: #selector(didTapSearch)
            )
            
            //Layout Header Container
            view.addSubview(container)
            container.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                bottom: nil,
                trailing: view.trailingAnchor,
                size: .init(width: view.frame.width, height: 85)
            )

            let searchContainer = UIView(backgroundColor: .clear)
            searchContainer.hstack(
                searchField,
                searchBtn.withWidth(25),
                spacing: 10,
                distribution: .fill
            ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
            
            
            container.stack(
                searchContainer,
                sliderMenuCollectionView,
                spacing: 5,
                distribution: .fillEqually
            )
            
        }
    }
    
}

//MARK: CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView{
        case homeCollectionView:
            return movies.count
        case sliderMenuCollectionView:
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == homeCollectionView {
            switch MovieGender(rawValue: section) {
                case .popular:
                    return movies[.popular]?.count ?? 0
                case .nowPlaying:
                    return movies[.nowPlaying]?.count ?? 0
                case .upcoming:
                    return movies[.upcoming]?.count ?? 0
                case .trendsToday:
                    return movies[.trendsToday]?.count ?? 0
                    
                default:
                    return movies[.popular]?.count ?? 0
                }
        }
        
        if collectionView == sliderMenuCollectionView {
            return movies.count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if
            collectionView == homeCollectionView,
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGenderListCell.identifier, for: indexPath) as? HomeGenderListCell
        {
            switch MovieGender(rawValue: indexPath.section) {
            case .popular:
                cell.configure(movie: movies[.popular]?[indexPath.item] ?? MockData.Result)
            case .nowPlaying:
                cell.configure(movie: movies[.nowPlaying]?[indexPath.item] ?? MockData.Result)
            case .upcoming:
                cell.configure(movie: movies[.upcoming]?[indexPath.item] ?? MockData.Result)
            case .trendsToday:
                cell.configure(movie: movies[.trendsToday]?[indexPath.item] ?? MockData.Result)
            default:
                cell.configure(movie: movies[.popular]?[indexPath.row] ?? MockData.Result)
            }
            return cell
        }
        
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderMenuCell.identifier, for: indexPath) as? SliderMenuCell else {
                return .init()
            }
            cell.configure(MovieGender(rawValue: indexPath.row)?.toString ?? "")
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
            
        switch indexPath.section {
        case 0:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHomeHeaderReusableView.identifier, for: indexPath) as? MainHomeHeaderReusableView else {return .init()}
                header.prepareForMainHeader(movie: movies[.popular]?.first ?? MockData.Result)
            header.delegate = self
            return header
        default:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: GenreHeaderCollectionReusableView.identifier, for: indexPath) as? GenreHeaderCollectionReusableView else {return .init()}
            header.configure(with: MovieGender(rawValue: indexPath.section) ?? .popular)
            return header
        }
        
    }
    
}

//MARK: CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sliderMenuCollectionView {
            let myPath: IndexPath = .init(row: 0, section: indexPath.row)
            collectionView.scrollToItem(at: .init(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            collectionView.deselectItem(at: myPath, animated: true)
        }
        
        if collectionView == homeCollectionView {
            let movie = movies[MovieGender(rawValue: indexPath.section) ?? .popular]?[indexPath.row] ?? MockData.Result
            goMovieDetail(movie)
        }
    }
}

//MARK: FlowLayout Delegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sliderMenuCollectionView {
            let estimatedCell = SliderMenuCell(frame: .init(x: 0, y: 0, width: 1000, height: 40))
            estimatedCell.configure(MovieGender(rawValue: indexPath.row)?.toString ?? "")
            estimatedCell.layoutIfNeeded()
            let estimatedSizeCell = estimatedCell.systemLayoutSizeFitting(.init(width: 1000, height: 40))
            return .init(width: estimatedSizeCell.width, height: 40)
        }
        return .init(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == sliderMenuCollectionView {
            return .init(top: 0, left: 16, bottom: 0, right: 16)
        }
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//MARK: Helper Funcs
extension HomeViewController {
    
    public func prepareGoDetailForHeaderView(movie: Result) {
        interactor?.setSelectedMovie(movie: movie)
        router?.routeToDetail(target: MovieDetailViewController())
    }
    
    private func goMovieDetail(_ movie: Result) {
        interactor?.setSelectedMovie(movie: movie)
        router?.routeToDetail(target: MovieDetailViewController())
    }
    
    static func GenerateSection(model: MovieGender) -> NSCollectionLayoutSection {
        //Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 4,
            bottom: 2,
            trailing: 4)
        
        //Group
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .absolute(135),
                heightDimension: .absolute(200)),
            subitem: item,
            count: 1
        )
        
        //Section
        let section = NSCollectionLayoutSection(group: group)
        
        let footerHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: model == .popular ? .absolute(500) : .absolute(50)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        header.contentInsets = .init(top: 0, leading: -16, bottom: 0, trailing: -16)
        
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        return section
        
    }
    
    static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        //Item
        
        switch MovieGender(rawValue: section){
        case .popular:
            return HomeViewController.GenerateSection(model: .popular)
            
        case .upcoming:
            return HomeViewController.GenerateSection(model: .upcoming)

        case .trendsToday:
            return HomeViewController.GenerateSection(model: .trendsToday)

        case .nowPlaying:
            return HomeViewController.GenerateSection(model: .nowPlaying)

        default:
            return HomeViewController.GenerateSection(model: .popular)
    
        }
    }

}

extension HomeViewController: MainHomeHeaderReusableViewDelegate {
    func didTapGoHeaderMovie(movie: Result) {
        interactor?.setSelectedMovie(movie: movie)
        router?.routeToDetail(target: MovieDetailViewController())
    }
    
}
