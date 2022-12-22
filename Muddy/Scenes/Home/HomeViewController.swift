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

final class HomeViewController: UIViewController {
    var interactor: HomeBusinessLogic?
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    //UI
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
        cv.register(MainHomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHomeHeader.identifier)
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
    
    // MARK: Fetch Movies
    func fetchMovies() {
        let request = Home.HomeMovies.Request()
        Task { await interactor?.fetchHomeMovies(request: request) }
    }
    
}

extension HomeViewController: HomeDisplayLogic {
    func displayMovies(viewModel: Home.HomeMovies.ViewModel) {

        var list: [MovieGender: [Result]] = [:]
        list[.popular] = viewModel.popularMovies?.results
        list[.nowPlaying] = viewModel.nowPlayingMovies?.results
        list[.topRated] = viewModel.topRatedMovies?.results
        list[.upcoming] = viewModel.upcomingMovies?.results
        movies = list
    }
}

//MARK: UI Funcs
extension HomeViewController {
    
    private func topNavigaion() {
        DispatchQueue.main.async { [unowned self] in
            let container = UIView()
            view.addSubview(container)
            
            container.anchor(
                top: view.safeAreaLayoutGuide.topAnchor,
                leading: view.leadingAnchor,
                bottom: nil,
                trailing: view.trailingAnchor,
                size: .init(width: view.frame.width, height: 80)
            )
            
            let titleLabel = UILabel(
                text: "Welcome Back",
                font: .systemFont(ofSize: 22, weight: .bold),
                textColor: .white,
                textAlignment: .center,
                numberOfLines: 1
            )
            
            let searchImage = UIImageView(
                image: .init(systemName: "magnifyingglass"),
                contentMode: .scaleAspectFit)
            searchImage.tintColor = .white
            
            container.stack(
                container.hstack(
                    titleLabel,
                    UIView(),
                    searchImage.withWidth(25)
                ).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16)),
                sliderMenuCollectionView,
                distribution: .fillEqually
            )
            
        }
    }
    
    private func setupUI(resultMovies: [MovieGender:[Result]]) {

        view.stack(
            homeCollectionView
        )
        
        view.insertGradient(colors: [.black,.clear], startPoint: .init(x: 0.5, y: 0.1), endPoint: .init(x: 0.5, y: 0.25))
        topNavigaion()
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
                case .topRated:
                    return movies[.topRated]?.count ?? 0
                    
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
        
        let section = indexPath.section
        
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
            case .topRated:
                cell.configure(movie: movies[.topRated]?[indexPath.item] ?? MockData.Result)
            default:
                cell.configure(movie: movies[.popular]?[indexPath.row] ?? MockData.Result)
            }
            return cell
        }
        
        else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SliderMenuCell.identifier, for: indexPath) as? SliderMenuCell else {
                return .init()
            }
            cell.configure(MovieGender(rawValue: indexPath.row) ?? .popular)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MainHomeHeader.identifier, for: indexPath) as? MainHomeHeader else {return .init()}
            switch MovieGender(rawValue: indexPath.section) {
            case .popular:
                header.prepareForMainHeader(movie: movies[.popular]?.first ?? MockData.Result)
            default:
                header.prepareForTitle(gender: MovieGender(rawValue: indexPath.section) ?? .popular)
            }
            
            return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sliderMenuCollectionView {
            let estimatedCell = SliderMenuCell(frame: .init(x: 0, y: 0, width: 1000, height: 40))
            estimatedCell.configure(MovieGender(rawValue: indexPath.row) ?? .popular)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sliderMenuCollectionView {
            let myPath: IndexPath = .init(row: 0, section: indexPath.row)
            homeCollectionView.scrollToItem(at: myPath, at: .centeredVertically, animated: true)
            collectionView.deselectItem(at: myPath, animated: true)
        }
    }
    
}

extension HomeViewController {
    static func GenerateSection(model: MovieGender) -> NSCollectionLayoutSection {
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
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let footerHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: model == .popular ? .absolute(500) : .absolute(50)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        header.contentInsets = .init(top: 0, leading: -16, bottom: 0, trailing: -16)
        
        //Section
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

        case .topRated:
            return HomeViewController.GenerateSection(model: .topRated)

        case .nowPlaying:
            return HomeViewController.GenerateSection(model: .nowPlaying)

        default:
            return HomeViewController.GenerateSection(model: .popular)
    
        }
    }

}
