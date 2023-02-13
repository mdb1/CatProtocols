//
//  CatService.swift
//  CatProtocols
//
//  Created by Manu on 13/02/2023.
//

import CoreNetworking
import Foundation

protocol FetchCatFactProtocol {
    func fetchCatFact() async throws -> CatFact
}

protocol UpdateCatInformationProtocol {
    func updateName(id: String) async throws
}

struct CatService {}

extension CatService: FetchCatFactProtocol {
    func fetchCatFact() async throws -> CatFact {
        /// This is using: https://github.com/mdb1/CoreNetworking
        try await HTTPClient.shared
            .execute(
                .init(
                    urlString: "https://catfact.ninja/fact/",
                    method: .get([]),
                    headers: [:]
                ),
                responseType: CatFact.self
            )
    }
}

extension CatService: UpdateCatInformationProtocol {
    func updateName(id: String) async throws {
        // Some networking code
    }
}

