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
        
        let request = DNDRequest(
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
            }
        
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
