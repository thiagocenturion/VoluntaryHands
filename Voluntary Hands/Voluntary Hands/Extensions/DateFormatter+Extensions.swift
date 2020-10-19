//
//  DateFormatter+Extensions.swift
//  Voluntary Hands
//
//  Created by Thiago Rodrigues Centurion on 07/10/20.
//  Copyright © 2020 Thiago Rodrigues Centurion. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var dayMonthYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter
    }
}
