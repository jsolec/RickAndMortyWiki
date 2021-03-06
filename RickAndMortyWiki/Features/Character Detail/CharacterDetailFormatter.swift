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
            status: "\(L10n.CharacterDetailView.status) \(character.status.title)",
            species: "\(L10n.CharacterDetailView.species) \(self.unwrapContent(character.species))",
            gender: "\(L10n.CharacterDetailView.gender) \(character.gender.rawValue)",
            origin: "\(L10n.CharacterDetailView.origin) \(self.unwrapContent(character.origin.name))",
            location: "\(L10n.CharacterDetailView.currentLocation) \(self.unwrapContent(character.location.name))",
            imageURL: imageURL
        )
    }
    
    private func unwrapContent(_ content: String?) -> String {
        content ?? L10n.General.unknown
    }
}


