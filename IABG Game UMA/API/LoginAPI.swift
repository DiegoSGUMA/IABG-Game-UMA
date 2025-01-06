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

class LoginAPI: BaseAPI {
    
    weak var delegate: LoginApiDelegate?
    
    func registerUser(user: UserModel) {
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.registerUser, model: user)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.registerUser, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result: result,
                successCondition: { $0.contains("Service success") },
                successHandler: { [weak self] in
                    UserDefaults.saveUser(user: user)
                    self?.delegate?.registerUserSuccess()
                },
                errorHandler: { [weak self] error in
                    self?.delegate?.registerUserError(error: error)
                }
            )
        }
    }
    
    func checkUsername(userName: String) {
        let model = IsUserNameValiRequestModel(userName: userName)
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.usernameValid, model: model)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.usernameValid, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result: result,
                successCondition: { $0.contains("<isUserNameValidResult>Valid</isUserNameValidResult>") },
                successHandler: { [weak self] in
                    self?.delegate?.isUserNameValidSuccess()
                },
                errorHandler: { [weak self] error in
                    self?.delegate?.isUserNameValidError(error: NSLocalizedString("UserName_Exist", comment: ""))
                }
            )
        }
    }
    
    func updatePass(model: UserModel) {
        let passModel = UpdatePassModel(userID: model.userID, pwd: model.pwd)
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.updatePass, model: passModel)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.updatePass, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result: result,
                successCondition: { $0.contains("<updatePassResult>true</updatePassResult>") },
                successHandler: { [weak self] in
                    UserDefaults.saveUser(user: model)
                    self?.delegate?.updatePassSuccess()
                },
                errorHandler: { [weak self] error in
                    self?.delegate?.updatePassError(error: NSLocalizedString("Server_data_error", comment: ""))
                }
            )
        }
    }
}
