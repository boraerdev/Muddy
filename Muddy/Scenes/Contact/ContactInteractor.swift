//
//  ContactInteractor.swift
//  Muddy
//
//  Created by Bora Erdem on 26.12.2022.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ContactBusinessLogic {
    func doSomething(request: Contact.Something.Request)
}

protocol ContactDataStore {
    //var name: String { get set }
}

class ContactInteractor: ContactBusinessLogic, ContactDataStore {
    var presenter: ContactPresentationLogic?
    var worker: ContactWorker?
    //var name: String = ""
    
    // MARK: Do something
    func doSomething(request: Contact.Something.Request) {
        worker = ContactWorker()
        worker?.doSomeWork()
        
        let response = Contact.Something.Response()
        presenter?.presentSomething(response: response)
    }
}
