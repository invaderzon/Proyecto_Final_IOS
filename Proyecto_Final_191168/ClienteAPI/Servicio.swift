//
//  Servicio.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

/// Servicio Primario API, un objeto para obtener los datos de Doctor Who
final class Servicio {
    /// Instancia singular conpartida
    static let shared = Servicio()
    
    private let cacheManager = APICacheManager()
    
    /// Constructor privado
    private init() {}
    
    // Tipos de errores (No se pudo hacer la solicitud o no se pudo obtener los datos)
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Mandar llamada a la API de Doctor Who
    /// - Parameters:
    ///   - request: Instancia de solicitud
    ///   - type: Tipo de objeto que esperamos recibir
    ///   - completion: Respuesta con informacion o error
    public func execute<T: Codable>(
        _ request: Solicitud,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if let cachedData = cacheManager.cachedResponse(
            for: request.endpoint,
            url: request.url
        ){
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
            return
        }
        
        guard let urlRequest = self.request(from: request)
        else {
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }
            
            // Decodificar respuesta
            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(
                    for: request.endpoint,
                    url: request.url,
                    data: data
                )
                completion(.success(result))
            }
            catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func request(from dwRequest: Solicitud) -> URLRequest? {
        guard let url = dwRequest.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = dwRequest.httpMethod
        return request
    }
}
