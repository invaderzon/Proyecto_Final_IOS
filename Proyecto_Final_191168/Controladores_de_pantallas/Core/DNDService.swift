//
//  DNDSource.swift
//  Proyecto_Final_191168
//
//  Created by alumno on 11/13/24.
//

import Foundation

/// Objeto primario de servicio para obtener datos de DND
final class RMService {
    
    /// Instancia compartida
    static let shared = RMService()
    
    private init() {}
    
    /// Enviar llamada a la API
    /// - Parameters:
    /// - request: Request instance
    /// - completion: Callback with data or error
    
    public func execute(_ request: DNDRequest, completion: @escaping () -> Void){
        
    }
}
