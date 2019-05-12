//
//  basicNetworkRequest.swift
//  TrueOverflow-JerryWang
//
//  Created by Jerry Wang on 5/9/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import UIKit

class NetworkRequest{
    
    let baseRequest = "https://api.stackexchange.com/2.2/"
   
    var url:URL?
    
    init?(tag:String){
        if let url = URL(string:baseRequest + getQuestionsRequestURL(tag: tag)){
            self.url = url
        } else { return nil }
    }
    init?(questionId:Int){
        if let url = URL(string:baseRequest + getAnswersRequestURL(questionId: questionId)){
            self.url = url
        } else { return nil }
    }

    func getQuestionsRequestURL(tag:String)->String{
        return "questions?order=desc&sort=activity&tagged=\(tag)&site=stackoverflow&filter=withbody"
    }
    
    func getAnswersRequestURL(questionId:Int)->String{
        return "questions/\(questionId)/answers?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wzu0T"
    }

    func makeNetworkRequest(dataHandler:@escaping(Data) throws -> Void){
        guard let url = self.url else { return }
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
