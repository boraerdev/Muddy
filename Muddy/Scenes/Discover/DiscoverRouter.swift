//
//  DiscoverRouter.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

@objc protocol DiscoverRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol DiscoverDataPassing {
    var dataStore: DiscoverDataStore? { get }
}

class DiscoverRouter: NSObject, DiscoverRoutingLogic, DiscoverDataPassing {
    weak var viewController: DiscoverViewController?
    var dataStore: DiscoverDataStore?
    
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
    //func navigateToSomewhere(source: DiscoverViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    //func passDataToSomewhere(source: DiscoverDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
