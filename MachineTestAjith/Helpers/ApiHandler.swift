//
//  ApiHandler.swift
//  MachineTestAjith
//
//  Created by ajithkumar k on 30/09/21.
//

import Foundation

import Alamofire

struct ServerResponse<T: Codable>: Codable {
    let errors: Bool?
    let message: String
    let data: T?
}

struct PaginationResponse<T: Codable>: Codable {
    let currentPage: Int
       let data: T?
       let firstPageURL: String?
       let from: Int?
       let nextPageURL: String?
       let path: String?
       let perPage: Int?
       let prevPageURL: String?
       let to: Int?

       enum CodingKeys: String, CodingKey {
           case currentPage = "current_page"
           case data
           case firstPageURL = "first_page_url"
           case from
           case nextPageURL = "next_page_url"
           case path
           case perPage = "per_page"
           case prevPageURL = "prev_page_url"
           case to
       }
}

struct ServerURL {
    static let baseUrl =  "https://api.tvmaze.com/"
    static let showList = baseUrl + "shows"
}

struct ApiHandler {

    
    static func apiCall(requrl:String, method: HTTPMethod,parameter:[String:String], enableSpinner:Bool = false, completionHandler: @escaping (_ result:Data?, _ status: Bool, _ errorMessage: String?) -> Void)
    {
    print(requrl)
        AF.request(requrl, method: method, parameters: parameter, encoding: URLEncoding.queryString).validate(statusCode: 200..<201)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let retrievedData = response.data
                    {

                        completionHandler(retrievedData,true, "" )
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler( response.data,false, "Unable to fetch data" )
                    
                }
            }
    }
    
    
}
