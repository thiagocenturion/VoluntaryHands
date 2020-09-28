//
//  AppError.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

enum AppError: Error {
    /// Enconding issue when trying to send data.
    case invalidEncode
    
    /// No data recieved from the server.
    case noData
    
    /// The server response was invalid (unexpected format).
    case invalidDecode(error: Error)
    
    /// The request was rejected: 400-499.
    case badRequest(error: Error)
    
    /// Encounted a server error.
    case serverError(error: URLError)
    
    /// There was an error parsing the data.
    case parseError(error: Error)
    
    case unknown
}
