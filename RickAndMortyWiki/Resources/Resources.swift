//
//  Resources.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation

enum L10n {
    enum General {
        static let unknown = "unknown".localized()
    }
    
    enum CharactersListView {
        static let title = "characters_list_title".localized()
    }
    
    enum CharacterDetailView {
        static let created = "characters_detail_created".localized()
        static let status = "characters_detail_status".localized()
        static let species = "characters_detail_species".localized()
        static let gender = "characters_detail_gender".localized()
        static let origin = "characters_detail_origin".localized()
        static let currentLocation = "characters_detail_current_location".localized()
    }
}
