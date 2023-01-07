//
//  PresenterMock.swift
//  MuddyTests
//
//  Created by Bora Erdem on 8.01.2023.
//

import Foundation
@testable import Muddy

final class ExplorePresentationLogicMock: ExplorePresentationLogic {

    var invokedPresentDiscover = false
    var invokedPresentDiscoverCount = 0
    var invokedPresentDiscoverParameters: (response: Explore.FetchDiscover.Response, Void)?
    var invokedPresentDiscoverParametersList = [(response: Explore.FetchDiscover.Response, Void)]()

    func presentDiscover(response: Explore.FetchDiscover.Response) {
        invokedPresentDiscover = true
        invokedPresentDiscoverCount += 1
        invokedPresentDiscoverParameters = (response, ())
        invokedPresentDiscoverParametersList.append((response, ()))
    }

    var invokedPresentSearch = false
    var invokedPresentSearchCount = 0
    var invokedPresentSearchParameters: (response: Explore.FetchSearch.Response, Void)?
    var invokedPresentSearchParametersList = [(response: Explore.FetchSearch.Response, Void)]()

    func presentSearch(response: Explore.FetchSearch.Response) {
        invokedPresentSearch = true
        invokedPresentSearchCount += 1
        invokedPresentSearchParameters = (response, ())
        invokedPresentSearchParametersList.append((response, ()))
    }

    var invokedPresentGenres = false
    var invokedPresentGenresCount = 0
    var invokedPresentGenresParameters: (response: Explore.FetchGenres.Response, Void)?
    var invokedPresentGenresParametersList = [(response: Explore.FetchGenres.Response, Void)]()

    func presentGenres(response: Explore.FetchGenres.Response) {
        invokedPresentGenres = true
        invokedPresentGenresCount += 1
        invokedPresentGenresParameters = (response, ())
        invokedPresentGenresParametersList.append((response, ()))
    }
}
