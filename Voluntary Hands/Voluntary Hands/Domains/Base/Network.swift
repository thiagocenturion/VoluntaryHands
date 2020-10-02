//
//  Network.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine
import Network

protocol NetworkProtocol {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    var timeout: TimeInterval { get }
    var monitor: NWPathMonitor { get }
    
    func get<Decode>(endpoint: Endpoint) -> AnyPublisher<Decode, Error> where Decode: Decodable
    
    func post<Encode, Decode>(
        endpoint: Endpoint,
        token: String?,
        body: Encode) -> AnyPublisher<Decode, Error> where Encode: Encodable, Decode: Decodable
}

final class Network: NetworkProtocol {
    
    // MARK: - Public properties
    let session: URLSession
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let timeout: TimeInterval
    let tokenUpdater: TokenUpdater
    
    var monitor: NWPathMonitor {
        didSet {
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }
    }
    
    // MARK: - Initialization
    init(
        session: URLSession,
        decoder: JSONDecoder,
        encoder: JSONEncoder,
        timeout: TimeInterval,
        monitor: NWPathMonitor,
        tokenUpdater: TokenUpdater) {
        
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.timeout = timeout
        self.monitor = monitor
        self.tokenUpdater = tokenUpdater
    }
}

// MARK: - Public methods
extension Network {
    
    func get<Decode>(endpoint: Endpoint) -> AnyPublisher<Decode, Error> where Decode: Decodable {
        
        guard monitor.currentPath.status == .satisfied else {
            return Fail(error: AppError.noConnection).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.timeoutInterval = timeout
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { AppError.serverError(error: $0) }
            .handleEvents(receiveOutput: { [weak self] dataTaskPublisher in
                self?.updateTokenIfNeeded(with: dataTaskPublisher.response)
            })
            .map(\.data)
            .decode(type: Decode.self, decoder: decoder)
            .mapError { AppError.invalidDecode(error: $0) }
            .eraseToAnyPublisher()
    }
    
    func post<Encode, Decode>(
        endpoint: Endpoint,
        token: String?,
        body: Encode) -> AnyPublisher<Decode, Error> where Encode: Encodable, Decode: Decodable {
        
        guard monitor.currentPath.status == .satisfied else {
            return Fail(error: AppError.noConnection).eraseToAnyPublisher()
        }
        
        guard let body = try? encoder.encode(body) else {
            return Fail(error: AppError.invalidEncode).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.timeoutInterval = timeout
        
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = token {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.httpBody = body
        
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { AppError.serverError(error: $0) }
            .handleEvents(receiveOutput: { [weak self] dataTaskPublisher in
                self?.updateTokenIfNeeded(with: dataTaskPublisher.response)
            })
            .map(\.data)
            .decode(type: Decode.self, decoder: decoder)
            .mapError { AppError.invalidDecode(error: $0) }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private methods
extension Network {
    
    private func updateTokenIfNeeded(with urlResponse: URLResponse) {
        if let httpResponse = urlResponse as? HTTPURLResponse,
           let authorization = httpResponse.allHeaderFields["Authorization"] as? String {
            
            let token = authorization.replacingOccurrences(of: "Bearer ", with: "")
            tokenUpdater.token = token
        }
    }
}

#if UNIT_TEST

extension Network {
    
    func mock(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init(),
        timeout: TimeInterval = 30,
        monitor: NWPathMonitor = .init(),
        tokenUpdater: TokenUpdater = .mock()) -> Network {
        
        return .init(decoder: decoder, encoder: encoder)
    }
}

#endif
