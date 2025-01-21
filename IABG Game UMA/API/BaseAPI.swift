//
//  BaseAPI.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 5/1/25.
//

import Foundation

class BaseAPI: APIServices {
    
    //Control de las peticiones y respuestas SOAP
    
    func handleSOAPResponse(
        result: Result<Data, Error>,
        successCondition: (String) -> Bool,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (String) -> Void
    ) {
        switch result {
        case .success(let data):
            if let response = String(data: data, encoding: .utf8), successCondition(response) {
                successHandler()
            } else {
                errorHandler(NSLocalizedString("generic_error", comment: ""))
            }
        case .failure:
            errorHandler(NSLocalizedString("generic_error", comment: ""))
        }
    }
    
    func handleSOAPResponseWithModel<T: Decodable>(
        result: Result<Data, Error>,
        modelType: T.Type,
        successHandler: @escaping (T) -> Void,
        errorHandler: @escaping (String) -> Void
    ) {
        switch result {
        case .success(let data):
            guard let responseString = String(data: data, encoding: .utf8),
                  let parsedModel: T = parseXMLToModel(xml: responseString, model: modelType as! GetUserAllInfoResult.Type) as? T else {
                errorHandler(NSLocalizedString("Process_data_error", comment: ""))
                return
            }
            successHandler(parsedModel)
        case .failure:
            errorHandler(NSLocalizedString("generic_error", comment: ""))
        }
    }
}
