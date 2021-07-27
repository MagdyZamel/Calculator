//
//  AppDelegate+Injection.swift
//  Calculator
//
//  Created by MSZ on 15/07/2021.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerNetworkingServices()
        registerHomeScreenServices()
    }
    // MARK: - NetworkingServices
    private static func registerNetworkingServices() {
        // InternetManagerImp Should be singleton so the scope is (.application)
        register { InternetManagerImp() }
            .implements(InternetManager.self)
            .scope(.application)

        // NetworkClientImp Should be singleton so the scope is (.application)
        register { NetworkClientImp(internetManager: resolve()) }
            .implements(NetworkClient.self)
            .scope(.application)
    }

    // MARK: - HomeScreenServices
    private static func registerHomeScreenServices() {
        // Usecase
        register { FetchBitcoinValueUseCaseImp(networkClient: resolve()) }
            .implements(FetchBitcoinValueUseCase.self)
        // Builder
        register { Calculator(usecase: resolve()) }
        // Presenter
        register { HomePresenterImp(calculator: resolve()) }
            .implements(HomePresenter.self)
        // View
        register { (_, _) -> HomeViewController in
            let view = HomeViewController()
            view.presenter = Resolver.optional()
            return view
        }
    }

}
