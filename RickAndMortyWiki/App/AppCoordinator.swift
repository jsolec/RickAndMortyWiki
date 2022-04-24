//
//  AppCoordinator.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class AppCoordinator {
    struct Dependencies {
        let networkService: ApolloNetworkService
    }
    
    private var window: UIWindow?
    private let dependencies: Dependencies
    
    private var navigationController: UINavigationController?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func start(in window: UIWindow?) {
        let navigationController = UINavigationController()
        let mainViewController = CharacterListViewController(
            characterListViewModel: CharactersListViewModel(
                dependencies: .init(
                    characterDataFetcher: AllCharactersDataFetcher(dependencies: .init(networkService: self.dependencies.networkService)),
                    formatter: .init()
                )
            ),
            delegate: self
        )
        navigationController.pushViewController(mainViewController, animated: true)
        
        self.window = window
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        self.navigationController = navigationController
    }
}

//MARK: - CharacterListViewControllerDelegate
extension AppCoordinator: CharacterListViewControllerDelegate {
    func characterListViewControllerDidRequestCharacter(withId id: Int) {
        
        let detailViewController = CharacterDetailViewController(
            characterViewModel: CharacterDetailViewModel(
                dependencies: .init(
                    characterDataFetcher: CharacterDataFetcher(dependencies: .init(networkService: self.dependencies.networkService)),
                    formatter: .init()
                ),
                characterId: id
            )
        )
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
