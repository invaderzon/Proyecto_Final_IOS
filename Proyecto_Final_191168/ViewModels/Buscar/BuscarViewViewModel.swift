import Foundation

final class BuscarViewViewModel {
    let config: BuscarViewController.Config
    private var optionMap: [BuscarInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""

    private var optionMapUpdateBlock: (((BuscarInputViewViewModel.DynamicOption, String)) -> Void)?

    private var searchResultHandler: ((ResultadosBusquedaViewModel) -> Void)?

    private var noResultsHandler: (() -> Void)?

    private var searchResultModel: Codable?

    init(config: BuscarViewController.Config) {
        self.config = config
    }

    public func registerSearchResultHandler(_ block: @escaping (ResultadoBusquedaViewModel) -> Void) {
        self.searchResultHandler = block
    }

    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }

    public func executeSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        // Construir argumentos
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        // Agregar opciones
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: BuscarInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))

        // Crear solicitud
        let request = Solicitud(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )

        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(ObtenerTodasLasRespuestasPersonajes.self, request: request)
        case .episode:
            makeSearchAPICall(ObtenerTodasLasRespuestaEpisodios.self, request: request)
        case .location:
            makeSearchAPICall(ObtenerRespuestaLocaciones.self, request: request)
        }
    }

    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: Solicitud) {
        Servicio.shared.execute(request, expecting: type) { [weak self] result in
            // Notifica la lista de los resultados, si hay, o un error

            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }

    private func processSearchResults(model: Codable) {
        var resultsVM: ResultadosBusquedaType?
        var nextUrl: String?
        if let characterResults = model as? ObtenerTodasLasRespuestasPersonajes {
            resultsVM = .characters(characterResults.results.compactMap({
                return PersonajeCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image)
                )
            }))
            nextUrl = characterResults.info.next
        }
        else if let episodesResults = model as? ObtenerTodasLasRespuestasEpisodios {
            resultsVM = .episodes(episodesResults.results.compactMap({
                return PersonajeEpisodioCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )
            }))
            nextUrl = episodesResults.info.next
        }
        else if let locationsResults = model as? ObtenerRespuestaLocaciones {
            resultsVM = .locations(locationsResults.results.compactMap({
                return LocacionTableViewCellViewModel(location: $0)
            }))
            nextUrl = locationsResults.info.next
        }

        if let results = resultsVM {
            self.searchResultModel = model
            let vm = ResultadoBusquedaViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(vm)
        } else {
            // error
            handleNoResults()
        }
    }

    private func handleNoResults() {
        noResultsHandler?()
    }

    public func set(query text: String) {
        self.searchText = text
    }

    public func set(value: String, for option: BuscarInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(
        _ block: @escaping ((BuscarInputViewViewModel.DynamicOption, String)) -> Void
    ) {
        self.optionMapUpdateBlock = block
    }

    public func locationSearchResult(at index: Int) -> Locacion? {
        guard let searchModel = searchResultModel as? ObtenerRespuestaLocaciones else {
            return nil
        }
        return searchModel.results[index]
    }

    public func characterSearchResult(at index: Int) -> Personaje? {
        guard let searchModel = searchResultModel as? ObtenerTodasLasRespuestasPersonajes else {
            return nil
        }
        return searchModel.results[index]
    }

    public func episodeSearchResult(at index: Int) -> Episodio? {
        guard let searchModel = searchResultModel as? ObtenerTodasLasRespuestaEpisodios else {
            return nil
        }
        return searchModel.results[index]
    }
}