//
//  ItemInteractionViewController.swift
//  tlabshack
//
//  Created by Marcel Hassemer, mVISE AG on 19.01.19 KW 3.
//  Copyright © 2019 Marcel Hassemer. All rights reserved.
//

import UIKit

class ItemInteractionViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var item: ItemInformation?
  var user: User?
  var scannedItemString = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.loadItemInformation()
    self.tableView.dataSource = self
    self.tableView.delegate = self
  }
  
  func loadItemInformation() {
    
    BackendConnection().getItemInfo(itemID: scannedItemString) { itemInfo, error in
      
      print(error as Any)
      
      if error != nil {
        self.dismiss(animated: false, completion: nil)
        return
      }
      
      self.item = itemInfo
      DispatchQueue.main.async {
       self.tableView.reloadData()
      }
    }
  }
}

extension ItemInteractionViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell",
      for: indexPath) as! QuestionTableViewCell
    let question = self.item?.questions?[indexPath.row]
    cell.questionLabel.text = question?.question
    cell.questionID = question?.id
    cell.questionSwitch.setOn(false, animated: false)
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let item = self.item else { return 0 }
    guard let questions = item.questions else { return 0 }
    return questions.count
  }
  
  @IBAction func sendButtonAction(_ sender: Any) {
    var answers = [String: Bool]()
    for answerIndex in 0 ... tableView.numberOfRows(inSection: 0) - 1 {
      let cell = tableView.cellForRow(at: IndexPath(row: answerIndex, section: 0)) as? QuestionTableViewCell
      answers[cell?.questionID! ?? "0"] = cell?.questionSwitch.isOn ?? false
    }
    let answerItem = ItemAnswer.init(item: self.item, user: self.user, answers: answers, signature: "Signature")
    
    BackendConnection().postAnswer(answer: answerItem) { (success, error) in
      if error != nil {
        let message = "Fail"
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (_) in
          self.navigationController?.popToRootViewController(animated: true)
        }))
        return
      }
      if success {
        DispatchQueue.main.async {
          self.navigationController?.popToRootViewController(animated: true)
        }
      }
    }
  }
  
}
