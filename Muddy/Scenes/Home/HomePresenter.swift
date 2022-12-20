//
//  HomePresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol HomePresentationLogic {
    func presentSomething(response: Home.Something.Response)
}

class HomePresenter: HomePresentationLogic {
    weak var viewController: HomeDisplayLogic?
    
    // MARK: Do something
    func presentSomething(response: Home.Something.Response) {
        let viewModel = Home.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
