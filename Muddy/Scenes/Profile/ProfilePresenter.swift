//
//  ProfilePresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ProfilePresentationLogic {
    func presentSomething(response: Profile.Something.Response)
}

class ProfilePresenter: ProfilePresentationLogic {
    weak var viewController: ProfileDisplayLogic?
    
    // MARK: Do something
    func presentSomething(response: Profile.Something.Response) {
        let viewModel = Profile.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
