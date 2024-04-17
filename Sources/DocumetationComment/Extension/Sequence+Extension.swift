//
//  Sequence+Extension.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation
import Markdown

extension Sequence<InlineMarkup> {
    /// Converts a string of the form ` {Name}: {Description}` to `Name` and `Description` and returns them.
    ///
    /// - Returns: (name, description) tuple or nil
    private func splitNameAndContent() -> (name: String, content: Markup)? {
        var iterator = makeIterator()
        guard let initialTextNode = iterator.next() as? Text else {
            return nil
        }

        let initialText = initialTextNode.string
        guard let colonIndex = initialText.firstIndex(of: ":") else {
            return nil
        }

        let nameStartIndex = initialText[...colonIndex].lastIndex(of: " ").map { initialText.index(after: $0) } ?? initialText.startIndex
        let parameterName = initialText[nameStartIndex..<colonIndex]
        guard !parameterName.isEmpty else {
            return nil
        }
        let remainingInitialText = initialText.suffix(from: initialText.index(after: colonIndex)).drop { $0 == " " }

        var newInlineContent: [InlineMarkup] = [Text(String(remainingInitialText))]
        while let more = iterator.next() {
            newInlineContent.append(more)
        }
        let newContent: Markup = Paragraph(newInlineContent)

        return (
            String(parameterName),
            newContent
        )
    }
    
    /// Return `Parameter` if `InlineMarkup` is of the form ` x: This is parameter`. Otherwise, return `nil`.
    /// 
    /// - Returns: Parameter or nil
    func extractParameter() -> Parameter? {
        if let (name, content) = splitNameAndContent() {
            return Parameter(raw: Array(self), name: name, description: content.format())
        }

        return nil
    }
}
