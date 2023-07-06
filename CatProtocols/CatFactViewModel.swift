//
//  CatFactViewModel.swift
//  CatProtocols
//
//  Created by Manu on 13/02/2023.
//

import SwiftUI

extension CatFactView {
    @MainActor
    final class ViewModel: ObservableObject {
        @Published var state: ViewState<CatFact> = .initial
        private let dependencies: Dependencies

        init(dependencies: Dependencies = .default) {
            self.dependencies = dependencies
        }

        func fetch() async {
            do {
                state = .loading
                let fact = try await dependencies.fetchFact()
                state = .loaded(fact)
            } catch {
                state = .error(error)
            }
        }
    }
}

extension CatFactView.ViewModel {
    struct Dependencies {
        // Notice how the view model doesn't care about the implementation,
        // as long as we provide anything that conform to this signature,
        // the view model will compile correctly.
        var fetchFact: () async throws -> CatFact
    }
}

extension CatFactView.ViewModel.Dependencies {
    static var `default`: Self {
        .init(fetchFact: CatService().fetchCatFact)
    }
}
