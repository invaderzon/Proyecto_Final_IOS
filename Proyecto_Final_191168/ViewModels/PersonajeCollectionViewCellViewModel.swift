//
//  PersonajeCollectionViewCellViewModel.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

final class PersonajeCollectionViewCellViewModel: Hashable, Equatable {
    public let characterName: String
    private let characterStatus: PersonajeStatus
    private let characterImageUrl: URL?
    
    init(
        characterName: String,
        characterStatus: PersonajeStatus,
        characterImageUrl: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String {
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
      
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        ImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    static func == (lhs: PersonajeCollectionViewCellViewModel, rhs: PersonajeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
}
