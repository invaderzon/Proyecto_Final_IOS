//
//  ImageLoader.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

// Manejar para caragr imagenes
final class ImageLoader {
    // Instancia Compartida
    static let shared = ImageLoader()
    
    /// data cache en memoria
    private var imageDataCache = NSCache<NSString, NSData>()
    
    /// Constructor
    private init() {}
    
    /// Obtener contenido de la imagen  con una url
    /// - Parameters:
    ///   - url: Source url
    ///   - completion: Callback
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data)) // NSData == Data | NSString == String
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}
