//
//  ContentView.swift
//  CatProtocols
//
//  Created by Manu on 13/02/2023.
//

import SwiftUI

struct CatFactView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            switch viewModel.state {
            case .initial:
                EmptyView()
            case .loading:
                ProgressView()
            case let .loaded(fact):
                Text(fact.fact)
            case .error:
                Text("Error")
                    .foregroundColor(.red)
            }
            Button("Fetch another") {
                viewModel.fetch()
            }
            .disabled(viewModel.state.isLoading)
        }
        .padding()
        .task {
            viewModel.fetch()
        }
    }
}

#if DEBUG

struct FetchCatServiceMock: FetchCatFactProtocol {
    var throwsError: Bool
    var sleepNanoseconds: UInt64 = 1_000_000_000
    func fetchCatFact() async throws -> CatFact {
        try await Task.sleep(nanoseconds: sleepNanoseconds)
        if throwsError {
            throw NSError(domain: "1", code: 1)
        } else {
            return .init(fact: "A mocked fact")
        }
    }
}

struct CatFactView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CatFactView(viewModel: .init(service: FetchCatServiceMock(throwsError: false)))
            CatFactView(viewModel: .init(service: FetchCatServiceMock(throwsError: true)))
            Spacer()
        }
    }
}

#endif
