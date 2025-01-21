//
//  EndGameAPI.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 5/1/25.
//

import Foundation

protocol EndGameApiDelegate: AnyObject {
    func saveResultSucces()
    func saveResultError(error: String)
}

class EndGameAPI: BaseAPI {
    
    weak var delegate: EndGameApiDelegate?
    
    func saveResults(results: EndGameRequestModel) {
        let soapBody = generateXMLSimple(serviceName: Constants.ApiConstants.saveResult, model: results)
        
        sendSOAPRequest(serviceName: Constants.ApiConstants.saveResult, soapMethod: .post, soapBody: soapBody) { result in
            self.handleSOAPResponse(
                result: result,
                successCondition: { $0.contains("<saveResultsResult>Service succes</saveResultsResult>") },
                successHandler: { [weak self] in
                    self?.delegate?.saveResultSucces()
                },
                errorHandler: { [weak self] error in
                    self?.delegate?.saveResultError(error: NSLocalizedString("Process_data_error", comment: ""))
                }
            )
        }
    }
}
