//
//  JokeAPI.swift
//  SampleProjectMoya
//
//  Created by Lee Nam Jun on 2021/07/14.
//

import Moya
import Foundation

enum JokeAPI {
    case randomJokes(_ firstName: String, _ lastName: String)
}

extension JokeAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.icndb.com")!
    }
    
    var path: String {
        switch self {
        case .randomJokes(_, _):
            return "/jokes/random"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .randomJokes(_, _):
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .randomJokes(let firstName, let lastName):
            let firstName = firstName
            let lastName = lastName
            
            return Data(
                """
                {
                    "type": "success",
                    "value": {
                        "id": 107,
                        "joke": "\(firstName)\(lastName) can retrieve anything from /dev/null."
                    }
                }
                """.utf8
            )
        }
    }
    
    var task: Task {
        switch self {
        case .randomJokes(let firstName, let lastName):
            let params: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
