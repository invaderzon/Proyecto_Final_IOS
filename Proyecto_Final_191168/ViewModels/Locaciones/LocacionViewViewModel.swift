import Foundation

protocol LocacionViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class LocacionViewViewModel {

    weak var delegate: LocacionViewViewModelDelegate?

    private var locations: [Locacion] = [] {
        didSet {
            for location in locations {
                let cellViewModel = LocacionTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }

    // Respuesta info de locacion
    // Si tiene mas de una pagina
    private var apiInfo: ObtenerRespuestaLocaciones.Info?

    public private(set) var cellViewModels: [LocacionTableViewCellViewModel] = []

    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    public var isLoadingMoreLocations = false

    private var didFinishPagination: (() -> Void)?

    init() {}

    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }

    /// Paginar si se necesitan locaciones adicionales
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }

        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreLocations = true

        guard let request = Solicitud(url: url) else {
            isLoadingMoreLocations = false
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
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return LocacionTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false

                    // Notificar por llamada
                    strongSelf.didFinishPagination?()
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreLocations = false
            }
        }
    }

    public func location(at index: Int) -> Locacion? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }

    public func fetchLocations() {
        Servicio.shared.execute(
            .listLocationsRequest,
            expecting: ObtenerRespuestaLocaciones.self
        ) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
    }

    private var hasMoreResults: Bool {
        return false
    }
}