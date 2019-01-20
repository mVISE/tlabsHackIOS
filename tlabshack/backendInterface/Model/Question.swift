//
//  Question.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit
import SwiftyJSON

class Question {

  var id: String?
  var question: String?
  
  init(id: String? = nil, question: String? = nil) {
    
  }
  
  init(jsonData: Data) {
    guard let json = try? JSON(data: jsonData) else { return }
    self.update(json: json)
  }
  
  init(json: JSON) {
    self.update(json: json)
  }
  
  func update(json: JSON) {
    self.id = json["ID"].stringValue
    self.question = json["Question"].stringValue
  }
  
}
