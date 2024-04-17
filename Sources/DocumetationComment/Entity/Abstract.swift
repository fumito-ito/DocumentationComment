//
//  Abstruct.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation
import Markdown

public struct Abstract {
    public let raw: [Markup]
    public var stringify: String {
        raw.map { $0.format() }.joined(separator: " ")
    }
}
