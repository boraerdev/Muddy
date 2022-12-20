//
//  DiscoverPresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DiscoverPresentationLogic {
    func presentSomething(response: Discover.Something.Response)
}

class DiscoverPresenter: DiscoverPresentationLogic {
    weak var viewController: DiscoverDisplayLogic?
    
    // MARK: Do something
    func presentSomething(response: Discover.Something.Response) {
        let viewModel = Discover.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
