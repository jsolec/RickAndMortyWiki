//
//  Endpoints.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation

protocol Endpoint {
    func url(with baseURL: String) -> String
}

enum RickAndMortyEndpoint: String, Endpoint {
    
    func url(with baseURL: String = "https://rickandmortyapi.com/api/") -> String {
        return baseURL + self.rawValue
    }
    
    case character
}
