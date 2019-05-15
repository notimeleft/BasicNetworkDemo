//
//  basicNetworkRequest.swift
//  TrueOverflow-JerryWang
//
//  Created by Jerry Wang on 5/9/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

class NetworkRequest{
    
    fileprivate let baseRequest = "https://api.stackexchange.com/2.2/"

    fileprivate func makeNetworkRequest(url:URL,dataHandler:@escaping(Data) throws -> Void){
        URLSession.shared.dataTask(with: url){
            (data,response,error) in
            guard let responseCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if responseCode < 200 || responseCode > 300 {
                print("invalid http status \(responseCode)")
                return
            }
            if let data = data {
                do {
                    try dataHandler(data)
                } catch {
                    print("failed to handle data properly")
                }
            }
            if let error = error {
                print("error!",error.localizedDescription)
            }
            }.resume()
    }

}



class QuestionRequest:NetworkRequest{
    private var tag:String?
    private var sort:String?
    private var url:URL? {
        return URL(string:super.baseRequest + self.questionRequestString())
    }
    
    init(tag:String,sort:String = "votes",dataHandler:@escaping (Data) throws -> Void){
        super.init()
        newRequest(tag: tag, sort: sort,dataHandler: dataHandler)
    }
    
    func newRequest(tag:String? = nil, sort:String? = nil, dataHandler:@escaping (Data) throws -> Void){
        if let validTag = tag { self.tag = validTag }
        if let validSort = sort { self.sort = validSort }
        
        if let validURL = self.url {
            makeNetworkRequest(url:validURL,dataHandler: dataHandler)
        }
    }
    
    private func questionRequestString()->String{
        return "questions?pagesize=10&order=desc&sort=\(self.sort ?? "votes")&tagged=\(self.tag ?? "javascript")&site=stackoverflow&filter=withbody"
    }
    
    
}


class AnswerRequest:NetworkRequest{
    private var questionId:Int?
    private var sort: String?
    
    private var url: URL? {
        return URL(string:(super.baseRequest + answerRequestString()!))
    }
    
    init(questionId:Int, sort:String = "activity", dataHandler:@escaping (Data) throws -> Void){
        self.questionId = questionId
        super.init()
        newRequest(dataHandler: dataHandler)
    }
    
    func newRequest(sort:String? = nil, dataHandler: @escaping (Data) throws -> Void){
        self.sort = sort
        if let url = self.url {
            makeNetworkRequest(url: url, dataHandler: dataHandler)
        }
    }
    
    private func answerRequestString()->String? {
        guard let validId = self.questionId else { return nil }
        
        return "questions/\(validId)/answers?pagesize=4&order=desc&sort=\(self.sort ?? "activity")&site=stackoverflow&filter=!9Z(-wzu0T"
    }
}
