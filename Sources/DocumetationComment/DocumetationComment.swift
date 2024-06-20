// The Swift Programming Language
// https://docs.swift.org/swift-book

import Markdown
import Foundation

public struct DocumentationComment {
    public let raw: String
    public let abstract: Abstract?
    public let description: Description?
    public let parameters: [Parameter]
    public let returns: [Returns]
    public let `throws`: [Throws]
    public let fieldExtensions: [FieldExtension]

    init(
        raw: String,
        abstract: Abstract?,
        description: Description?,
        parameters: [Parameter],
        returns: [Returns],
        throws: [Throws],
        fieldExtensions: [FieldExtension]
    ) {
        self.raw = raw
        self.abstract = abstract
        self.description = description
        self.parameters = parameters
        self.returns = returns
        self.throws = `throws`
        self.fieldExtensions = fieldExtensions
    }

    public init(lines: [String]) throws {
        let string = lines.joined(separator: "\n")
        try self.init(string)
    }

    public init(_ string: String) throws {
        let trimedString = Self.trimCommentSyntax(string)
        let document = Document(parsing: trimedString)
        try self.init(markdown: document)
    }

    public init(markdown: Document) throws {
        var extractor = DocumentationCommentExtractor()
        extractor.visit(markdown)

        self.init(
            raw: markdown.format(),
            abstract: extractor.abstruct,
            description: extractor.description,
            parameters: extractor.parameters,
            returns: extractor.returns,
            throws: extractor.throws,
            fieldExtensions: extractor.fieldExtensions
        )
    }

    static func trimCommentSyntax(_ comment: String) -> String {
        // Really want to replace only the `///(\n|\r|\r\n)` part of `///`.
        guard let regex = try? Regex("(/// )|(///)|(/\\*\\n)|(\\*/)") else {
            return comment
        }

        return comment.replacing(regex, with: "")
    }
}
