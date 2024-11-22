//
//  ClassesListViewViewModel.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/21/24.
//

import UIKit


final class ClassesListViewViewModel: NSObject {

    private var classes: [DNDClasses] = []

    private var cellViewModels: [ClassCollectionViewCellViewModel] = [] {
        didSet {
            for clase in classes {
                let viewModel = ClassCollectionViewCellViewModel(
                                                                 nombreClase: clase.name, 
                    imagenUrlclase: URL(string: clase.image),
                    cellViewModels.append(viewModel))
            }
        }
    }
    
    public func fetchClasses() {
        DNDService.shared.execute(.listaSolicitudesClases, expecting: DNDObtenerTodasRespuestasClases.self) 
        { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?._classes = results
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension ClassesListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ClassCollectionViewCell.cellIdentifier, 
            for: indexPath
        ) as? ClassCollectionViewCell else {
            fatalError("No sale la celda")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
}
