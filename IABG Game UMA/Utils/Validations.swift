//
//  Validations.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 7/10/24.
//

import Foundation
import Combine

struct Validations {
    static func validateEmpty(fields: [String]) -> String? {
        return fields.contains(where: { $0.isEmpty }) ? "Error" : nil
    }

    static func validateEmail(text: String, second: String?) -> String? {
        let emailRegex = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-]{2,}$"
        return text.evaluate(regexp: emailRegex) ? nil : NSLocalizedString("Invalid_field_error", comment: "")
    }

    static func validatePass(text: String, second: String?) -> String? {
        let passRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[!@#_$.%^&*]).{8,}$"
        return text.evaluate(regexp: passRegex) ? nil : NSLocalizedString("Invalid_field_error", comment: "")
    }

    static func validateUsername(text: String, second: String?) -> String? {
        return (text.contains(" ") || text.isEmpty || text.count > 25) ? NSLocalizedString("Invalid_username_error", comment: "") : nil
    }

    static func validateEqualPass(pass1: String, pass2: String?) -> String? {
        return pass1 == pass2 ? nil : NSLocalizedString("Invalid_same_password", comment: "")
    }

}

