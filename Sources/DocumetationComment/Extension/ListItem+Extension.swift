//
//  ListItem+Extension.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import Foundation
import Markdown

extension ListItem {
    /// Try to extract a tag start from this list item.
    ///
    /// - Parameters:
    ///   - tag: tag name to match
    ///   - dropTag: drop the tag name from the content
    /// - Returns: returns: If the tag was matched, return the remaining content after the match. Otherwise, return `nil`.
    func extractTag(_ tag: String, dropTag: Bool = true) -> [InlineMarkup]? {
        guard let firstParagraph = child(at: 0) as? Paragraph,
              let text = firstParagraph.child(at: 0) as? Text else {
            return nil
        }

        let trimmedText = text.string.drop { char -> Bool in
            guard let scalar = char.unicodeScalars.first else { return false }
            return CharacterSet.whitespaces.contains(scalar)
        }.lowercased()

        if trimmedText.starts(with: tag.lowercased()) {
            var newText = text.string
            if dropTag {
                newText = String(text.string.dropFirst(text.string.count - trimmedText.count + tag.count).drop(while: { $0 == " " }))
            }
            return [Text(newText)] + Array(firstParagraph.inlineChildren.dropFirst(1))
        }

        return nil
    }

    /// Extract a standalone parameter description from this list item.
    /// Expected form:
    ///
    /// ```markdown
    /// - parameter x: A number.
    /// ```
    ///
    /// - Returns: If the tag was matched, Parameter object extracted from markdown. Otherwise, return nil.
    func extractStandaloneParameter() -> Parameter? {
        guard extractTag(DocumentationTag.parameter.name) != nil else {
            return nil
        }
        // Don't use the return value from `extractTag` here. It drops the range and source information from the markup which means that we can't present diagnostics about the parameter.
        return (child(at: 0) as? Paragraph)?.inlineChildren.extractParameter()
    }

    /// Extracts an outline of parameters from a sublist underneath this list item.
    ///
    /// Expected form:
    ///
    /// ```markdown
    /// - Parameters:
    ///   - x: a number
    ///   - y: a number
    /// ```
    ///
    /// > Warning: Content underneath `- Parameters` that doesn't match this form will be dropped.
    ///
    /// - Returns: If the tag was matched, Parameter objects extracted from markdown. Otherwise, return nil.
    func extractParameterOutline() -> [Parameter]? {
        guard extractTag(DocumentationTag.parameters.name + ":") != nil else {
            return nil
        }

        var parameters = [Parameter]()

        for child in children {
            // The list `- Parameters:` should have one child, a list of parameters.
            guard let parameterList = child as? UnorderedList else {
                // If it's not, that content is dropped.
                continue
            }

            // Those sublist items are assumed to be a valid `- ___: ...` parameter form or else they are dropped.
            for child in parameterList.children {
                guard let listItem = child as? ListItem,
                      let firstParagraph = listItem.child(at: 0) as? Paragraph,
                      var parameter = Array(firstParagraph.inlineChildren).extractParameter() else {
                    continue
                }
                // Don't forget the rest of the content under this parameter list item.
                parameter.appendDescription(Array(listItem.children.dropFirst(1)))

                parameters.append(parameter)
            }
        }
        return parameters
    }

    /// Extract a return description from a list item.
    ///
    /// Expected form:
    ///
    /// ```markdown
    /// - returns: ...
    /// ```
    ///
    /// - Returns: If the tag was matched, Returns object extracted from markdown. Otherwise, return nil.
    func extractReturnDescription() -> Returns? {
        guard let remainder = extractTag(DocumentationTag.returns.name + ":") else {
            return nil
        }

        return Returns(raw: Array(self.children), description: remainder.map { $0.plainText }.joined())
    }

    /// Extract a throw description from a list item.
    ///
    /// Expected form:
    ///
    /// ```markdown
    /// - throws: ...
    /// ```
    ///
    /// - Returns: If the tag was matched, Throws objects extracted from markdown. Otherwise, return nil.
    func extractThrowsDescription() -> Throws? {
        guard let remainder = extractTag(DocumentationTag.throws.name + ":") else {
            return nil
        }

        return Throws(raw: Array(self.children), description: remainder.map { $0.plainText }.joined())
    }

    /// Extract a field extension from the list of known list item tags.
    ///
    /// Expected form:
    ///
    /// ```markdown
    /// - todo: ...
    /// - seeAlso: ...
    /// ```
    ///
    /// For more detail about the field extensions, see https://github.com/apple/swift/blob/main/docs/DocumentationComments.md#field-extensions
    /// - Returns: If the tag was matched, FieldExtension object extracted from markdown. Otherwise, return nil.
    func extractFieldExtension() -> FieldExtension? {
        for fieldExtensionTagName in FieldExtensions.allCases.map({ $0.name }) {
            if let contents = extractTag(fieldExtensionTagName + ":") {
                return FieldExtension(raw: Array(self.children), name: fieldExtensionTagName, description: contents.map { $0.plainText }.joined(separator: " "))
            }
        }

        return nil
    }
}
