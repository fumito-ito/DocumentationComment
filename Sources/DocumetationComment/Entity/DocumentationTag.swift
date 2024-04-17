//
//  DocumentationTag.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation

enum DocumentationTag: String {
    case parameters
    case parameter
    case returns
    case `throws`

    var name: String {
        return self.rawValue
    }
}
