//
//  String+Additions.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 9/10/24.
//

import Foundation
import UIKit


extension String {

    internal func evaluate(regexp: String) -> Bool {
        guard let range = range(of: regexp, options: .regularExpression, range: nil, locale: nil) else {
            return false
        }

        return range.lowerBound == startIndex && range.upperBound == endIndex
    }

    func stringToUInt8ArrayImage() -> UIImage? {
        // Decodificar la cadena base64 en datos
        if let data = Data(base64Encoded: self) {
            // Convertir Data a [UInt8]
            let byteArray = [UInt8](data)
            let data = Data(byteArray)
            // Crear una UIImage a partir de los datos
            let image = UIImage(data: data)
            return image
        }
        return nil
    }

}
