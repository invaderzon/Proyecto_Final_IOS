//
//  ClassesListViewViewModel.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/21/24.
//

import UIKit

final class ClassesListViewViewModel: NSObject {
    func fetchClasses() {
        DNDService.shared.execute(.listaSolicitudesClases, expecting: DNDObtenerTodasRespuestasClases.self) { result in
            switch result {
            case .success(let model):
                print("Total: " + String(model.results.count))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension ClassesListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGreen
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
