//
//  PersonajeCollectionViewCellViewModel.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import UIKit

protocol EpisodioDetallesViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

final class EpisodioDetallesViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (episode: Episodio, characters: [Personaje])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }

    enum SectionType {
        case information(viewModels: [EpisodioInfoCollectionViewCellViewModel])
        case characters(viewModel: [PersonajeCollectionViewCellViewModel])
    }

    public weak var delegate: EpisodioDetallesViewViewModelDelegate?

    public private(set) var cellViewModels: [SectionType] = []

    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }

    public func character(at index: Int) -> Personaje? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }

    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {
            return
        }

        let episode = dataTuple.episode
        let characters = dataTuple.characters

        var createdString = episode.created
        if let date = PersonajeInfoCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = PersonajeInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return PersonajeCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
            }))
        ]
    }

    /// Captura modelo de episodio
    public func fetchEpisodeData() {
        guard let url = endpointUrl,
              let request = Solicitud(url: url) else {
            return
        }

        Servicio.shared.execute(request,
                                 expecting: Episodio.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }

    private func fetchRelatedCharacters(episode: Episodio) {
        let requests: [Solicitud] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return Solicitud(url: $0)
        })

        // 10 solicitudes paralelas
        // Notificar cuando se completen

        let group = DispatchGroup()
        var characters: [Personaje] = []
        for request in requests {
            group.enter()
            Servicio.shared.execute(request, expecting: Personaje.self) { result in
                defer {
                    group.leave()
                }

                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }

        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
}