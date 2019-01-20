//
//  BackendConnection.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit

class BackendConnection {

  let baseURLString = "https://api.ch4sm.com/"
  
  func getItemInfo(itemID: String,
                   completionBlock: ((ItemInformation?, Error?) -> Void)? = nil)
  {
    guard let url = self.getUrl("item/" + itemID) else { return }

    self.performRequest(url: url) { (response, data, error) in
      var item: ItemInformation?
      if data != nil {
        item = ItemInformation(jsonData: data!)
      }
      guard let completionBlock = completionBlock else { return }
      completionBlock(item, error)
    }
  }
  
  func getUser(userID: String,
               completionBlock: ((User?, Error?) -> Void)? = nil)
  {
    guard let url = self.getUrl("user/" + userID) else { return }
    
    self.performRequest(url: url) { (response, data, error) in
      var user: User?
      if data != nil {
        user = User(jsonData: data!)
      }
      guard let completionBlock = completionBlock else { return }
      completionBlock(user, error)
    }
    
  }
  
  func postAnswer(answer: ItemAnswer,
                  completionBlock: ((Bool, Error?) -> Void)? = nil)
  {
    guard let url = self.getUrl("item/" + (answer.item?.itemID)! + "/answer") else { return }
    
    let string = answer.jsonStringFromObject()
    
    let data = string?.data(using: .utf8)
    
    self.performRequest(url: url, body: data) { (response, data, error) in
      guard let completionBlock = completionBlock else { return }
      completionBlock(true, error)
    }
  }
  
  func getUrl(_ path: String) -> URL? {
    let urlString = URL(string: baseURLString + path)
    return urlString
  }
  
  func performRequest(url: URL,
                      httpMethod: String = "GET",
                      body: Data? = nil,
                      headers: [String: String]? = nil,
                      completionBlock: ((URLResponse?, Data?, Error?) -> Void)? = nil)
  {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
    
    //  guard var urlComponents = URLComponents(string: url),
    //  let url = urlComponents.url else { return nil }
    
    var request = URLRequest(url: url)
    
    request.httpMethod = httpMethod
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
    
    if let headers = headers {
      for (headerField, headerValue) in headers {
        request.setValue(headerValue, forHTTPHeaderField: headerField)
      }
    }
    
    dataTask = defaultSession.dataTask(with: request) { data, response, error in
      
      
      if let error = error {
        errorMessage += "DataTask error: " + error.localizedDescription + "\n"
      }
      else if let data = data,
              let response = response as? HTTPURLResponse {
        print(data)
        print(response)
        let body:[UInt8] = [UInt8](data)
        print(body)
      }
      
      guard let completionBlock = completionBlock else { return }
      completionBlock(response, data, error)
    }
    
    // Start request
    dataTask?.resume()
  }
  
}
