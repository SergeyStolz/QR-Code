//
//  NetworkSevice.swift
//  Scan QR
//
//  Created by mac on 15.12.2021.
//

import UIKit

class NetworkService {
    
    func postRequest(item: MainRequestModel) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        let parametrs: [String: Any] = ["qrCode": item.qrCode,
                                        "name": item.name,
                                        "comment": item.comment,
                                        "photoBase64": item.photoBase64]
        var request = URLRequest(url: url)
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parametrs) else { return }
        request.httpMethod = "POST"
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
}
