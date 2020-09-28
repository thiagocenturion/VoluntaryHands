//
//  UserServices.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 24/09/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation
import Combine

struct Users: Codable, CustomStringConvertible {
    let data: [User]?
}

struct User: Codable, CustomStringConvertible {
    let id: String?
    let title: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let picture: String?
}

extension CustomStringConvertible where Self: Codable {
    var description: String {
        var description = "\n \(type(of: self)) \n"
        let selfMirror = Mirror(reflecting: self)
        for child in selfMirror.children {
            if let propertyName = child.label {
                description += "\(propertyName): \(child.value)\n"
            }
        }
        return description
    }
}

struct Endpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyapi.io"
        components.path = "/data/api" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    var headers: [String: Any] {
        return [
            "app-id": "YOUR APP ID HERE"
        ]
    }
}


extension Endpoint {
    static var users: Self {
        return Endpoint(path: "/user")
    }
    
    static func users(count: Int) -> Self {
        return Endpoint(path: "/user",
                        queryItems: [
                            URLQueryItem(name: "limit",
                                         value: "\(count)")
            ]
        )
    }
    
    static func user(id: String) -> Self {
        return Endpoint(path: "/user/\(id)")
    }
}

protocol NetworkControllerProtocol: class {
    typealias Headers = [String: Any]
    
    func get<T>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> where T: Decodable
}


final class NetworkController: NetworkControllerProtocol {
    
    func get<T: Decodable>(type: T.Type, url: URL, headers: Headers) -> AnyPublisher<T, Error> {
        
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { (key, value) in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

protocol UsersLogicControllerProtocol: class {
    var networkController: NetworkControllerProtocol { get }

    func getUsers() -> AnyPublisher<Users, Error>
    func getUsers(count: Int) -> AnyPublisher<Users, Error>
    func getUser(id: String) -> AnyPublisher<User, Error>
}


final class UsersLogicController: UsersLogicControllerProtocol {
    
    let networkController: NetworkControllerProtocol
    
    init(networkController: NetworkControllerProtocol) {
        self.networkController = networkController
    }
    
    func getUsers() -> AnyPublisher<Users, Error> {
        let endpoint = Endpoint.users
        
        return networkController.get(type: Users.self,
                                     url: endpoint.url,
                                     headers: endpoint.headers)
    }
    
    func getUsers(count: Int) -> AnyPublisher<Users, Error> {
        let endpoint = Endpoint.users(count: count)
        
        return networkController.get(type: Users.self,
                                     url: endpoint.url,
                                     headers: endpoint.headers)
    }
    
    func getUser(id: String) -> AnyPublisher<User, Error> {
        let endpoint = Endpoint.user(id: id)
        
        return networkController.get(type: User.self,
                                     url: endpoint.url,
                                     headers: endpoint.headers)
    }
    
}






let networkController = NetworkController()
let usersLogicController = UsersLogicController(networkController: networkController)

var subscriptions = Set<AnyCancellable>()


//usersLogicController.getUsers()
//    .sink(receiveCompletion: { (completion) in
//        switch completion {
//        case let .failure(error):
//            print("Couldn't get users: \(error)")
//        case .finished: break
//        }
//    }) { users in
//        print(users)
//    }
//    .store(in: &subscriptions)
