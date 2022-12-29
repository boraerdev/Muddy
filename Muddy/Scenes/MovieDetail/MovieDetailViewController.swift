//
//  MovieDetailViewController.swift
//  Muddy
//
//  Created by Bora Erdem on 22.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MovieDetailDisplayLogic: AnyObject {
    func displayMovieDetail(viewModel: MovieDetail.FetchMovieDetail.ViewModel)
    func displayCast(viewModel: MovieDetail.FetchCredits.ViewModel)
    func displayRecommendations(viewModel: MovieDetail.FetchRecommendations.ViewModel)
}

class MovieDetailViewController: UIViewController, MovieDetailDisplayLogic {

    var interactor: MovieDetailBusinessLogic?
    var router: (NSObjectProtocol & MovieDetailRoutingLogic & MovieDetailDataPassing)?
    
    //DEF
    private var movie: DetailedMovie? = nil {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard self?.movie != nil else {return}
                self?.setupUI()
            }
        }
    }
    
    private var cast: [Cast] = []
    private var recommendedMovies: [Result] = []
    
    //UI
    private lazy var movieBackgropImage: UIImageView = {
        let view = UIImageView(image: nil, contentMode: .scaleAspectFill)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
       let imageview = UIImageView()
        imageview.layer.cornerRadius = 8
        imageview.layer.cornerCurve = .continuous
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.withBorder(width: 5, color: .systemGray5.withAlphaComponent(0.5))
        return imageview
    }()
    
    private lazy var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = .init(width: 100, height: 150)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private lazy var recommendaionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = .init(width: 135, height: 200)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecommendationsCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationsCollectionViewCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var headerContainer: UIView?
    
    private var mainContainer: UIView?
    
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
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMovieDetails()
        fetchMovieCast()
        fetchRecommendations()
        fetchMovieImage()
    }
    
    // MARK: Fetch
    func fetchMovieDetails() {
        let id = router?.dataStore?.selectedMovie.id
        let request = MovieDetail.FetchMovieDetail.Request(movieId: id ?? 0)
        Task { await interactor?.fetchMovieDetail(request: request) }
    }
    
    func fetchMovieCast() {
        let id = router?.dataStore?.selectedMovie.id
        let request = MovieDetail.FetchCredits.Request(movieId: id ?? 0)
        Task { await interactor?.fetchCredits(request:request)}
    }
    
    func fetchRecommendations() {
        let id = router?.dataStore?.selectedMovie.id ?? 0
        let request = MovieDetail.FetchRecommendations.Request(movieId: id)
        Task {await interactor?.fetchRecommendations(request: request)}
    }
    
    // MARK: Display
    func displayMovieDetail(viewModel: MovieDetail.FetchMovieDetail.ViewModel) {
        movie = viewModel.movie
    }
    
    func displayCast(viewModel: MovieDetail.FetchCredits.ViewModel) {
        cast = viewModel.cast ?? []
        DispatchQueue.main.async { [unowned self] in
            castCollectionView.reloadData()
        }
    }
    
    func displayRecommendations(viewModel: MovieDetail.FetchRecommendations.ViewModel) {
        recommendedMovies = viewModel.movies
        DispatchQueue.main.async { [unowned self] in
            recommendaionsCollectionView.reloadData()
            recommendaionsCollectionView.isHidden = recommendedMovies.isEmpty
        }
    }

}

