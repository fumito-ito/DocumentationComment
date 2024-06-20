//
//  DocumentationCommentExtractorTests.swift
//  
//
//  Created by 伊藤史 on 2024/04/24.
//

import XCTest
import Markdown
@testable import DocumetationComment

final class DocumentationCommentExtractorTests: XCTestCase {
    let markdownText = """
    Returns a command that runs unconditionally before every build.

    Prebuild commands can have a significant performance impact
    and should only be used when there would be no way to know the
    list of output file paths without first reading the contents
    of one or more input files. Typically there is no way to
    determine this list without first running the command, so
    instead of encoding that list, the caller supplies an
    `outputFilesDirectory` parameter, and all files in that
    directory after the command runs are treated as output files.

    ```
    let sampleText = "This is sample text"
    ```

    > the paths in the list of output files may depend on the list
    > of input file paths, but **must not** depend on reading the contents
    > of any input files. Such cases must be handled using a `prebuildCommand`.

    - Parameters:
      - executable: The absolute path to the executable to be invoked.
      - arguments: Command-line arguments to be passed to the executable.
    - Throws: Any error thrown by `deferred` or `work` (in that order).
    - Returns: `true` if a path from `source` to `destination` exists, `false` otherwise.
    - Attention: Special attention is needed for this part.
    - Author: Who is the original author of this code?
    """

    func testExtract() throws {
        let document = Document(parsing: markdownText)
        var extractor = DocumentationCommentExtractor()

        extractor.visit(document)

        XCTAssertEqual(extractor.abstruct?.stringify, "Returns a command that runs unconditionally before every build.")
        XCTAssertEqual(extractor.description?.stringify, """
        Prebuild commands can have a significant performance impact
        and should only be used when there would be no way to know the
        list of output file paths without first reading the contents
        of one or more input files. Typically there is no way to
        determine this list without first running the command, so
        instead of encoding that list, the caller supplies an
        `outputFilesDirectory` parameter, and all files in that
        directory after the command runs are treated as output files.

        ```
        let sampleText = "This is sample text"
        ```

        > the paths in the list of output files may depend on the list
        > of input file paths, but **must not** depend on reading the contents
        > of any input files. Such cases must be handled using a `prebuildCommand`.
        """)

        let parameterExpect = [
            (name: "executable", description: "The absolute path to the executable to be invoked."),
            (name: "arguments", description: "Command-line arguments to be passed to the executable.")
        ]
        XCTAssertEqual(extractor.parameters.count, 2)
        extractor.parameters.enumerated().forEach { index, parameter in
            XCTAssertEqual(parameter.name, parameterExpect[index].name)
            XCTAssertEqual(parameter.description, parameterExpect[index].description)
        }

        XCTAssertEqual(extractor.throws.count, 1)
        let `throws` = try XCTUnwrap(extractor.throws.first)
        XCTAssertEqual(`throws`.description, "Any error thrown by `deferred` or `work` (in that order).")

        XCTAssertEqual(extractor.returns.count, 1)
        let returns = try XCTUnwrap(extractor.returns.first)
        XCTAssertEqual(returns.description, "`true` if a path from `source` to `destination` exists, `false` otherwise.") // swiftlint:disable:this line_length

        let fieldExtensionsExpect = [
            (name: "attention", description: "Special attention is needed for this part."),
            (name: "author", description: "Who is the original author of this code?")
        ]
        XCTAssertEqual(extractor.fieldExtensions.count, 2)
        extractor.fieldExtensions.enumerated().forEach { index, fieldExtension in
            XCTAssertEqual(fieldExtension.name, fieldExtensionsExpect[index].name)
            XCTAssertEqual(fieldExtension.description, fieldExtensionsExpect[index].description)
        }
    }
}
