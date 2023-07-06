//
//  ContentView.swift
//  CatProtocols
//
//  Created by Manu on 13/02/2023.
//

import SwiftUI

struct CatFactView: View {
    @StateObject var viewModel: ViewModel = .init()

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
                Task {
                    await viewModel.fetch()
                }
            }
            .disabled(viewModel.state.isLoading)
        }
        .padding()
        .task {
            await viewModel.fetch()
        }
    }
}

#if DEBUG

struct CatFactView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CatFactView(viewModel: .init(dependencies: .init(fetchFact: {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                return .init(fact: "A mocked fact")
            })))

            CatFactView(viewModel: .init(dependencies: .init(fetchFact: {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                throw NSError(domain: "domain", code: 123)
            })))

            Spacer()
        }
    }
}

#endif
