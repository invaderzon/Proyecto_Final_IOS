//
//  DNDRequest.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/13/24.
//

import Foundation

/// Objeto que representa una llamada de API
final class DNDRequest {
    /// Constantes de API
    private struct Constantes {
        static let baseUrl = "https://api.open5e.com"
    }
    
    // Endpoint deseado
    private let endpoint: DNDEndpoint
    // Componentes de ruta para la API, si hay
    private let pathComponents: [String]
    
    // Argumentos de busqueda para la API, si hay
    private let queryParameters: [URLQueryItem]
    
    ///  Estructura para la solicitud de api en formato de cadena
    private var urlString: String {
        var string = Constantes.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
                
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    /// URL de la API ya construida
    public var url: URL?
    {
        return URL(string: urlString)
    }
    
    /// Método http deseado
    public let httpMethod = "GET"
    

    /// Solicitud con parametros
    public init(
    endpoint: DNDEndpoint,
    pathComponents: [String] = [],
    queryParameters: [URLQueryItem] = []
    ){
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    
}
