//
//  String+Extension.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 05/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

extension String {
    var onlyNumbers: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    var isEmail: Bool {
        let regex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,12}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        let regex = "^\\(\\d{2}\\)\\s\\d{5}\\-\\d{4}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isCPF: Bool {
        let numbers = self.onlyNumbers
        
        guard numbers.count == 11 else { return false }
        
        let set = NSCountedSet(array: Array(numbers))
        guard set.count != 1 else { return false }
        
        let i1 = numbers.index(numbers.startIndex, offsetBy: 9)
        let i2 = numbers.index(numbers.startIndex, offsetBy: 10)
        let i3 = numbers.index(numbers.startIndex, offsetBy: 11)
        let d1 = Int(numbers[i1..<i2])
        let d2 = Int(numbers[i2..<i3])
        
        var temp1 = 0, temp2 = 0
        
        for i in 0...8 {
            let start = numbers.index(numbers.startIndex, offsetBy: i)
            let end = numbers.index(numbers.startIndex, offsetBy: i+1)
            let char = Int(numbers[start..<end])
            
            temp1 += char! * (10 - i)
            temp2 += char! * (11 - i)
        }
        
        temp1 %= 11
        temp1 = temp1 < 2 ? 0 : 11-temp1
        
        temp2 += temp1 * 2
        temp2 %= 11
        temp2 = temp2 < 2 ? 0 : 11-temp2
        
        return temp1 == d1 && temp2 == d2
    }
    
    var isCNPJ: Bool {
        let text = self.onlyNumbers
        
        guard text.count == 14 else { return false }
        
        if (text == "00000000000000" ||
                text == "11111111111111" ||
                text == "22222222222222" ||
                text == "33333333333333" ||
                text == "44444444444444" ||
                text == "55555555555555" ||
                text == "66666666666666" ||
                text == "77777777777777" ||
                text == "88888888888888" ||
                text == "99999999999999") {
            return false
        }
        
        let numbers = text.compactMap({ Int(String($0)) })
        let digits = Array(numbers[0..<12])
        
        let firstDigit = checkDigit(for: digits, upperBound: 9, lowerBound: 2, mod: 11)
        let secondDigit = checkDigit(for: digits + [firstDigit], upperBound: 9, lowerBound: 2, mod: 11)
        
        return firstDigit == numbers[12] && secondDigit == numbers[13]
    }
}

extension String {
    
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
                let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                                     range.upperBound - range.lowerBound))
                return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
            let start = index(startIndex, offsetBy: max(0, range.lowerBound))
             return String(self[start...])
        }
    
    func string(withMask mask: String?) -> String {
        guard let mask = mask else { return self }
        
        let stringToFormat = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var formattedValue = stringToFormat
        
        for index in 0 ..< mask.count {
            
            let maskCharacter = String(mask[index..<index+1])
            
            let regex = "[0-9]*"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            
            if !predicate.evaluate(with: maskCharacter) {
                if formattedValue.count > index {
                    formattedValue.insert(
                        contentsOf: maskCharacter,
                        at: formattedValue.index(formattedValue.startIndex, offsetBy: index)
                    )
                } else {
                    return formattedValue
                }
            }
        }
        
        if formattedValue.count > mask.count {
            formattedValue = String(formattedValue.prefix(mask.count))
        }
        
        return formattedValue
    }
}

// MARK: - Validation
extension String {
    enum ValidationType {
        case cpf
        case cpfAndCnpj
        case email
        case cellphone
        case newPassword
        case confirmPassword(newPassword: String)
        case empty
    }
    
    func validation(_ validationType: ValidationType) -> ValidationText {
        switch validationType {
        case .cpfAndCnpj:
            if self.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if self.onlyNumbers.count <= 11 {
                let errorMessage = self.isCPF ? nil : "O CPF digitado é inválido."
                return .init(errorMessage: errorMessage, isValid: errorMessage == nil)
            } else {
                let errorMessage = self.isCNPJ ? nil : "O CNPJ digitado é inválido."
                return .init(errorMessage: errorMessage, isValid: errorMessage == nil)
            }
            
        case .cpf:
            if self.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if !self.isCPF {
                return .init(errorMessage: "O CPF digitado é inválido.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
            
        case .email:
            if self.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if !self.isEmail {
                return .init(errorMessage: "O e-mail digitado é inválido.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
            
        case .cellphone:
            if self.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if !self.isPhoneNumber {
                return .init(errorMessage: "O celular digitado é inválido.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
            
        case .newPassword:
            if self.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if self.count < 8 {
                return .init(errorMessage: "A senha deve conter ao menos 8 caracteres.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
            
        case .confirmPassword(let newPassword):
            if self.isEmpty {
                return .init(errorMessage: nil, isValid: false)
            } else if self != newPassword {
                return .init(errorMessage: "Precisar ser igual à senha digitada.", isValid: false)
            }
            
            return .init(errorMessage: nil, isValid: true)
            
        case .empty:
            return .init(errorMessage: nil, isValid: !self.isEmpty)
        }
    }
}

// MARK: - Private methods
extension String {
    private func checkDigit(for digits: [Int], upperBound: Int, lowerBound: Int, mod: Int, secondMod: Int = 10) -> Int {
        guard lowerBound < upperBound else { preconditionFailure("lower bound is greater than upper bound") }
        
        let factors = Array((lowerBound...upperBound).reversed())
        
        let multiplied = digits.reversed().enumerated().map {
            return $0.element * factors[$0.offset % factors.count]
        }
        
        let sum = multiplied.reduce(0, +)
        
        return (sum % mod) % secondMod
    }
}
