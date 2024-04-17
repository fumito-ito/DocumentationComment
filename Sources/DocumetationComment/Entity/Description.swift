//
//  Description.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation
import Markdown

public struct Description {
    public private(set) var raw: [Markup]
    public var stringify: String {
        let text = raw.map { $0.format() }.joined()

        // FIXME: なんでかわからんけど2つ目のparagraphの先頭に `\n` が複数ついてしまう
        let regex = try! Regex("^\n*")
        return text.replacing(regex, with: "")
    }

    mutating func append(paragraph: [Markup]) {
        raw += paragraph
    }
}
