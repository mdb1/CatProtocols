//
//  CatProtocolsTests.swift
//  CatProtocolsTests
//
//  Created by Manu on 13/02/2023.
//

import XCTest
@testable import CatProtocols

@MainActor
final class CatFactViewModelTests: XCTestCase {
    func testFetchCatFactSuccess() async {
        // Given
        let mockFact = CatFact(fact: "A mocked fact")
        let sut = CatFactView.ViewModel(dependencies: .init(fetchFact: {
            mockFact
        }))

        // When
        await sut.fetch()

        // Then
        XCTAssertEqual(sut.state.info, mockFact)
    }

    func testFetchCatFactSuccessStates() {
        // Given
        let mockFact = CatFact(fact: "A mocked fact")
        let sut = CatFactView.ViewModel(dependencies: .init(fetchFact: {
            mockFact
        }))

        AssertState().assert(
            when: {
                Task {
                    await sut.fetch()
                }
            },
            type: ViewState<CatFact>.self,
            testCase: self,
            publisher: sut.$state,
            valuesLimit: 3,
            initialAssertions: {
                XCTAssertEqual(sut.state, .initial)
            },
            valuesAssertions: { values in
                // Then
                XCTAssertEqual(values.map { $0 }, [.initial, .loading, .loaded(mockFact)])
            }
        )
    }

    func testFetchCatFactError() async {
        // Given
        let error = NSError(domain: "12", code: 12)
        let sut = CatFactView.ViewModel(dependencies: .init(fetchFact: {
            throw error
        }))

        // When
        await sut.fetch()

        // Then
        XCTAssertEqual(sut.state, .error(error))
    }

    func testFetchCatFactErrorStates() {
        // Given
        let error = NSError(domain: "12", code: 12)
        let sut = CatFactView.ViewModel(dependencies: .init(fetchFact: {
            throw error
        }))

        AssertState().assert(
            when: {
                Task {
                    await sut.fetch()
                }
            },
            type: ViewState<CatFact>.self,
            testCase: self,
            publisher: sut.$state,
            valuesLimit: 3,
            initialAssertions: {
                XCTAssertEqual(sut.state, .initial)
            },
            valuesAssertions: { values in
                // Then
                XCTAssertEqual(values.map { $0 }, [.initial, .loading, .error(error)])
            }
        )
    }

    func testMemoryDeallocation() {
        // Given
        let mockFact = CatFact(fact: "A mocked fact")
        let sut = CatFactView.ViewModel(dependencies: .init(fetchFact: {
            mockFact
        }))

        // Then
        assertMemoryDeallocation(in: sut)
    }
}
