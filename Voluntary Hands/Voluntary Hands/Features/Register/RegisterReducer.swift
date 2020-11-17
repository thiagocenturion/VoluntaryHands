//
//  RegisterReducer.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 08/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Combine
import UIKit
import FirebaseStorage
import FirebaseAnalytics

extension Int {
    
    static func tendentiousRandom(normal: Range<Int>, tendentious: Range<Int>) -> Int {
        return Bool.random() ? Int.random(in: normal) : Int.random(in: tendentious)
    }
    
    static func tendentiousRandom(normal: ClosedRange<Int>, tendentious: ClosedRange<Int>) -> Int {
        return Bool.random() ? Int.random(in: normal) : Int.random(in: tendentious)
    }
}

let registerReducer: Reducer<RegisterState, RegisterAction, RegisterServicesEnvironmentType> = Reducer { state, action, environment in
    
    let causes = [
        "Meio Ambiente",
        "Animais",
        "Crianças",
        "Idosos",
        "Educação",
        "Saúde",
        "Moradia",
        "Assistência Social",
        "Outros",
    ]
    
    switch action {
    case .currentImage(let data):
        state.currentImage = data
        
    case .userType(let type):
        state.userType = type
        
        let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        
        // 1 - Imperative Programming
        func sum(arr: [Int]) -> Int {
            var soma = 0
            
            for number in arr {
                soma += number
            }
            
            return soma
        }
        
        // 2 - Declarative Programming
        let sum = arr.reduce(0) { $0 + $1 }
        
        for _ in 0 ..< 123 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                let userProperty = Bool.random() ? "Voluntário" : "Instituição"
                Analytics.setUserProperty(userProperty, forName: "Tipo")
                Analytics.logEvent("login", parameters: nil)
                
                if userProperty == "Voluntário" {
                    
                    Analytics.logEvent("cadastro_voluntario_iniciado", parameters: nil)
                    
                    if Int.tendentiousRandom(normal: 0 ... 2, tendentious: 1 ... 2) > 0 {
                        Analytics.logEvent("cadastro_voluntario_finalizado", parameters: [
                            "foto": (Bool.random() ? "Sim" : "Não") as NSString
                        ])
                        
                        if Int.tendentiousRandom(normal: 0 ... 2, tendentious: 1 ... 2) > 0 {
                            
                            Analytics.logEvent("causas_apoio_voluntario_finalizado", parameters: nil)
                            
                            let causeAnalytics = [
                                causes[Int.tendentiousRandom(normal: 0 ... causes.count - 1, tendentious: 0 ... 0)],
                                causes[Int.tendentiousRandom(normal: 0 ... causes.count - 1, tendentious: 7 ... 7)],
                                causes[Int.tendentiousRandom(normal: 0 ... causes.count - 1, tendentious: causes.count - 1 ... causes.count - 1)]
                            ]
                            
                            for cause in causeAnalytics {
                                Analytics.logEvent("causas_apoio_voluntario", parameters: [
                                    "causa": cause as NSString
                                ])
                            }
                            
                            if Int.tendentiousRandom(normal: 0 ... 3, tendentious: 1 ... 3) > 0 {
                                Analytics.logEvent("visualizacao_campanha", parameters: [
                                    "causa": causes.randomElement()! as NSString
                                ])
                                
                                if Int.tendentiousRandom(normal: 0 ... 3, tendentious: 1 ... 3) > 0 {
                                    let values = [5.0, 10.0, 15.0, 25.0, 50.0, 100.0, 200.0]
                                    Analytics.logEvent("doacao_financeira", parameters: [
                                        "causa": causes.randomElement()! as NSString,
                                        AnalyticsParameterValue: (values[Int.tendentiousRandom(normal: 0 ..< values.count, tendentious: 4 ..< 6)]) as NSNumber
                                    ])
                                }
                                
                                if Int.tendentiousRandom(normal: 0 ... 3, tendentious: 3 ... 3) > 2 {
                                    Analytics.logEvent("doacao_produto", parameters: [
                                        "causa": causes.randomElement()! as NSString
                                    ])
                                }
                                
                                if Bool.random() {
                                    Analytics.logEvent("candidatura", parameters: [
                                        "causa": causes.randomElement()! as NSString,
                                        "tipo": (Int.tendentiousRandom(normal: 0 ... 3, tendentious: 1 ... 3) > 0 ? "Profissional" : "Normal") as NSString,
                                        "forma": (Int.tendentiousRandom(normal: 0 ... 3, tendentious: 1 ... 3) > 0 ? "Remota" : "Presencial") as NSString
                                    ])
                                }
                            }
                        }
                        
                    }
                    
                } else {
                    Analytics.logEvent("cadastro_instituicao_iniciado", parameters: nil)
                    
                    if Int.tendentiousRandom(normal: 0 ... 2, tendentious: 1 ... 2) > 0 {
                        Analytics.logEvent("cadastro_instituicao_finalizado", parameters: [
                            "foto": (Bool.random() ? "Sim" : "Não") as NSString
                        ])
                        
                        Analytics.logEvent("criacao_campanha_iniciada", parameters: nil)
                        let values = [500.0, 1000.0, 1500.0, 2500.0, 5000.0, 10000.0, 20000.0]
                        Analytics.logEvent("criacao_campanha_finalizada", parameters: [
                            "causa": causes.randomElement()! as NSString,
                            "tipo": (Int.tendentiousRandom(normal: 0 ... 4, tendentious: 1 ... 4) > 0 ? "Online" : "Presencial") as NSString,
                            AnalyticsParameterValue: (values[Int.tendentiousRandom(normal: 0 ..< values.count, tendentious: 4 ..< 6)]) as NSNumber
                        ])
                    }
                }
            }
        }
        
    case .acceptTerms(let isAccept):
        state.termsAccepted = isAccept
        
    case .signUpVolunteer(let volunteer):
        state.loading = true
        
        if let currentImageData = state.currentImage {
            environment.remoteStorage
                .saveNewProfilePicture(currentImageData, childPath: "\(volunteer.email)/profile_picture.jpg") { _, url in
                    print(url)
                }
        }
        
        return environment.registerServices.register(with: volunteer)
            .map { _ in RegisterAction.registerSuccess }
            .catch { error in Just<RegisterAction>(.alert(error: error)) }
            .eraseToAnyPublisher()
        
    case .signUpInstitution(let institution):
        state.loading = true
        
        if let currentImageData = state.currentImage {
            environment.remoteStorage
                .saveNewProfilePicture(currentImageData, childPath: "\(institution.email)/profile_picture.jpg") { _, url in
                print(url)
            }
        }
        
        return environment.registerServices.register(with: institution)
            .map { _ in RegisterAction.registerSuccess }
            .catch { error in Just<RegisterAction>(.alert(error: error)) }
            .eraseToAnyPublisher()
        
    case .registerSuccess:
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        state.loading = false
        state.registerSuccess = true
        
    case .alert(error: let error):
        state.loading = false
        
        guard let error = error else {
            state.alert = nil
            return Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        var alertError: AlertError?
        if let networkingError = error as? NetworkingError {
            switch networkingError {
            case .serverErrorMessage(let message):
                alertError = .init(title: "Puxa!", message: message ?? "Houve um problema no cadastro. Tente novamente")
            default:
                alertError = .init(title: "Oops!", message: "Não foi possível realizar o cadastro. Tente novamente.")
            }
        } else {
            alertError = .init(title: "Oops!", message: "Não foi possível realizar o cadastro. Tente novamente.")
        }
        
        state.alert = alertError
        
    case .set(let newState):
        state = newState
        
    case .resetState:
        state.loading = false
        state.currentImage = nil
        state.userType = .volunteer
        state.termsAccepted = false
        state.registerSuccess = false
        state.alert = nil
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
}
