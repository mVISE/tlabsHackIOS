//
//  ItemAnswer.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemAnswer: NSObject {

  var item: ItemInformation?
  var user: User?
  var answers: [String: Bool]?
  var signature: String?
  
  init(item: ItemInformation?,
       user: User?,
       answers: [String: Bool]?,
       signature: String?) {
    
    self.item = item
    self.user = user
    self.answers = answers
    self.signature = signature
    
  }

  init(jsonData: Data) {
    
    guard let json = try? JSON(data: jsonData) else { return }
//    var userName = json[0]["user"]
    print(json)
    
  }
  
  func jsonStringFromObject() -> String? {
    
//    {
//      "Answers": {
//        "1": true,
//        "2": false
//      },
//      "Signature": "asdf",
//      "UserID": "1"
//    }
    var string = "{"
    if self.user != nil {
      string.append("\"UserID\":\"\(self.user!.userID ?? "silence Warning")\"")
    }
    
    var isFirstAnswer = true
    if self.answers != nil {
      string.append(",\"Answers\":{")
      for answerKey in (self.answers?.keys)! {
        if !isFirstAnswer {
          string.append(",")
        }
        isFirstAnswer = false
        let answerValue = self.answers?[answerKey]
        string.append("\"\(answerKey)\":")
        if answerValue! {
          string.append("true")
        } else {
          string.append("false")
        }
      }
      string.append("}")
    }
    
    string.append(",\"Signature\":\"asdf\"")
    
    string.append("}")
    return string
  }

}
