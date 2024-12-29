//
//  APIServices.swift
//  IABG Game UMA
//
//  Created by Diego Sánchez on 8/10/24.
//

import Foundation
import UIKit

enum requestMethod: String {
    case get = "GET"
    case post = "POST"
}

class APIServices {
        
    private let service: URL
        
    init() {
        guard let url = URL(string: "http://d8.lcc.uma.es/ERP_Server/ServiceApp.asmx") else {
            fatalError("URL no válida.")
        }
        self.service = url
    }
        
    func sendSOAPRequest(serviceName: String, soapMethod: requestMethod, soapBody: String, completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: service)
        request.httpMethod = soapMethod.rawValue
        request.setValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let requestBody = """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
            <soap:Body>
                \(soapBody)
            </soap:Body>
        </soap:Envelope>
        """
        
        request.httpBody = requestBody.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    

    //función que a lo mejor tengo que usar para los xml simples pero que contengan arrays como el de estadistica
    
    func generateXMLSimple<T>(serviceName: String, model: T) -> String {
        let mirror = Mirror(reflecting: model)
        var xml = "<\(serviceName) xmlns=\"http://tempuri.org/\">\n"
        
        for child in mirror.children {
            if let propertyName = child.label {
                let childMirror = Mirror(reflecting: child.value)
                let isOptional = childMirror.displayStyle == .optional
                
                // Si el valor es opcional y es nil, lo omitimos
                if isOptional, childMirror.children.isEmpty {
                    continue
                }
                
                if let arrayValue = child.value as? [Any] {
                    xml += "  <\(propertyName)>\n"
                    for item in arrayValue {
                        xml += "    <int>\(item)</int>\n"
                    }
                    xml += "  </\(propertyName)>\n"
                } else {
                    xml += "  <\(propertyName)>\(child.value)</\(propertyName)>\n"
                }
            }
        }
        
        xml += "</\(serviceName)>"
        return xml
    }
/*
    func parseXMLToModel(xml: String, model: GetUserAllInfoResult.Type) -> GetUserAllInfoResult? {
        let parser = XMLModelParser()
        return parser.parse(xml: xml)
    }*/
}



/*class XMLModelParser: NSObject, XMLParserDelegate {
    var currentElement = ""
    var tempValue = ""
    
    var user: User?
    var statistics: StatisticsGame?
    var lastPlays: [Int] = []
    
    func parse(xml: String) -> GetUserAllInfoResult? {
        guard let data = xml.data(using: .utf8) else { return nil }
        let parser = XMLParser(data: data)
        parser.delegate = self
        if parser.parse(), let user = user, let statistics = statistics {
            return GetUserAllInfoResult(userInfo: user, statistics: statistics)
        }
        return nil
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        tempValue = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        tempValue += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "User_ID":
            if user == nil {
                user = User(User_ID: "", Email: "", Password: "", User_Name: "", Profile_Picture: "", Pass_Count: 0, Level_Percentage: 0)
            }
            if let user = user {
                self.user = User(
                    User_ID: tempValue,
                    Email: user.Email,
                    Password: user.Password,
                    User_Name: user.User_Name,
                    Profile_Picture: user.Profile_Picture,
                    Pass_Count: user.Pass_Count,
                    Level_Percentage: user.Level_Percentage
                )
            } else if let statistics = statistics {
                self.statistics = StatisticsGame(
                    Statistics_ID: statistics.Statistics_ID,
                    User_ID: tempValue,
                    Level: statistics.Level,
                    Total_Attempt: statistics.Total_Attempt,
                    Total_Success: statistics.Total_Success,
                    Ranking: statistics.Ranking,
                    Points: statistics.Points,
                    Percentage_Succes: statistics.Percentage_Succes,
                    Percentage_Agility: statistics.Percentage_Agility,
                    Last_Plays: statistics.Last_Plays,
                    Level_ID: statistics.Level_ID,
                    Total_Attempt_Level: statistics.Total_Attempt_Level,
                    Total_Success_Level: statistics.Total_Success_Level
                )
            }
        case "Email":
            user?.Email = tempValue
        case "Password":
            user?.Password = tempValue
        case "User_Name":
            user?.User_Name = tempValue
        case "Profile_Picture":
            user?.Profile_Picture = tempValue
        case "Pass_Count":
            user?.Pass_Count = Int(tempValue) ?? 0
        case "Level_Percentage":
            user?.Level_Percentage = Int(tempValue) ?? 0
        case "Statistics_ID":
            statistics = StatisticsGame(Statistics_ID: Int(tempValue) ?? 0, User_ID: user?.User_ID ?? "", Level: 0, Total_Attempt: 0, Total_Success: 0, Ranking: 0, Points: 0, Percentage_Succes: 0, Percentage_Agility: 0, Last_Plays: [], Level_ID: 0, Total_Attempt_Level: 0, Total_Success_Level: 0)
        case "Level":
            statistics?.Level = Int(tempValue) ?? 0
        case "Total_Attempt":
            statistics?.Total_Attempt = Int(tempValue) ?? 0
        case "Total_Success":
            statistics?.Total_Success = Int(tempValue) ?? 0
        case "Ranking":
            statistics?.Ranking = Int(tempValue) ?? 0
        case "Points":
            statistics?.Points = Int(tempValue) ?? 0
        case "Percentage_Succes":
            statistics?.Percentage_Succes = Int(tempValue) ?? 0
        case "Percentage_Agility":
            statistics?.Percentage_Agility = Int(tempValue) ?? 0
        case "int":
            lastPlays.append(Int(tempValue) ?? 0)
        case "Level_ID":
            statistics?.Level_ID = Int(tempValue) ?? 0
        case "Total_Attempt_Level":
            statistics?.Total_Attempt_Level = Int(tempValue) ?? 0
        case "Total_Success_Level":
            statistics?.Total_Success_Level = Int(tempValue) ?? 0
        case "Last_Plays":
            statistics?.Last_Plays = lastPlays
        default:
            break
        }
    }
}*/
