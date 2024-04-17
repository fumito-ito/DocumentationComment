//
//  DocumentationCommentExtractor.swift
//  
//
//  Created by 伊藤史 on 2024/04/22.
//

import Foundation
import Markdown

struct DocumentationCommentExtractor: MarkupWalker {
    private var note = [Markup]()
    var abstruct: Abstract? {
        if let markup = note.first {
            return Abstract(raw: [markup])
        }

        return nil
    }

    var description: Description? {
        let markup = Array(note.dropFirst())
        guard markup.isEmpty == false else {
            return nil
        }

        return Description(raw: markup)
    }

    private(set) var parameters = [Parameter]()
    private(set) var returns = [Returns]()
    private(set) var `throws` = [Throws]()
    private(set) var fieldExtensions = [FieldExtension]()

    mutating func visitParagraph(_ paragraph: Paragraph) -> () {
        note.appendIfNotEmpty(paragraph)
    }

    mutating func visitHeading(_ heading: Heading) -> () {
        note.appendIfNotEmpty(heading)
    }

    mutating func visitCustomBlock(_ customBlock: CustomBlock) -> () {
        note.appendIfNotEmpty(customBlock)
    }

    mutating func visitHTMLBlock(_ html: HTMLBlock) -> () {
        note.appendIfNotEmpty(html)
    }

    mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> () {
        note.appendIfNotEmpty(codeBlock)
    }

    mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> () {
        note.appendIfNotEmpty(blockQuote)
    }

    mutating func visitTable(_ table: Table) -> () {
        note.appendIfNotEmpty(table)
    }

    mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> () {
        note.appendIfNotEmpty(thematicBreak)
    }

    mutating func visitListItem(_ listItem: ListItem) -> () {
        guard listItem.isTopLevelObject else {
            return
        }

        if let returnDescription = listItem.extractReturnDescription() {
            // - returns: ...
            returns.append(returnDescription)
        } else if let throwsDescription = listItem.extractThrowsDescription() {
             // - throws: ...
             `throws`.append(throwsDescription)
        } else if let parameterDescriptions = listItem.extractParameterOutline() {
            // - Parameters:
            //   - x: ...
            //   - y: ...
            parameters.append(contentsOf: parameterDescriptions)
        } else if let parameterDescription = listItem.extractStandaloneParameter() {
            // - parameter x: ...
            parameters.append(parameterDescription)
        } else if let fieldExtension = listItem.extractFieldExtension() {
            // - todo: ...
            // etc.
            fieldExtensions.append(fieldExtension)
        }
    }
}
