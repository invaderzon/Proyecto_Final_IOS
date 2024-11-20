//
//  DNDSource.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/13/24.
//

import Foundation

/// Objeto primario de servicio para obtener datos de DND
final class DNDService {
    
    /// Instancia compartida
    static let shared = DNDService()
    
    private init() {}
    
    enum DNDServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Enviar llamada a la API
    /// - Parameters:
    /// - request:  Instancia de request
    /// - type: El tipo de objeto que esperamos obtener
    /// - completion: Llamada con datos o error
    
    public func execute<T: Codable>(
        _ request: DNDRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(DNDServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? DNDServiceError.failedToGetData))
                return
            }
            
            //Decodifica la respuesta
            do {
                let results = try JSONDecoder().decode(type.self, from: data)
                completion(.success(results))
                //
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func request(from dndRequest: DNDRequest) -> URLRequest? {
        guard let url = dndRequest.url else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = dndRequest.httpMethod
        return request
    }
}
