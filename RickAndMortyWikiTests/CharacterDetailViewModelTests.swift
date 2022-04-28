//
//  CharacterDetailViewModelTests.swift
//  RickAndMortyWikiTests
//
//  Created by Jesús Solé on 28/4/22.
//

import XCTest
@testable import RickAndMortyWiki

class CharacterDetailViewModelTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_GetCharactersCallbacks() throws {
        
        let (sut, dataFetcher, _) = self.makeSUT()
        
        let exp = expectation(description: "Testing async code")
        exp.expectedFulfillmentCount = 3
        
        sut.onLoadingStatusChanged = { _ in
            exp.fulfill()
        }
        sut.onCharacterRetrieved = { _ in
            exp.fulfill()
        }
        sut.getCharacterInfo()
        
        dataFetcher.completion(
            withResponse: .init(
                id: 0,
                name: "Test",
                status: .unknown,
                species: nil,
                type: nil,
                gender: .unknown,
                imageUrl: nil,
                origin: .init(name: "name", dimension: "dimension"),
                location: .init(name: "name", dimension: "dimension")
            )
        )
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_GetCharactersOnErrorCallback() throws {
        
        let (sut, dataFetcher, _) = self.makeSUT()
        
        let exp = expectation(description: "Testing async code")
        exp.expectedFulfillmentCount = 3
        
        sut.onLoadingStatusChanged = { _ in
            exp.fulfill()
        }
        sut.onCharacterRetrieved = { _ in }
        sut.onCharacterError = { _ in
            exp.fulfill()
        }
        sut.getCharacterInfo()
        
        dataFetcher.completion(withError: dataFetcher.error(withCode: 401))
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_GetCharactersInfoParsing() throws {
        
        let (sut, dataFetcher, formatter) = self.makeSUT()
        
        let exp = expectation(description: "Testing async code")
        
        sut.onLoadingStatusChanged = { _ in }

        var capturedResults: CharacterDetailViewData?
        sut.onCharacterRetrieved = { result in
            capturedResults = result
            exp.fulfill()
        }
        sut.getCharacterInfo()
        
        let response = CharacterDetailResponse(
            id: 0,
            name: "Rick",
            status: .alive,
            species: "Human",
            type: "Unknown",
            gender: .male,
            imageUrl: "https://www.apple.com",
            origin: .init(name: "Earth", dimension: "Earth Dimension"),
            location: .init(name: "Citadel", dimension: "Dimension")
        )
        
        dataFetcher.completion(withResponse: response)
        
        let expectedResult = formatter.prepareCharacterDetailViewModel(character: response)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(capturedResults, expectedResult)
    }
    
    private func makeSUT(characterId: Int = 0) ->  (CharacterDetailViewModel, MockCharacterDataFetcher, CharacterDetailFormatter) {
        let dataFetcher = MockCharacterDataFetcher()
        let formatter = CharacterDetailFormatter()
        let viewModel = CharacterDetailViewModel(
            dependencies: .init(
                characterDataFetcher: dataFetcher,
                formatter: formatter
            ),
            characterId: characterId
        )
        
        return (viewModel, dataFetcher, formatter)
    }

}

final class MockCharacterDataFetcher: CharacterDataFetcherInterface {
    private var completions = [(Result<CharacterDetailResponse, Error>) -> ()]()
    
    func getCharacterBy(id: Int, completion: @escaping ((Result<CharacterDetailResponse, Error>) -> ())) {
        self.completions.append(completion)
    }
    
    func error(withCode code: Int) -> Error {
        NSError(domain: "Test", code: code)
    }
    
    func completion(withResponse response: CharacterDetailResponse, at index: Int = 0) {
        
        completions[index](.success(response))
    }
    
    func completion(withError error: Error, at index: Int = 0) {
        completions[index](.failure(error))
    }
}
