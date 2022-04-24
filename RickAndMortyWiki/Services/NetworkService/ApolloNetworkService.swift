//
//  ApolloNetworkService.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Apollo

class ApolloNetworkService {
    let client: ApolloClient
    
    init(url: URL) {
      client = ApolloClient(url: url)
    }
}
