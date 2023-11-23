//
//  ApiManager.swift
//  GoogleMap
//
//  Created by Geetika on 06/11/23.
//

import Foundation
import Alamofire


class ApiManager{
    static let shared = ApiManager()
    
    func drawPathApi(sourceLocation: String, destinationLocation: String, completion: @escaping(_ result:[Any]) -> ()){
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(sourceLocation)&destination=\(destinationLocation)&mode=driving&key=AIzaSyDC-dB3dhdBCPHmHWxk3kSZT4ojgpCFclg"
        
        AF.request(url).response { (reseponse) in
                   guard let data = reseponse.data else {
                       return
                   }
                   do {
                       let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                       guard let routes = json as? [String: Any] else {
                                  return
                              }
                     
                       let routesData = routes["routes"] as? NSArray
                      completion(routesData as! [Any])
                  
                   }
                    catch let error {
                       print(error.localizedDescription)
                   }
               }
    }
}
