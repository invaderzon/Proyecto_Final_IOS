import UIKit

protocol BuscarViewDelegate: AnyObject {
    func rmSearchView(_ searchView: BuscarView, didSelectOption option: BuscarInputViewViewModel.DynamicOption)

    func rmBuscarView(_ searchView: BuscarView, didSelectLocation location: Locacion)
    func rmSearchView(_ searchView: BuscarView, didSelectCharacter character: Personaje)
    func rmSearchView(_ searchView: BuscarView, didSelectEpisode episode: Episodio)
}

final class BuscarView: UIView {

    weak var delegate: BuscarViewDelegate?

    private let viewModel: BuscarViewViewModel

    // MARK: - Subviews

    private let searchInputView = BuscarInputView()

    private let noResultsView = SinResultadosBusquedaView()

    private let resultsView = ResultadosBusquedaView()

    // Results collectionView

    // MARK: - Init

    init(frame: CGRect, viewModel: BuscarViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraints()

        searchInputView.configure(with: BuscarInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self

        setUpHandlers(viewModel: viewModel)

        resultsView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUpHandlers(viewModel: BuscarViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }

        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }

        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),

            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - CollectionView

extension BuscarView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)


    }
}

// MARK: - BuscarInputViewDelegate

extension BuscarView: BuscarInputViewDelegate {
    func rmBuscarInputView(_ inputView: BuscarInputView, didSelectOption option: BuscarInputViewViewModel.DynamicOption) {
        delegate?.rmBuscarView(self, didSelectOption: option)
    }

    func rmBuscarInputView(_ inputView: BuscarInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }

    func rmBuscarInputViewDidTapSearchKeyboardButton(_ inputView: BuscarInputView) {
        viewModel.executeSearch()
    }
}

// MARK: - ResultadosBusquedaViewDelegate

extension BuscarView: ResultadosBusquedaViewDelegate {
    func rmResultadosBusquedaView(_ resultsView: ResultadosBusquedaView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.rmBuscarView(self, didSelectLocation: locationModel)
    }

    func rmResultadosBusquedaView(_ resultsView: ResultadosBusquedaView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else {
            return
        }
        delegate?.rmBuscarView(self, didSelectEpisode: episodeModel)
    }

    func rmResultadosBusquedaView(_ resultsView: ResultadosBusquedaView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResult(at: index) else {
            return
        }
        delegate?.rmBuscarView(self, didSelectCharacter: characterModel)
    }
}