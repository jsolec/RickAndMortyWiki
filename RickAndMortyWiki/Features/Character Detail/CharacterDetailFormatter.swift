//
//  CharacterDetailFormatter.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 24/4/22.
//

import Foundation

class CharacterDetailFormatter {
    func prepareCharacterDetailViewModel(character: CharacterDetailResponse) -> CharacterDetailViewData {
        
        var imageURL: URL? = nil
        if let url = character.imageUrl {
            imageURL = URL(string: url)
        }
        
        return CharacterDetailViewData(
            name: character.name,
            imageURL: imageURL
        )
    }
}


