//
//  Image.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 28/12/24.
//

import Foundation
import UIKit

extension UIImage {
    
    func resizeImage(image: UIImage, newSize: CGSize) -> UIImage? {
        let scale = newSize.width / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newSize.width, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

    func imageToUInt8ArrayString() -> String? {
        let image = resizeImage(image: self, newSize: CGSize(width: 80, height: 80)) ?? self
        if let imageData = image.jpegData(compressionQuality: 1) {
            let byteArray = [UInt8](imageData)
            
            let data = Data(byteArray)
            let base64String = data.base64EncodedString()
            return base64String
        }
        return nil
    }

}
