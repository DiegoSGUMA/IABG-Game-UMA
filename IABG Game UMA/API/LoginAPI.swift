//
//  LoginAPI.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 8/10/24.
//

import Foundation

protocol LoginApiDelegate: AnyObject {
    func registerUserSuccess()
    func registerUserError(error: String)
    
    func isUserNameValidSuccess()
    func isUserNameValidError(error: String)
    
    func updatePassSuccess()
    func updatePassError(error: String)
}

class LoginAPI: APIServices {
    
    weak var delegate: LoginApiDelegate?
    
    private enum APIError: String {
        case generic = "generic_error"
        case usernameExists = "UserName_Exist"
        case serverError = "Server_data_error"
        
        var localized: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    private func handleSOAPResponse(_ result: Result<Data, Error>, successCondition: (String) -> Bool, successHandler: () -> Void, errorHandler: @escaping (String) -> Void) {
        switch result {
        case .success(let data):
            if let response = String(data: data, encoding: .utf8), successCondition(response) {
                successHandler()
            } else {
                errorHandler(APIError.generic.localized)
            }
        case .failure(_):
            errorHandler(APIError.generic.localized)
        }
    }

    func registerUser(user: UserModel) {
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.registerUser, model: user)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.registerUser, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result,
                successCondition: { $0.contains("Service success") },
                successHandler: {
                    self.delegate?.registerUserSuccess()
                    UserDefaults.saveUser(user: user)
                },
                errorHandler: { error in
                    self.delegate?.registerUserError(error: error)
                }
            )
        }
    }
    
    func checkUsername(userName: String) {
        let model = IsUserNameValiRequestModel(userName: userName)
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.usernameValid, model: model)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.usernameValid, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result,
                successCondition: { $0.contains("<isUserNameValidResult>Valid</isUserNameValidResult>") },
                successHandler: {
                    self.delegate?.isUserNameValidSuccess()
                },
                errorHandler: { error in
                    self.delegate?.isUserNameValidError(error: NSLocalizedString(APIError.usernameExists.rawValue, comment: ""))
                }
            )
        }
    }
    
    func updatePass(model: UserModel) {
        let passModel = UpdatePassModel(userID: model.userID, pwd: model.pwd)
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.updatePass, model: passModel)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.updatePass, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result,
                successCondition: { $0.contains("<updatePassResult>true</updatePassResult>") },
                successHandler: {
                    UserDefaults.saveUser(user: model)
                    self.delegate?.updatePassSuccess()
                },
                errorHandler: { error in
                    self.delegate?.updatePassError(error: APIError.serverError.localized)
                }
            )
        }
    }
}
