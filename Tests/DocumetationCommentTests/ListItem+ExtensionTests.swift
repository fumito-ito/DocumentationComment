//
//  ListItem+ExtensionTests.swift
//  
//
//  Created by Fumito Ito on 2024/04/25.
//

import XCTest
import Markdown
@testable import DocumetationComment

final class ListItem_ExtensionTests: XCTestCase {
    func testExtractFieldExtension() {
        let fieldExtensionSection = """
        - Attention: Special attention is needed for this part.
        - Author: Who is the original author of this code?
        - Authors: List the co-authors of this code.
        - Bug: Describe any known bugs associated with this code.
        - Complexity: What is the computational complexity of this operation?
        - Copyright: Please specify the copyright information for this code.
        - Date: The date this code was written or last updated.
        - Experiment: This code is experimental and may be subject to changes.
        - Important: This information is very important.
        - Invariant: Describe the invariant condition of this code.
        - Note: Provides additional information about this operation.
        - Postcondition: Describe the condition that is guaranteed after this operation.
        - Precondition: Describe the conditions that must be met before starting this operation.
        - Remark: Provides additional comments or explanations.
        - Remarks: Provides multiple comments or explanations.
        - Requires: Describe the conditions required to execute this code.
        - See: Refer to related documents or resources.
        - Since: The version in which this feature was introduced.
        - Todo: List any tasks that are yet to be completed for this code.
        - Version: The current version number of this code.
        - Warning: Warns about potential problems or precautions when using this code.
        """
        let document = Document(parsing: fieldExtensionSection)
        let items = (document.child(at: 0) as? UnorderedList)?.listItems.enumerated()

        let expects = [
            (name: "attention", description: "Special attention is needed for this part."),
            (name: "author", description: "Who is the original author of this code?"),
            (name: "authors", description: "List the co-authors of this code."),
            (name: "bug", description: "Describe any known bugs associated with this code."),
            (name: "complexity", description: "What is the computational complexity of this operation?"),
            (name: "copyright", description: "Please specify the copyright information for this code."),
            (name: "date", description: "The date this code was written or last updated."),
            (name: "experiment", description: "This code is experimental and may be subject to changes."),
            (name: "important", description: "This information is very important."),
            (name: "invariant", description: "Describe the invariant condition of this code."),
            (name: "note", description: "Provides additional information about this operation."),
            (name: "postcondition", description: "Describe the condition that is guaranteed after this operation."),
            (name: "precondition", description: "Describe the conditions that must be met before starting this operation."),
            (name: "remark", description: "Provides additional comments or explanations."),
            (name: "remarks", description: "Provides multiple comments or explanations."),
            (name: "requires", description: "Describe the conditions required to execute this code."),
            (name: "see", description: "Refer to related documents or resources."),
            (name: "since", description: "The version in which this feature was introduced."),
            (name: "todo", description: "List any tasks that are yet to be completed for this code."),
            (name: "version", description: "The current version number of this code."),
            (name: "warning", description: "Warns about potential problems or precautions when using this code."),
        ]

        items!.forEach({ index, item in
            let ext = item.extractFieldExtension()

            XCTAssertEqual(ext?.name, expects[index].name)
            XCTAssertEqual(ext?.description, expects[index].description)
        })
    }

    func testExtractThrows() {
        let throwsSection = "- Throws: Any error thrown by `deferred` or `work` (in that order)."
        let document = Document(parsing: throwsSection)
        let listItem = (document.child(at: 0) as? UnorderedList)?.listItems.first(where: { _ in true })
        let returns = listItem?.extractThrowsDescription()

        XCTAssertEqual(returns?.description, "Any error thrown by `deferred` or `work` (in that order).")
    }

