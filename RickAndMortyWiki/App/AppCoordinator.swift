//
//  AppCoordinator.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class AppCoordinator {
    struct Dependencies {
        let networkService: NetworkService
    }
    
    private var window: UIWindow?
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func start(in window: UIWindow?) {
        let navigationController = UINavigationController()
        let mainViewController = CharacterListViewController(
            characterListViewModel: .init(
                dependencies: .init(
                    networkService: self.dependencies.networkService
                )
            )
        )
        navigationController.pushViewController(mainViewController, animated: true)
        
        self.window = window
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}
