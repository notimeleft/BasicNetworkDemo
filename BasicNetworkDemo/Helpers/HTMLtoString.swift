//
//  HTMLtoString.swift
//  TrueOverflow-JerryWang
//
//  Created by Jerry Wang on 5/12/19.
//  Copyright © 2019 Jerry Wang. All rights reserved.
//

import Foundation

extension String {
    //https://stackoverflow.com/a/47230632/6096470
    
    private var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String? {
        return htmlToAttributedString?.string
    }
}
