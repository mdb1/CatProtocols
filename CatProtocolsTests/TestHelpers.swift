//
//  TestHelpers.swift
//  CatProtocolsTests
//
//  Created by Manu on 13/02/2023.
//

import Combine
import XCTest

public extension XCTestCase {
    /// This is a method to determine that an instance gets deallocated from memory correctly; ie: no memory leaks 😄.
    /// It leverages the `addTeardownBlock` method on `XCTest`:
    /// `* Teardown blocks are executed after the current test method has returned but before tearDown is invoked.`
    func assertMemoryDeallocation(
        in instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should have been deallocated. Potential memory leak!",
                file: file,
                line: line
            )
        }
    }
}

/// Runs the assertions provided for the publisher variable.
public class AssertState {
    private var subscribers: Set<AnyCancellable> = []
    /// Initializes AssertState object.
    public init() {}
}

public extension AssertState {
    /// Runs the assertions provided for the publisher variable.
    /// Useful for testing ValueState objects.
    /// - Parameters:
    ///   - when: The method triggering the publisher values.
    ///   - type: The type of the values emitted by the publisher.
    ///   - testCase: The object running the test case.
    ///   - publisher: The publisher emitting the state changes.
    ///   - valuesLimit: The maximum amount of values emitted by the publisher. Default is `3`.
    ///   - initialAssertions: The initial assertions, before executing the `when` closure.
    ///   - valueAssertions: The assertions considering the values emitted by the publisher.
    func assert<T>(
        when: () -> Void,
        type _: T.Type,
        testCase: XCTestCase,
        publisher: any Publisher<T, Never>,
        valuesLimit: Int = 3,
        initialAssertions: () -> Void,
        valuesAssertions: @escaping ([T]) -> Void
    ) {
        var stateValues = [T]()
        let expectation = XCTestExpectation(description: "Awaits published values, then finishes")
        initialAssertions()
        publisher.sink { value in
            stateValues.append(value)
            if stateValues.count == valuesLimit {
                valuesAssertions(stateValues)
                expectation.fulfill()
            } else if stateValues.count > valuesLimit {
                XCTFail("Expecting only \(valuesLimit) values")
            }
        }.store(in: &subscribers)
        when()
        testCase.wait(for: [expectation], timeout: 0.5)
    }
}
