//
//  PersonajeListViewViewModel.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import UIKit

protocol PersonajeListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    
    func didSelectCharacter(_ character: Personaje)
}

/// View Model para manejar la logica de la logica de list view
final class RMCharacterListViewViewModel: NSObject {
    public weak var delegate: PersonajeListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [Personaje] = [] {
        didSet {
            for character in characters {
                let viewModel = PersonajeCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [PersonajeCollectionViewCellViewModel] = []
    
    private var apiInfo: ObtenerTodasLasRespuestasPersonajes? = nil
    
    /// Obtener iel set inicial de 20 personajes
    public func fetchCharacters() {
        Servicio.shared.execute(
            .listaSolicitudesPersonaje,
            expecting: ObtenerTodasLasRespuestasPersonajes.self
        ) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel
                //let info = responseModel                self?.characters = results
                //self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

    /// Paginar si se necesitan personajes adicionales
    public func fetchAdditionalCharacters(url: URL){
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        guard let request = Solicitud(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        Servicio.shared.execute(request, expecting: ObtenerTodasLasRespuestasPersonajes.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel
                let info = responseModel
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResults
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(
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
        return apiInfo != nil
    }
}



