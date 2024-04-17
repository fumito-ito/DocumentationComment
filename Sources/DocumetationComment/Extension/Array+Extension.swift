//
//  Array+Extension.swift
//
//
//  Created by Fumito Ito on 2024/04/26.
//

import Foundation
import Markdown

extension Array<Markup> {
    /// Append `Markup` object if markup content is empty `""` or `"\n"`
    ///
    /// - Parameter markup: `Markup` content to append
    mutating func appendIfNotEmpty(_ markup: Markup) {
        guard markup.format().isEmpty == false else {
            return
        }

        append(markup)
    }
}
