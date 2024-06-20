//
//  File.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation
import Markdown

public struct Parameter {
    public private(set) var raw: [Markup]
    public let name: String
    public private(set) var description: String

    /// Append new content into this object's description
    /// - Parameter appdendix: content to append
    mutating func appendDescription(_ appdendix: [Markup]) {
        self.raw += appdendix
        let appendixString = appdendix.map { $0.format() }.joined(separator: " ")
        self.description = description + appendixString
    }
}
