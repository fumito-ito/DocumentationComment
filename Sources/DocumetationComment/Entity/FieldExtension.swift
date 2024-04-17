//
//  FieldExtension.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation
import Markdown

public struct FieldExtension {
    public let raw: [Markup]
    public let name: String
    public let description: String
}

enum FieldExtensions: String, CaseIterable {
    case attention
    case author
    case authors
    case bug
    case complexity
    case copyright
    case date
    case experiment
    case important
    case invariant
    case note
    case postcondition
    case precondition
    case remark
    case remarks
    case requires
    case see
    case since
    case todo
    case version
    case warning

    var name: String {
        return self.rawValue
    }
}
