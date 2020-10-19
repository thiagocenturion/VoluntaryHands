//
//  Network.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 27/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

protocol NetworkType {
    var session: URLSession { get }
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    var timeout: TimeInterval { get }
    
    func request<Decode>(
        endpoint: Endpoint,
        httpMethod: Network.HTTPMethod,
        authorizationIfNeeded: Bool) -> AnyPublisher<Decode, Error> where Decode: Decodable
    
    func requestString(
        endpoint: Endpoint,
        httpMethod: Network.HTTPMethod,
        authorizationIfNeeded: Bool) -> AnyPublisher<String, Error>
}

extension Encodable {
  fileprivate func openedEncode(to container: inout SingleValueEncodingContainer) throws {
    try container.encode(self)
  }
}

struct AnyEncodable: Encodable {
  var value: Encodable
  init(_ value: Encodable) {
    self.value = value
  }
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try value.openedEncode(to: &container)
  }
}

final class Network: NetworkType {
    
    // MARK: - Public properties
    let session: URLSession
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let timeout: TimeInterval
    let tokenUpdater: TokenUpdater
    
    enum HTTPMethod {
        case get
        case post(body: Any)
        case put(body: Any)
        
        var rawValue: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .put: return "PUT"
            }
        }
    }
    
    // MARK: - Initialization
    init(
        session: URLSession,
        decoder: JSONDecoder,
        encoder: JSONEncoder,
        timeout: TimeInterval,
        tokenUpdater: TokenUpdater) {
        
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.timeout = timeout
        self.tokenUpdater = tokenUpdater
    }
}

// MARK: - Public methods
extension Network {
    
    func request<Decode>(
        endpoint: Endpoint,
        httpMethod: Network.HTTPMethod,
        authorizationIfNeeded: Bool) -> AnyPublisher<Decode, Error> where Decode: Decodable {

        guard Reachability.isConnectedToNetwork() else {
            return Fail(error: NetworkingError.noConnection).eraseToAnyPublisher()
        }
        
        let result = urlRequest(
            endpoint: endpoint,
            httpMethod: httpMethod,
            token: authorizationIfNeeded ? tokenUpdater.token : nil)

        switch result {
        case .success(let urlRequest):
            print("RECEIVED REQUEST FOR \(endpoint.path):")
            print(urlRequest.allHTTPHeaderFields ?? "")
            if let data = urlRequest.httpBody { print(String(decoding: data, as: UTF8.self)) }
            
            return session.dataTaskPublisher(for: urlRequest)
                .receive(on: DispatchQueue.main)
                .mapError { NetworkingError.serverError(error: $0) }
                .handleEvents(receiveOutput: { [weak self] dataTaskPublisher in
                    
                    print("RECEIVED RESPONSE FOR \(endpoint.path):")
                    print(dataTaskPublisher.response)
                    
                    self?.updateTokenIfNeeded(with: dataTaskPublisher.response)
                })
                .flatMap { data, response -> AnyPublisher<Data, Error> in
                    guard let response = response as? HTTPURLResponse else {
                        return Fail(error: NetworkingError.noData).eraseToAnyPublisher()
                    }
                    
                    guard 200 ..< 300 ~= response.statusCode else {
                        print("FAILED TO GET SUCCESS FOR \(endpoint.path)")
                        print("Data:")
                        print(String(decoding: data, as: UTF8.self))
                        
                        return Fail(error: NetworkingError.serverErrorMessage(message: String(decoding: data, as: UTF8.self)))
                        .eraseToAnyPublisher()
                    }
                    
                    return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                .decode(type: Decode.self, decoder: decoder)
                .mapError { NetworkingError.invalidDecode(error: $0) }
                .eraseToAnyPublisher()

        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func requestString(
        endpoint: Endpoint,
        httpMethod: Network.HTTPMethod,
        authorizationIfNeeded: Bool) -> AnyPublisher<String, Error> {

        guard Reachability.isConnectedToNetwork() else {
            return Fail(error: NetworkingError.noConnection).eraseToAnyPublisher()
        }

        let result = urlRequest(
            endpoint: endpoint,
            httpMethod: httpMethod,
            token: authorizationIfNeeded ? tokenUpdater.token : nil)

        switch result {
        case .success(let urlRequest):
            print("RECEIVED REQUEST FOR \(endpoint.path):")
            print(urlRequest.allHTTPHeaderFields ?? "")
            if let data = urlRequest.httpBody { print(String(decoding: data, as: UTF8.self)) }
            
            return session.dataTaskPublisher(for: urlRequest)
                .mapError { NetworkingError.serverError(error: $0) }
                .handleEvents(receiveOutput: { [weak self] dataTaskPublisher in
                    
                    print("RECEIVED RESPONSE FOR \(endpoint.path):")
                    print(dataTaskPublisher.response)
                    
                    self?.updateTokenIfNeeded(with: dataTaskPublisher.response)
                })
                .flatMap { data, response -> AnyPublisher<Data, Error> in
                    guard let response = response as? HTTPURLResponse else {
                        return Fail(error: NetworkingError.noData).eraseToAnyPublisher()
                    }
                    
                    guard 200 ..< 300 ~= response.statusCode else {
                        print("FAILED TO GET SUCCESS FOR \(endpoint.path)")
                        print("Data:")
                        print(String(decoding: data, as: UTF8.self))
                        
                        return Fail(error: NetworkingError.serverErrorMessage(message: String(decoding: data, as: UTF8.self)))
                        .eraseToAnyPublisher()
                    }
                    
                    return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                .map { String(decoding: $0, as: UTF8.self )}
                .mapError { NetworkingError.invalidDecode(error: $0) }
                .eraseToAnyPublisher()

        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

// MARK: - Private methods
extension Network {
    
    private func urlRequest(
        endpoint: Endpoint,
        httpMethod: HTTPMethod,
        token: String?) -> Result<URLRequest, Error> {
        
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.timeoutInterval = timeout
        urlRequest.httpMethod = httpMethod.rawValue
        
        if let token = token {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch httpMethod {
        case .get:
            break
            
        case .post(let body), .put(let body):
            guard let body = body as? Encodable, let data = try? encoder.encode(AnyEncodable(body)) else {
                return .failure(NetworkingError.invalidEncode)
            }
            
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = data
        }
        
        return .success(urlRequest)
    }
    
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
    
    static func mock(
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
