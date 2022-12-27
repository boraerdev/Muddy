//
//  ContactPresenter.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ContactPresentationLogic {
    func presentSomething(response: Contact.Something.Response)
}

class ContactPresenter: ContactPresentationLogic {
    weak var viewController: ContactDisplayLogic?
    
    // MARK: Do something
    func presentSomething(response: Contact.Something.Response) {
        let viewModel = Contact.Something.ViewModel()
        viewController?.displaySomething(viewModel: viewModel)
    }
}
