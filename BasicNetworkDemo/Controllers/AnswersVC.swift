//
//  AnswerViewController.swift
//  TrueOverflow-JerryWang
//
//  Created by Jerry Wang on 5/9/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

class AnswerViewController:UITableViewController{
    
    var question:QuestionsRequest.Question?
    var answers = [AnswersRequest.Answer]()
    
    override func viewDidLoad() {
        navigationItem.title = question?.title.htmlToString
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        requestAndUpdate()
    }
    
    func requestAndUpdate(){
        if let questionId = question?.id,let answersRequest = NetworkRequest(questionId: questionId){
            answersRequest.makeNetworkRequest(dataHandler: updateTableView)
        }
    }
    
    func updateTableView(data:Data)throws -> Void{
        let result = try JSONDecoder().decode(AnswersRequest.self, from: data)
        self.answers = result.answers
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //we need an extra cell for question title and text
        return answers.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: answerCellReuseId, for: indexPath) as! AnswerCell
        
        if indexPath.row == 0 {
            cell.nameLabel.text = question?.title.htmlToString
            cell.bodyLabel.text = question?.text.htmlToString
            cell.dateLabel.text = ""
        } else {
            
            cell.nameLabel.text = answers[indexPath.row-1].owner.name.htmlToString ?? ""
            cell.bodyLabel.text = answers[indexPath.row-1].text.htmlToString
            cell.dateLabel.text = String(answers[indexPath.row-1].creationDate)
            let date = Date(timeIntervalSince1970: TimeInterval(answers[indexPath.row-1].creationDate))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "EST")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
            let readableDate = dateFormatter.string(from: date)
            cell.dateLabel.text = readableDate
        }
        
        return cell
    }
}
