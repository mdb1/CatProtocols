//
//  ViewState.swift
//  CatProtocols
//
//  Created by Manu on 13/02/2023.
//

import Foundation

/// Enum that represents the state of a view that loads information from the backend.
enum ViewState<Info: Any> {
    /// Represents non state. Useful when used in combination with other ViewState.
    case initial
    /// Represents the loading state.
    case loading
    /// Represents an error.
    case error(_: Error)
    /// Represents that the information has been loaded correctly.
    case loaded(_ info: Info)

    /// Returns true if state is loading.
    var isLoading: Bool {
        guard case .loading = self else { return false }
        return true
    }

    /// Returns info associated to loaded state.
    var info: Info? {
        guard case let .loaded(info) = self else { return nil }
        return info
    }

    /// Returns info associated to error state.
    var error: Error? {
        guard case let .error(error) = self else { return nil }
        return error
    }
}

extension ViewState: Equatable {
    public static func == (lhs: ViewState<Info>, rhs: ViewState<Info>) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            return true
        case (.loading, .loading):
            return true
        case (.loaded, .loaded):
            return true
        case (.error, .error):
            return true
        default:
            return false
        }
    }
}
