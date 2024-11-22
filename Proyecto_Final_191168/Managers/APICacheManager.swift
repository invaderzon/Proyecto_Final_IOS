//
//  APICacheManager.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/22/24.
//

import Foundation

/// Manages in memory session scoped API caches
final class APICacheManager {
    // API URL: Data
    
    /// Cache map
    private var cacheDictionary: [
        Endpoint: NSCache<NSString, NSData>
    ] = [:]
    
    /// Constructor
    init() {
       setUpCache()
   }
    
    /// Obtener respuesta cache de API
    /// - Parameters:
    ///   - endpoint: Endpoiint del cache
    ///   - url: Url llave
    /// - Returns: Nullable data
    public func cachedResponse(for endpoint: Endpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: Endpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    /// Estabeceer diccionario
    private func setUpCache() {
        Endpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
