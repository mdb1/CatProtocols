//
//  CatFactViewModel.swift
//  CatProtocols
//
//  Created by Manu on 13/02/2023.
//

import SwiftUI

extension CatFactView {
    @MainActor final class ViewModel: ObservableObject {
        @Published var state: ViewState<CatFact> = .initial
        private let service: FetchCatFactProtocol

        init(service: FetchCatFactProtocol) {
            self.service = service
        }

        func fetch() {
            Task {
                do {
                    state = .loading
                    let fact = try await service.fetchCatFact()
                    withAnimation { state = .loaded(fact) }
                } catch {
                    withAnimation { state = .error(error) }
                }
            }
        }
    }
}
