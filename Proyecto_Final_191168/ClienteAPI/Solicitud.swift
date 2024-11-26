//
//  Solicitud.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

final class Solicitud {
    // Constantes de la API
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    
    // endpoint deseado
    let endpoint: Endpoint
    
    /// Componentes del path para API, si hay
    private let pathComponents: [String]
    
    /// Arguments de busqueda para API,  si hay
    private let queryParameters: [URLQueryItem]
    
    /// Url construida para la solicitud api en format string
    private var urlString: String {
        var string = Constants.baseUrl
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
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        return string
    }
    
    /// API url procesada y construida
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// http method
    public let httpMethod = "GET"
    
    
    // Construct request
    /// - Parameters:
    ///   - endpoint: Endpoint objetivo
    ///   - pathComponents: Coleccion de Path components
    ///   - queryParameters: Coleccion de parametros de busqueda
    public init(
        endpoint: Endpoint,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    /// Intento de crear una solicitud
    /// - Parameter url: URL to analizar
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0] // Endpoint
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = Endpoint(
                    rawValue: endpointString
                ) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    
                    return URLQueryItem(
                        name: parts[0],
                        value: parts[1]
                    )
                })
                
                if let rmEndpoint = Endpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        
        return nil
    }
}

extension Solicitud {
    static let listaSolicitudesPersonaje = Solicitud(endpoint: .character)
    static let listaSolicitudesEpisodios = Solicitud(endpoint: .episode)
    static let listaSolicitudesLocaciones = Solicitud(endpoint: .location)
}
