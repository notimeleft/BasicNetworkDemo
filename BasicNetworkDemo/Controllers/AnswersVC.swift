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
    var answerRequest:AnswerRequest?
    
    override func viewDidLoad() {
        navigationItem.title = question?.title.htmlToString
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        setupAnswerRequest()
    }
    
    func setupAnswerRequest(){
        if let questionId = question?.id{
            answerRequest = AnswerRequest(questionId: questionId, dataHandler: updateTableView)
        }
    }
    
    @IBAction func sortAnswersTapped(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        let sortByVotes = UIAlertAction(title: "votes", style: .default, handler: sortByFilter)
        let sortByActivity = UIAlertAction(title: "activity", style: .default, handler: sortByFilter)
        let sortByHot = UIAlertAction(title: "creation", style: .default, handler: sortByFilter)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alertVC.addAction(sortByVotes)
        alertVC.addAction(sortByActivity)
        alertVC.addAction(sortByHot)
        alertVC.addAction(cancel)
        //get the source view and frame of the button itself, for iPad display
        if let sourceView = sender.value(forKey:"view") as? UIView {
            alertVC.popoverPresentationController?.sourceView = sourceView
            alertVC.popoverPresentationController?.sourceRect = sourceView.frame
        }
        self.present(alertVC, animated:true)
    }
    
    func sortByFilter(action:UIAlertAction){
        switch action.title{
        case "votes": answerRequest?.newRequest(sort: "votes", dataHandler: updateTableView)
        case "activity": answerRequest?.newRequest(sort: "activity", dataHandler: updateTableView)
        case "creation": answerRequest?.newRequest(sort: "creation", dataHandler: updateTableView)
        default: return
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
