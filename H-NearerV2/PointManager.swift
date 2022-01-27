//
//  PointManager.swift
//  H-NearerV2
//
//  Created by Clement Rays on 29/12/2021.
//  Copyright © 2021 Clement Rays. All rights reserved.
//

import Foundation
import CoreLocation

struct PointManager {
    
    static func fetchPoint(completion: @escaping ([Point]) -> ()) {
        struct tempPoint: Decodable {
            let idPoint:Int
            let ptName:String
            let ptLat:Double
            let ptLong:Double
        }
        
        guard let url = URL(string: "https://nerosylius.000webhostapp.com/webservice/ws.php?uc=getPoints") else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error)
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let points = try JSONDecoder().decode([tempPoint].self, from: data)
                var returnArray: [Point] = []
                for pts in points {
                    let pTemp = Point(name: pts.ptName, coord: CLLocation(latitude: pts.ptLat, longitude: pts.ptLong))
                    returnArray.append(pTemp)
                }
                completion(returnArray)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    static func addNewPoint(name: String, lat: String, long: String) {
        guard let url = URL(string: "https://nerosylius.000webhostapp.com/webservice/ws.php?uc=addPoint") else {
            fatalError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = "ptName=\(name)&ptLat=\(lat)&ptLong=\(long)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        }.resume()
    }
    
    static func deletePoint(name: String) {
        guard let url = URL(string: "https://nerosylius.000webhostapp.com/webservice/ws.php?uc=deletePoint") else {
            fatalError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString = "ptName=\(name)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        }.resume()
    }
    
    static func editPoint(oldName: String, newName: String, newLat: String, newLong: String) {
        guard let url = URL(string: "https://nerosylius.000webhostapp.com/webservice/ws.php?uc=editPoint") else {
            fatalError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postString =  "oldName=\(oldName)&newName=\(newName)&ptLat=\(newLat)&ptLong=\(newLong)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
        }.resume()
    }
}
