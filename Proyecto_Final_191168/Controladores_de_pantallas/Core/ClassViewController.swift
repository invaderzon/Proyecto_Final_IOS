//
//  ClassViewController.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/8/24.
//

import UIKit

/// Controlador para mostrar y buscar clases
final class ClassViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Clases"
        
        DNDService.shared.execute(.listaSolicitudesClases,
                                  expecting: DNDObtenerTodasRespuestasClases.self) { result in
            switch result {
            case .success(let model):
                print(String(describing:model))
            case .failure(let error):
                print(String(describing: error))
            }}
        
        /*let request = DNDRequest( //Prueba para comprobar el funcionamiento de una solicitud
            endpoint: .v1,
            pathComponents: ["classes"],
            queryParameters: [
                URLQueryItem(name: "search", value: "Bard")
            
            ]
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

}
