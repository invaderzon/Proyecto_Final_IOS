//
//  PersonajeEpisodioCollectionViewCellViewModel.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import UIKit


protocol EpisodioDataRender {
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class PersonajeEpisodioCollectionViewCellViewModel: Hashable, Equatable {


  private let episodeDataUrl: URL?
  private var isFetching = false
  private var dataBlock: ((EpisodioDataRender) -> Void)?

  public let borderColor: UIColor

  private var episode: Episodio? {
      didSet {
          guard let model = episode else {
              return
          }
          dataBlock?(model)
      }
  }

  // MARK: - Init

  init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
      self.episodeDataUrl = episodeDataUrl
      self.borderColor = borderColor
  }

  // MARK: - Public

  public func registerForData(_ block: @escaping (EpisodioDataRender) -> Void) {
      self.dataBlock = block
  }

  public func fetchEpisode() {
      guard !isFetching else {
          if let model = episode {
              dataBlock?(model)
          }
          return
      }

      guard let url = episodeDataUrl,
            let request = Solicitud(url: url) else {
          return
      }

      isFetching = true

      Servicio.shared.execute(request, expecting: Episodio.self) { [weak self] result in
          switch result {
          case .success(let model):
              DispatchQueue.main.async {
                  self?.episode = model
              }
          case .failure(let failure):
              print(String(describing: failure))
          }
      }
  }

  func hash(into hasher: inout Hasher) {
      hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
  }

  static func == (lhs: PersonajeEpisodioCollectionViewCellViewModel, rhs: PersonajeEpisodioCollectionViewCellViewModel) -> Bool {
      return lhs.hashValue == rhs.hashValue
  }
}