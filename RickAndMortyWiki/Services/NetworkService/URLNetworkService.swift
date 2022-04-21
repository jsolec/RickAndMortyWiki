//
//  URLNetworkService.swift
//  RickAndMortyWiki
//
//  Created by Jesús Solé on 21/4/22.
//

import Foundation

public class URLNetworkService: NetworkService {
    
    struct Dependencies {
        let keychain: KeychainService
    }
    
    private let session: URLSession
    private let dependencies: Dependencies

    init(session: URLSession = .shared, dependencies: Dependencies) {
        self.session = session
        self.dependencies = dependencies
    }
    
    struct UnexpectedValues: Error {}
    
    func get<Request, Response>(with url: String, request: Request, needsAuthentication: Bool, completion: @escaping ((Result<Response, Error>) -> ())) where Request: Encodable, Response: Decodable {
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems = try? request.asQueryItems()
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        urlRequest.httpMethod = "GET"
        self.addCommonHeadersTo(urlRequest: &urlRequest, needsAuthentication: needsAuthentication)
        
        self.task(with: urlRequest, completion: completion)
    }
    
    func post<Request, Response>(with url: String, request: Request, needsAuthentication: Bool, completion: @escaping ((Result<Response, Error>) -> ())) where Request: Encodable, Response: Decodable {
        var urlRequest = URLRequest(url: URL(string: url)!)
    
        urlRequest.httpMethod = "POST"
        self.addCommonHeadersTo(urlRequest: &urlRequest, needsAuthentication: needsAuthentication)
        
        if let body = try? JSONEncoder().encode(request) {
            urlRequest.httpBody = body
        }
        
        self.task(with: urlRequest, completion: completion)
    }
    
    private func addCommonHeadersTo(urlRequest: inout URLRequest, needsAuthentication: Bool) {
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if needsAuthentication, let authToken = self.dependencies.keychain.string(key: .token) {
            urlRequest.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
    }
    
    private func task<T: Decodable>(with request: URLRequest, dispatchQueue: DispatchQueue = .main, completion: @escaping ((Result<T, Error>) ->())) {
        self.session.dataTask(with: request) { data, response, error in
            dispatchQueue.async {
                if let error = error {
                    completion(.failure(error))
                } else if let data = data {
                    
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(result))
                    } catch let parsingError {
                        debugPrint("\(parsingError)")
                        completion(.failure(parsingError))
                    }
                    
                } else {
                    completion(.failure(UnexpectedValues()))
                }
            }
        }.resume()
    }
}

