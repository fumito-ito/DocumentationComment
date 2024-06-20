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

        // I don't know why, but I get multiple `\n` at the beginning of the second paragraph.
        guard let regex = try? Regex("^\n*") else {
            return text
        }

        return text.replacing(regex, with: "")
    }

    mutating func append(paragraph: [Markup]) {
        raw += paragraph
    }
}