// MARK: UI
extension MovieDetailViewController {
    private func setupUI() {
        view.backgroundColor = .black
        headerContainer = prepareHeader()
        mainContainer = prepareMainContainer()

        mainContainer?.stack(
            movieHeader().withWidth(view.frame.width),
            actionButttons(),
            movieDetails(),
            credits(),
            recommendations(),
            spacing: 10
        )
        
        //Preapre gradient for header
        DispatchQueue.main.async { [unowned self] in
            movieBackgropImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 1), endPoint: .init(x: 0.5, y: 0))
            movieBackgropImage.insertGradient(colors: [.black, .clear], startPoint: .init(x: 0.5, y: 0), endPoint: .init(x: 0.5, y: 1))
        }
        
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
        
        let linkBtn = UIButton(
            image: .init(systemName: "link")!,
            tintColor: .white,
            target: self,
            action: #selector(didTapBack)
        )
        linkBtn.imageView?.contentMode = .scaleAspectFill
        
        
        backBtn.imageView?.contentMode = .scaleAspectFit
        container.hstack(
            backBtn.withWidth(25),
            UIView(),
            linkBtn.withSize(.init(width: 25, height: 25))
        ).withMargins(.allSides(16))
        
        let titleLabel = UILabel(
            text: "Movie",
            font: .systemFont(ofSize: 17, weight: .bold),
            textColor: .white
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        
        return safeAreaContainer
    }
    
    private func prepareMainContainer() -> UIView {
        let container = UIView()
        view.addSubview(container)
        
        container.anchor(
            top: headerContainer?.bottomAnchor,
            leading: view.leadingAnchor,
            bottom: view.bottomAnchor,
            trailing: view.trailingAnchor
        )
        
        let scroll = UIScrollView()
        scroll.contentSize = .init(width: view.frame.width, height: 100)
        scroll.clipsToBounds = true
        scroll.showsVerticalScrollIndicator = false
        container.addSubview(scroll)
        scroll.fillSuperview()
        return scroll
    }
    
    private func movieHeader() -> UIView {
        let container = UIView()
        let detailsContainer = UIView()

        container.stack(movieBackgropImage)
        
        let title = UILabel(
            text: movie?.title,
            font: .systemFont(ofSize: 17),
            textColor: .white,
            textAlignment: .left,
            numberOfLines: 0
        )
        
        let year = getYearFromDate(dateString: movie?.releaseDate ?? "")
        
        let voteAvarageStr = String(format: "%.1f", movie?.voteAverage ?? .zero)
        let voteAvarage = UILabel(
            text: "\(voteAvarageStr)/10",
            font: .systemFont(ofSize: 13),
            textColor: .orange,
            textAlignment: .left,
            numberOfLines: 0
        )
        
        let clockImg: UIImageView = {
            let img = UIImageView(
                image: .init(systemName: "clock"),
                contentMode: .scaleAspectFit
            )
            img.tintColor = .white
            img.withSize(.init(width: 11, height: 11))
            return img
        }()
        
        let infoStr = UILabel(
            text: "\(year)",
            font: .systemFont(ofSize: 13),
            textColor: .secondaryLabel,
            textAlignment: .left,
            numberOfLines: 2
        )
        
        let runtime = UILabel(
            text: movie?.runtime?.toXhYmin(),
            font: .systemFont(ofSize: 13),
            textColor: .secondaryLabel,
            textAlignment: .left,
            numberOfLines: 2
        )
        
        let tagLine = UILabel(
            text: movie?.tagline,
            font: .systemFont(ofSize: 13),
            textColor: .secondaryLabel,
            textAlignment: .left,
            numberOfLines: 2
        )
        
        let ratingView = createRatingView(score: movie?.voteAverage ?? 0)
        ratingView.withSize(.init(width: 100, height: 20))
        
        detailsContainer.hstack(
            posterImageView.withSize(.init(width: 135, height: 200)),
            detailsContainer.stack(
                detailsContainer.hstack(infoStr,clockImg,runtime, UIView(), spacing: 5),
                title.withWidth(200),
                tagLine,
                detailsContainer.hstack(ratingView, voteAvarage, UIView(), spacing: 5, alignment: .center),
                spacing: 5
            ),
            spacing: 20,
            alignment: .bottom
        )
        
        container.addSubview(detailsContainer)
        detailsContainer.anchor(
            top: nil,
            leading: container.leadingAnchor,
            bottom: container.bottomAnchor,
            trailing: nil,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0)
        )
        
        return container.withHeight(400)
    }
    
    private func actionButttons() -> UIView {
        let container = UIView()

        //Btns
        let btnSize: CGFloat = 40
        let trailerBtn = UIButton(
            image: .init(systemName: "play")!,
            tintColor: .white,
            target: self,
            action: #selector(didTapTrailer)
        )
        
        let addListBtn = UIButton(
            image: .init(systemName: "plus")!,
            tintColor: .white,
            target: self,
            action: #selector(didTapTrailer)
        )
        
        let shareBtn = UIButton(
            image: .init(systemName: "square.and.arrow.up")!,
            tintColor: .white,
            target: self,
            action: #selector(didTapTrailer)
        )
        
        [trailerBtn, addListBtn, shareBtn].forEach { btn in
            btn.imageView?.contentMode = .scaleAspectFit
            btn.contentVerticalAlignment = .fill
            btn.contentHorizontalAlignment = .fill
        }
        
        container.stack(
            container.hstack(
                container.stack(
                    trailerBtn.withSize(.init(width: btnSize, height: btnSize)),
                    UILabel(text: "Trailer",font: .systemFont(ofSize: 13), textColor: .secondaryLabel),
                    spacing: 5,
                    alignment: .center
                ),
                container.stack(
                    addListBtn.withSize(.init(width: btnSize, height: btnSize)),
                    UILabel(text: "Watchlist",font: .systemFont(ofSize: 13), textColor: .secondaryLabel),
                    spacing: 5,
                    alignment: .center
                ),
                container.stack(
                    shareBtn.withSize(.init(width: btnSize, height: btnSize)),
                    UILabel(text: "Share",font: .systemFont(ofSize: 13), textColor: .secondaryLabel),
                    spacing: 5,
                    alignment: .center
                ),
                spacing: 30
            ),
            alignment: .center
        ).withMargins(
            .init(top: 20, left: 0, bottom: 20, right: 0))

        
        return container
    }
    
    private func movieDetails() -> UIView {
        let container = UIView()
        let infoContainer = UIView()
        
        
        
        //Overview
        let overview = UILabel(
            text: movie?.overview,
            font: .systemFont(ofSize: 15, weight: .light),
            textColor: .white,
            textAlignment: .left,
            numberOfLines: 0
        )
        
        //Genre
        let genresString = makeGenreString()
        let genresLabel = UILabel(
            text: genresString,
            font: .systemFont(ofSize: 15),
            textColor: .secondaryLabel,
            textAlignment: .left,
            numberOfLines: 1
        )
        
        
        infoContainer.stack(
            overview,
            genresLabel
        ).withMargins(
            .init(top: 0, left: 16, bottom: 0, right: 16))
        
        container.stack(
            infoContainer,
            spacing: 10
        )
        
        return container
    }
    
    private func credits() -> UIView {
        let container = UIView()
        
        let title = UILabel(
            text: "Cast",
            font: .systemFont(ofSize: 17, weight: .bold),
            textColor: .white,
            textAlignment: .left,
            numberOfLines: 1)
        
        
        container.stack(
            container.hstack(title).withMargins(.init(top: 0, left: 16, bottom: 0, right: 0)),
            castCollectionView.withHeight(150),
            spacing: 10
        )
        
        return container
    }
    
    private func recommendations() -> UIView {
        let container = UIView()
        
        let title = UILabel(
            text: "Recommendations",
            font: .systemFont(ofSize: 17, weight: .bold),
            textColor: .white,
            textAlignment: .left,
            numberOfLines: 1)

        container.stack(
            container.hstack(title).withMargins(.init(top: 0, left: 16, bottom: 0, right: 0)),
            recommendaionsCollectionView.withHeight(200),
            spacing: 10
        )
        
        return container
    }
    
}

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case castCollectionView:
            return cast.count
        case recommendaionsCollectionView:
            return recommendedMovies.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case castCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else {return .init()}
            cell.configure(cast: cast[indexPath.row])
            return cell
        case recommendaionsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationsCollectionViewCell.identifier, for: indexPath) as? RecommendationsCollectionViewCell else {return .init()}
            cell.configure(movie: recommendedMovies[indexPath.row])
            return cell
        default:
            return .init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case recommendaionsCollectionView:
            interactor?.setSelectedMovie(movie: recommendedMovies[indexPath.row])
            router?.routeToDetail(target: MovieDetailViewController())
        default:
            break
        }
    }
    
}

// MARK: Funcs
extension MovieDetailViewController {
    private func makeGenreString() -> String {
        var genresString = ""
        movie?.genres?.forEach({ genre in
            if genre.id != movie?.genres?.last?.id, genre.name != nil {
                genresString += genre.name! + " · "
            } else if genre.id == movie?.genres?.last?.id, genre.name != nil {
                genresString += genre.name!
            }
        })
        return genresString
    }
    
    private func fetchMovieImage() {
        let movie = router?.dataStore?.selectedMovie
        guard let bgurl = URL(string: APIEndpoint.Image.withQuality(quality: .w300, path: movie?.backdropPath ?? "").toString) else {
            return
        }
        movieBackgropImage.kf.setImage(
            with: bgurl,
            options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired)]
        )
        
        guard let posterUrl = URL(string: APIEndpoint.Image.withQuality(quality: .w154, path: movie?.posterPath ?? "").toString) else {return}
        posterImageView.kf.setImage(
            with: posterUrl,
            options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired)]
        )
    }
}

// MARK: Objc
extension MovieDetailViewController {
    @objc func didTapBack() {
        dismiss(animated: true)
    }
    
    @objc func didTapTrailer() {
    }

}
