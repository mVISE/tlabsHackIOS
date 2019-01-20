//
//  User.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit
import SwiftyJSON

class User {

  var userID: String?
  var score: Int = 0
  
  init(userID: String?, score: Int = 0) {
    self.userID = userID
    self.score = score
  }
  
  init(jsonData: Data) {
    guard let json = try? JSON(data: jsonData) else { return }
    
    self.score = json["Score"].intValue
    self.userID = json["UserID"].stringValue
  }
  
  
  
}
