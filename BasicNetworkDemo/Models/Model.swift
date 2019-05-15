//
//  Model.swift
//  TrueOverflow-JerryWang
//
//  Created by Jerry Wang on 5/12/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import Foundation

let questionCellReuseId = "questionCell"
let answerCellReuseId = "answerCell"

struct QuestionsRequest:Codable {
    let questions:[Question]
    
    struct Question:Codable{
        let title:String
        let id:Int
        
        let text:String
        enum CodingKeys:String,CodingKey{
            case title
            case id = "question_id"
            case text = "body"
        }
    }
    enum CodingKeys:String,CodingKey{
        case questions = "items"
    }
}



struct AnswersRequest:Codable {
    let answers: [Answer]
    
    struct Answer:Codable{
        let owner: Owner
        struct Owner:Codable{
            let name:String
            enum CodingKeys:String, CodingKey{
                case name = "display_name"
            }
        }
        let text:String
        let isAccepted:Bool
        let lastEditDate:Int?
        let creationDate:Int
        
        enum CodingKeys:String,CodingKey{
            case owner
            case text = "body"
            case isAccepted = "is_accepted"
            case lastEditDate = "last_edit_date"
            case creationDate = "creation_date"
        }
        
    }
    enum CodingKeys:String,CodingKey{
        case answers = "items"
    }
}

