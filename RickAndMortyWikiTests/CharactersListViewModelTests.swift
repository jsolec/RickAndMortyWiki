//
//  CharactersListViewModelTests.swift
//  RickAndMortyWikiTests
//
//  Created by Jesús Solé on 27/4/22.
//

import XCTest
@testable import RickAndMortyWiki

class CharactersListViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_GetCharactersCallbacks() throws {
        
        let (sut, _) = self.makeSUT()
        
        let exp = expectation(description: "Testing async code")
        exp.expectedFulfillmentCount = 3
        
        sut.onLoadingStatusChanged = { _ in
            exp.fulfill()
        }
        sut.onCharactersRetrieved = { _ in
            exp.fulfill()
        }
        sut.getCharacters()
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_GetCharactersOnErrorCallback() throws {
        
        let (sut, dataFetcher) = self.makeSUT()
        
        let exp = expectation(description: "Testing async code")
        exp.expectedFulfillmentCount = 3
        
        sut.onLoadingStatusChanged = { _ in
            exp.fulfill()
        }
        sut.onCharactersRetrieved = { _ in }
        sut.onCharactersError = { _ in
            exp.fulfill()
        }
        sut.getCharacters()
        
        dataFetcher.completion(withError: dataFetcher.error(withCode: 401))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_GetCharactersEmpty() throws {
        
        let (sut, dataFetcher) = self.makeSUT()
        
        let exp = expectation(description: "Testing async code")
        
        sut.onLoadingStatusChanged = { _ in }

        var capturedResults = [CharacterListInfoViewData]()
        sut.onCharactersRetrieved = { result in
            capturedResults += result
            exp.fulfill()
        }
        sut.getCharacters()
        
        let response = CharacterListResponse(
            info: .init(pages: 40, next: 2),
            results: []
        )
        
        dataFetcher.completion(withResponse: response)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(capturedResults, [])
    }
    
    func test_GetCharactersParsing() throws {
        
        let (sut, dataFetcher) = self.makeSUT()
        
        let exp = expectation(description: "Testing async code")
        
        sut.onLoadingStatusChanged = { _ in }

        var capturedResults = [CharacterListInfoViewData]()
        sut.onCharactersRetrieved = { result in
            capturedResults += result
            exp.fulfill()
        }
        sut.getCharacters()
        
        let response = CharacterListResponse(
            info: .init(pages: 40, next: 2),
            results: [
                .init(id: 0, name: "Rick", imageUrl: "https://www.apple.com"),
                .init(id: 1, name: "Morty", imageUrl: "https://www.apple.com")
            ]
        )
        
        dataFetcher.completion(withResponse: response)
        
        let expectedResults: [CharacterListInfoViewData] = [
            .init(
                id: 0,
                name: "Rick",
                thumbnailUrl: URL(string: "https://www.apple.com")
            ),
            .init(
                id: 1,
                name: "Morty",
                thumbnailUrl: URL(string: "https://www.apple.com")
            )
        ]
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(capturedResults, expectedResults)
    }
    
    private func makeSUT() ->  (CharactersListViewModel, MockAllCharactersDataFetcher) {
        let dataFetcher = MockAllCharactersDataFetcher()
        let viewModel = CharactersListViewModel(
            dependencies: .init(
                characterDataFetcher: dataFetcher,
                formatter: .init()
            )
        )
        
        return (viewModel, dataFetcher)
    }

}

final class MockAllCharactersDataFetcher: AllCharactersDataFetcherInterface {
    private var completions = [(Result<CharacterListResponse, Error>) -> ()]()
    
    func getCharacters(page: Int, completion: @escaping ((Result<CharacterListResponse, Error>) -> ())) {
        self.completions.append(completion)
    }
    
    func error(withCode code: Int) -> Error {
        NSError(domain: "Test", code: code)
    }
    
    func completion(withResponse response: CharacterListResponse, at index: Int = 0) {
        
        completions[index](.success(response))
    }
    
    func completion(withError error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
}
