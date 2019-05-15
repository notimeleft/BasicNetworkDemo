//
//  ViewController.swift
//  TrueOverflow-JerryWang
//
//  Created by Jerry Wang on 5/9/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit


class QuestionVC: UITableViewController {
    
    let showAnswersSegue = "showAnswersSegue"
    var questions = [QuestionsRequest.Question]()
    
    var questionIndex = 0
    var questionRequest:QuestionRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetupSearchController()
        setupQuestionRequest()
    }
    
    
    
    func SetupSearchController(){
        let searchController = UISearchController(searchResultsController: nil)
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a topic"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        //navigationItem.hidesSearchBarWhenScrolling
        //https://stackoverflow.com/questions/26417591/uisearchcontroller-in-a-uiviewcontroller
        self.definesPresentationContext = true
    }
    
    
    func setupQuestionRequest(){
        let request = QuestionRequest(tag: "javascript", dataHandler: updateTableView)
        self.questionRequest = request
    }
    
    
    func newNetworkRequest(withTag tag:String?, withSort sort:String?){
        if let currentRequest = questionRequest{
            currentRequest.newRequest(tag: tag, sort: sort, dataHandler: updateTableView)
        }
    }
    
    func updateTableView(data:Data) throws -> Void {
        let result = try JSONDecoder().decode(QuestionsRequest.self, from: data)
        self.questions = result.questions
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func sortTapped(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        let sortByVotes = UIAlertAction(title: "votes", style: .default, handler: sortByFilter)
        let sortByActivity = UIAlertAction(title: "activity", style: .default, handler: sortByFilter)
        let sortByHot = UIAlertAction(title: "hot", style: .default, handler: sortByFilter)
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
        case "votes":questionRequest?.newRequest(sort: "votes", dataHandler: updateTableView)
        case "activity":questionRequest?.newRequest(sort: "activity", dataHandler: updateTableView)
        case "hot":questionRequest?.newRequest(sort: "hot", dataHandler: updateTableView)
        default: return
        }
    }
    
    
    //preparation actions before transitioning to answers viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAnswersSegue{
            let answerVC = segue.destination as! AnswerViewController
            answerVC.question = questions[questionIndex]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: questionCellReuseId, for: indexPath) as! QuestionCell
        cell.questionTitleLabel.text =  questions[indexPath.row].title.htmlToString ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        questionIndex = indexPath.row
        performSegue(withIdentifier: showAnswersSegue, sender: self)
    }

}
//this does nothing since we only want to search after the 'search' button in the search bar has been tapped. If we want to request more data after every letter typed, we would implement this
//extension QuestionVC: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
////        guard let text = searchController.searchBar.text else { return }
////        makeRequest(withQuery: text)
//    }
//}

//only perform a network request every time the return button is hit
extension QuestionVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, let currentRequest = self.questionRequest else { return }
        
        currentRequest.newRequest(tag: text, dataHandler: updateTableView)
    }
}

