//
//  AppCoordinator.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import UIKit

class AppCoordinator {
    struct Dependencies {
    }
    
    private var window: UIWindow?
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func start(in window: UIWindow?) {
        let navigationController = UINavigationController()
        
        self.window = window
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
}
