//
//  NetworkService.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation

protocol NetworkService {
    func get<Request, Response>(with url: String, request: Request, needsAuthentication: Bool, completion: @escaping ((Result<Response, Error>) -> ())) where Request: Encodable, Response: Decodable
    func post<Request, Response>(with url: String, request: Request, needsAuthentication: Bool, completion: @escaping ((Result<Response, Error>) -> ())) where Request: Encodable, Response: Decodable
}
