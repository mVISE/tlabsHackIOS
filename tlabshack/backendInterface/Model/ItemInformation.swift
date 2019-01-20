//
//  ItemInformation.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit
import SwiftyJSON

class ItemInformation {

  var itemID: String?
  var questions: [Question]?
  
  init(itemID: String?, queststions: [String: String]?) {
    
  }
  
  init(jsonData: Data) {
    guard let json = try? JSON(data: jsonData) else { return }
    print(json)
    
    self.itemID = json["ItemID"].stringValue
    self.questions = self.quesstionsFrom(jsonArray: json["Questions"].array)
  }
  
  func quesstionsFrom(jsonArray: [JSON]?) -> [Question]? {
    guard let jsonArray = jsonArray else { return nil}
    var questionsArray: [Question] = []
    for json in jsonArray {
      questionsArray.append(Question(json: json))
    }
    return questionsArray
  }
}
