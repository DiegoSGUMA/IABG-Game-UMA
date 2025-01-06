//
//  MainMenuAPI.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 5/1/25.
//

import Foundation

protocol MainMenuApiDelegate: AnyObject {
    func getUserInfoSucces(model: GetUserAllInfoResult)
    func getUserInfoError(error: String)
    
    func updateProfileSucces()
    func updateProfileError(error: String)
}

class MainMenuAPI: BaseAPI {
    
    weak var delegate: MainMenuApiDelegate?
    
    func getUser(user: UpdatePassModel) {
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.getUserInfo, model: user)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.getUserInfo, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponseWithModel(
                result: result,
                modelType: GetUserAllInfoResult.self,
                successHandler: { [weak self] parsedModel in
                    self?.delegate?.getUserInfoSucces(model: parsedModel)
                },
                errorHandler: { [weak self] error in
                    self?.delegate?.getUserInfoError(error: error)
                }
            )
        }
    }
    
    func updateProfile(profile: updateProfileRequest) {
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.updateProfile, model: profile)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.updateProfile, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result: result,
                successCondition: { $0.contains("<updateProfileResult>Service success</updateProfileResult>") },
                successHandler: { [weak self] in
                    self?.delegate?.updateProfileSucces()
                },
                errorHandler: { [weak self] error in
                    self?.delegate?.updateProfileError(error: error)
                }
            )
        }
    }
}
