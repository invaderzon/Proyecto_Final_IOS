import Foundation


protocol LocacionDetallesViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class LocacionDetallesViewViewModel {
    private let endpointUrl: URL?
    private var dataTuple: (location: Locacion, characters: [Personaje])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }

    enum SectionType {
        case information(viewModels: [EpisodioInfoCollectionViewCellViewModel])
        case characters(viewModel: [PersonajeCollectionViewCellViewModel])
    }

    public weak var delegate: LocacionDetailViewViewModelDelegate?

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

        let location = dataTuple.location
        let characters = dataTuple.characters

        var createdString = location.created
        if let date = PersonajeInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = PersonajeInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }

        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
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

    /// Obtener respaldo del modelo de locación
    public func fetchLocationData() {
        guard let url = endpointUrl,
              let request = Solicitud(url: url) else {
            return
        }

        Servicio.shared.execute(request,
                                 expecting: Locacion.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
            case .failure:
                break
            }
        }
    }

    private func fetchRelatedCharacters(location: Locacion) {
        let requests: [Solicitud] = location.residents.compactMap({
            return URL(string: $0)
        }).compactMap({
            return Solicitud(url: $0)
        })

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
                location: location,
                characters: characters
            )
        }
    }
}