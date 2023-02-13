//
//  CatProtocolsTests.swift
//  CatProtocolsTests
//
//  Created by Manu on 13/02/2023.
//

import XCTest
@testable import CatProtocols

@MainActor final class CatFactViewModelTests: XCTestCase {
    func testFetchCatFactSuccess() {
        // Given
        let mockFact = CatFact(fact: "A mocked fact")
        let sut = CatFactView.ViewModel(service: FetchCatServiceMock(
            throwsError: false,
            sleepNanoseconds: 0
        ))

        // When
        sut.fetch()

        // Then
        asyncAssert("Fetch, then update the state") {
            XCTAssertEqual(sut.state.info, mockFact)
        }
    }

    func testFetchCatFactSuccessStates() {
        // Given
        let mockFact = CatFact(fact: "A mocked fact")
        let sut = CatFactView.ViewModel(service: FetchCatServiceMock(
            throwsError: false,
            sleepNanoseconds: 0
        ))

        AssertState().assert(
            when: {
                // When
                sut.fetch()
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

    func testFetchCatFactError() {
        // Given
        let sut = CatFactView.ViewModel(service: FetchCatServiceMock(
            throwsError: true,
            sleepNanoseconds: 0
        ))

        // When
        sut.fetch()

        // Then
        asyncAssert("Fetch, then update the state") {
            XCTAssertEqual(sut.state, .error(NSError(domain: "1", code: 1)))
        }
    }

    func testFetchCatFactErrorStates() {
        // Given
        let sut = CatFactView.ViewModel(service: FetchCatServiceMock(
            throwsError: true,
            sleepNanoseconds: 0
        ))

        AssertState().assert(
            when: {
                // When
                sut.fetch()
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
                XCTAssertEqual(
                    values.map { $0 },
                    [.initial, .loading, .error(NSError(domain: "1", code: 1))]
                )
            }
        )
    }

    func testMemoryDeallocation() {
        // Given
        let sut = CatFactView.ViewModel(service: FetchCatServiceMock(throwsError: false))

        // Then
        assertMemoryDeallocation(in: sut)
    }
}
