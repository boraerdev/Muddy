//
//  ExploreRouter.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol ExploreRoutingLogic {
    func routeToDetail(target: MovieDetailViewController)
}

protocol ExploreDataPassing {
    var dataStore: ExploreDataStore? { get }
}

class ExploreRouter: NSObject, ExploreRoutingLogic, ExploreDataPassing {
    weak var viewController: ExploreViewController?
    var dataStore: ExploreDataStore?
    
    // MARK: Routing
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    //func navigateToSomewhere(source: ExploreViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    //func passDataToSomewhere(source: ExploreDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
    
    func routeToDetail(target: MovieDetailViewController) {
        var destinationDS = target.router!.dataStore!
        passDataToMovieDetail(source: dataStore!, destination: &destinationDS)
        navigateToMovieDetail(source: viewController!, destination: target)
    }
    
    // MARK: Navigation
    func navigateToMovieDetail(source: ExploreViewController, destination: MovieDetailViewController)
    {
        destination.modalPresentationStyle = .overCurrentContext
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    func passDataToMovieDetail(source: ExploreDataStore, destination: inout MovieDetailDataStore)
    {
        destination.selectedMovie = source.selectedMovie ?? MockData.Result
    }
}
