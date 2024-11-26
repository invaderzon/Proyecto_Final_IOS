import Foundation

final class ResultadoBusquedaViewModel {
    public private(set) var results: ResultadoBusquedaType
    private var next: String?

    init(results: ResultadoBusquedaType, next: String?) {
        self.results = results
        self.next = next
    }

    public private(set) var isLoadingMoreResults = false

    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }

    public func fetchAdditionalLocations(completion: @escaping ([LocacionTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }

        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreResults = true

        guard let request = Solicitud(url: url) else {
            isLoadingMoreResults = false
            return
        }

        Servicio.shared.execute(request, expecting: ObtenerRespuestaLocaciones.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next // Capturar la url de paginacion

                let additionalLocations = moreResults.compactMap({
                    return LocacionTableViewCellViewModel(location: $0)
                })
                var newResults: [LocacionTableViewCellViewModel] = []

                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                case .characters, .episodes:
                    break
                }

                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false

                    // Notificar por llamada
                    completion(newResults)
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreResults = false
            }
        }
    }

    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }

        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreResults = true

        guard let request = Solicitud(url: url) else {
            isLoadingMoreResults = false
            return
        }

        switch results {
        case .characters(let existingResults):
            Servicio.shared.execute(request, expecting: ObtenerTodasLasRespuestasPersonajes.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next 

                    let additionalResults = moreResults.compactMap({
                        return PersonajeCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image))
                    })
                    var newResults: [PersonajeCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    strongSelf.results = .characters(newResults)

                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false

                        // Notify via callback
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .episodes(let existingResults):
            Servicio.shared.execute(request, expecting: ObtenerTodasLasRespuestasLocaciones.self) { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    strongSelf.next = info.next 

                    let additionalResults = moreResults.compactMap({
                        return PersonajeEpisodioCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    var newResults: [PersonajeEpisodioCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    strongSelf.results = .episodes(newResults)

                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false

                        
                        completion(newResults)
                    }
                case .failure(let failure):
                    print(String(describing: failure))
                    self?.isLoadingMoreResults = false
                }
            }
        case .locations:
            // TableView 
            break
        }


    }
}

enum ResultadoBusquedaType {
    case characters([PersonajeCollectionViewCellViewModel])
    case episodes([PersonajeEpisodioCollectionViewCellViewModel])
    case locations([LocacionTableViewCellViewModel])
}