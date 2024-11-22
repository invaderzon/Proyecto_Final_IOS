//
//  ClassViewController.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/8/24.
//

import UIKit

/// Controlador para mostrar y buscar clases
final class ClassViewController: UIViewController {
    
    private let classesListView = ClassesListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Clases"
        
        setUpView()

        
        
        /// Para comprobar el funcionamiento dela conexión a API classes
        /*DNDService.shared.execute(.listaSolicitudesClases,
                                  expecting: DNDObtenerTodasRespuestasClases.self) { result in
            switch result {
            case .success(let model):
                print("Total: " + String(model.results.count))
            case .failure(let error):
                print(String(describing: error))
            }}*/
        
        
        
        /*let request = DNDRequest( //Prueba para comprobar el funcionamiento de una solicitud
            endpoint: .classes,
            pathComponents: ["bard"]/*,
            queryParameters: [
                URLQueryItem(name: "search", value: "Bard")]*/
        )
        print (request.url)
        
        DNDService.shared.execute(request, expecting: DNDClasses.self){ result in 
            switch result {
            case .success:
                break
            case .failure(let error):
                print(String(describing: error))
            
        
        }}*/
    }

    private func setUpView(){
        view.addSubview(classesListView)
        NSLayoutConstraint.activate([
            classesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            classesListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            classesListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            classesListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
}
