//
//  String+Utils.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation

extension String {
    var nilIfEmpty: String? {
        self.isEmpty ? nil : self
    }
}
