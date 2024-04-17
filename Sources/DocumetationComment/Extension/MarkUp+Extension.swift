//
//  MarkUp+Extension.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation
import Markdown

extension Markup {
    /// Return true if conetnt is top level object
    var isTopLevelObject: Bool {
        if let parent {
            return parent.parent == nil || parent.parent is Document
        }

        return false
    }
}
