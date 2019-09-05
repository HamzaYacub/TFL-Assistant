//
//  lineStatusAPI.swift
//  TFL Assistant
//
//  Created by Hamza Yacub on 23/04/2019.
//  Copyright © 2019 Hamza Yacub. All rights reserved.
//
//
//import Foundation
//
//struct line {
//
//    let name : String
//    let status : String
//
//    enum SerializationError : Error {
//        case missing(String)
//        case invalid(String, Any)
//    }
//
//    init(json : [String : Any]) throws {
//        guard let name = json["name"] as? String else {throw SerializationError.missing("name is missing")}
//
//        guard let status = json["lineStatuses"] as? String else {throw SerializationError.missing("line status is missing")}
//
//
//        self.name = name
//        self.status = status
//    }
//
//    static let basePath = "https://api.tfl.gov.uk/Line/Mode/tube/Status?detail=true&app_id=c2354f12&app_key=561f202075aab38b2ed13479dff97241/"
//
////    static func lineStatus (withLocation location : String, completion: @escaping ([line])) {
////
////    }
//
//}
