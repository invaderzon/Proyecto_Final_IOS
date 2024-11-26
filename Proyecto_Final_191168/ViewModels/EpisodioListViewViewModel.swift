//
//  PersonajeCollectionViewCellViewModel.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//


import UIKit

protocol EpisodioListViewViewModelDelegate: AnyObject {
  func didLoadInitialEpisodes()
  func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])

  func didSelectEpisode(_ episode: Episodio)
}

/// View Model para la logica de la lista de los episodios
final class EpisodioListViewViewModel: NSObject {
  public weak var delegate: EpisodioListViewViewModelDelegate?

  private var isLoadingMoreCharacters = false

  private let borderColors: [UIColor] = [
      .systemGreen,
      .systemBlue,
      .systemOrange,
      .systemPink,
      .systemPurple,
      .systemRed,
      .systemYellow,
      .systemIndigo,
      .systemMint
  ]

  private var episodes: [Episodio] = [] {
      didSet {
          for episode in episodes {
              let viewModel = PersonajeEpisodioCollectionViewCellViewModel(
                  episodeDataUrl: URL(string: episode.url),
                  borderColor: borderColors.randomElement() ?? .systemBlue
              )
              if !cellViewModels.contains(viewModel) {
                  cellViewModels.append(viewModel)
              }
          }
      }
  }

  private var cellViewModels: [PersonajeEpisodioCollerctionViewCellViewModel] = []

  private var apiInfo: ObtenerTodosLosEpisodiosRespuesta.Info? = nil

  /// Capturar el set inicial de 20 episodios
  public func fetchEpisodes() {
      Servicio.shared.execute(
          .listEpisodesRequest,
          expecting: ObtenerTodosLosEpisodiosRespuesta.self
      ) { [weak self] result in
          switch result {
          case .success(let responseModel):
              let results = responseModel.results
              let info = responseModel.info
              self?.episodes = results
              self?.apiInfo = info
              DispatchQueue.main.async {
                  self?.delegate?.didLoadInitialEpisodes()
              }
          case .failure(let error):
              print(String(describing: error))
          }
      }
  }

  /// Carga si se necesitan episodios adicionales
  public func fetchAdditionalEpisodes(url: URL) {
      guard !isLoadingMoreCharacters else {
          return
      }
      isLoadingMoreCharacters = true
      guard let request = Solicitud(url: url) else {
          isLoadingMoreCharacters = false
          return
      }

      Servicio.shared.execute(request, expecting: ObtenerTodasLasRespuestasEpisodios.self) { [weak self] result in
          guard let strongSelf = self else {
              return
          }
          switch result {
          case .success(let responseModel):
              let moreResults = responseModel.results
              let info = responseModel.info
              strongSelf.apiInfo = info

              let originalCount = strongSelf.episodes.count
              let newCount = moreResults.count
              let total = originalCount+newCount
              let startingIndex = total - newCount
              let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                  return IndexPath(row: $0, section: 0)
              })
              strongSelf.episodes.append(contentsOf: moreResults)

              DispatchQueue.main.async {
                  strongSelf.delegate?.didLoadMoreEpisodes(
                      with: indexPathsToAdd
                  )

                  strongSelf.isLoadingMoreCharacters = false
              }
          case .failure(let failure):
              print(String(describing: failure))
              self?.isLoadingMoreCharacters = false
          }
      }
  }
  public var shouldShowLoadMoreIndicator: Bool {
      return apiInfo?.next != nil
  }
}

extension EpisodioListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cellViewModels.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PersonajeEpisodioCollectionViewCell.cellIdentifier,
      for indexPath
    ) as? PersonajeEpisodioCollectionViewCell else {
      fatalError("No se pudo devolver el cell")
    }
    cell.configure(with: cellViewModels[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      guard kind == UICollectionView.elementKindSectionFooter,
            let footer = collectionView.dequeueReusableSupplementaryView(
              ofKind: kind,
              withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
              for: indexPath
            ) as? FooterLoadingCollectionReusableView else {
          fatalError("Unsupported")
      }
      footer.startAnimating()
      return footer
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
      guard shouldShowLoadMoreIndicator else {
          return .zero
      }

      return CGSize(width: collectionView.frame.width,
                    height: 100)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let bounds = collectionView.bounds
      let width = bounds.width-20
      return CGSize(
          width: width,
          height: 100
      )
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      collectionView.deselectItem(at: indexPath, animated: true)
      let selection = episodes[indexPath.row]
      delegate?.didSelectEpisode(selection)
  }
}

extension EpisodioListViewViewModel: EpisodioListViewViewModelDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
      guard shouldShowLoadMoreIndicator,
            !isLoadingMoreCharacters,
            !cellViewModels.isEmpty,
            let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString) else {
          return
      }
      Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
          let offset = scrollView.contentOffset.y
          let totalContentHeight = scrollView.contentSize.height
          let totalScrollViewFixedHeight = scrollView.frame.size.height

          if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
              self?.fetchAdditionalEpisodes(url: url)
          }
          t.invalidate()
      }
  }
}