    func testExtractReturns() {
        let returnsSection = "- Returns: `true` if a path from `source` to `destination` exists, `false` otherwise."
        let document = Document(parsing: returnsSection)
        // コンテンツは一つしか存在しないので最初のchildを見るだけで良い
        let listItem = (document.child(at: 0) as? UnorderedList)?.listItems.first(where: { _ in true })
        let returns = listItem?.extractReturnDescription()

        XCTAssertEqual(returns?.description, "`true` if a path from `source` to `destination` exists, `false` otherwise.")
    }

    func testExtractParametersSectionWithRemainingText() throws {
        let parametersSection = """
        - parameters:
          - inputFiles: Files on which the contents of output files may depend.
            Any paths passed as `arguments` should typically be passed here as
            well.
          - outputFiles: Files to be generated or updated by the executable.
            Any files recognizable by their extension as source files
            (e.g. `.swift`) are compiled into the target for which this command
            was generated as if in its source directory; other files are treated
            as resources as if explicitly listed in `Package.swift` using
            `.process(...)`.
        """
        let document = Document(parsing: parametersSection)
        // ここもtop levelのlistitemは1個しかないので最初のやつを見れば良い
        let listItem = (document.child(at: 0) as? UnorderedList)?.listItems.first(where: { _ in true })
        let parameters = try XCTUnwrap(listItem?.extractParameterOutline())

        XCTAssertEqual(parameters[0].name, "inputFiles")
        XCTAssertEqual(parameters[0].description, """
        Files on which the contents of output files may depend.
        Any paths passed as `arguments` should typically be passed here as
        well.
        """)
        XCTAssertEqual(parameters[1].name, "outputFiles")
        XCTAssertEqual(parameters[1].description, """
        Files to be generated or updated by the executable.
        Any files recognizable by their extension as source files
        (e.g. `.swift`) are compiled into the target for which this command
        was generated as if in its source directory; other files are treated
        as resources as if explicitly listed in `Package.swift` using
        `.process(...)`.
        """)
    }

    func testExtractParametersSection() throws {
        let parametersSection = """
        - parameters:
          - executable: The absolute path to the executable to be invoked.
          - arguments: Command-line arguments to be passed to the executable.
        """
        let document = Document(parsing: parametersSection)
        // ここもtop levelのlistitemは1個しかないので最初のやつを見れば良い
        let listItem = (document.child(at: 0) as? UnorderedList)?.listItems.first(where: { _ in true })
        let parameters = try XCTUnwrap(listItem?.extractParameterOutline())

        XCTAssertEqual(parameters[0].name, "executable")
        XCTAssertEqual(parameters[0].description, "The absolute path to the executable to be invoked.")
        XCTAssertEqual(parameters[1].name, "arguments")
        XCTAssertEqual(parameters[1].description, "Command-line arguments to be passed to the executable.")
    }

    func testExtractStandaloneParameterWithRemainingText() {
        let singleParameterWithRemainingText = """
        - parameter inputFiles: Files on which the contents of output files may depend.
          Any paths passed as `arguments` should typically be passed here as
          well.
        """
        let document = Document(parsing: singleParameterWithRemainingText)
        let listItem = (document.child(at: 0) as? UnorderedList)?.listItems.first(where: { _ in true })
        let parameter = listItem?.extractStandaloneParameter()

        XCTAssertEqual(parameter?.name, "inputFiles")
        XCTAssertEqual(parameter?.description, """
        Files on which the contents of output files may depend.
        Any paths passed as `arguments` should typically be passed here as
        well.
        """)
    }

    func testExtractStandaloneParameter() {
        let singleParameter = "- Parameter displayName: An optional string to show in build logs and other status areas."
        let document = Document(parsing: singleParameter)
        // コンテンツは一つしか存在しないので最初のchildを見るだけで良い
        let listItem = (document.child(at: 0) as? UnorderedList)?.listItems.first(where: { _ in true })
        let parameter = listItem?.extractStandaloneParameter()

        XCTAssertEqual(parameter?.name, "displayName")
        XCTAssertEqual(parameter?.description, "An optional string to show in build logs and other status areas.")
    }
}
