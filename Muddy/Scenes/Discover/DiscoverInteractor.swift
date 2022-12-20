//
//  DiscoverInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 20.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol DiscoverBusinessLogic {
    func doSomething(request: Discover.Something.Request)
}

protocol DiscoverDataStore {
    //var name: String { get set }
}

class DiscoverInteractor: DiscoverBusinessLogic, DiscoverDataStore {
    var presenter: DiscoverPresentationLogic?
    var worker: DiscoverWorker?
    //var name: String = ""
    
    // MARK: Do something
    func doSomething(request: Discover.Something.Request) {
        worker = DiscoverWorker()
        worker?.doSomeWork()
        
        let response = Discover.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
