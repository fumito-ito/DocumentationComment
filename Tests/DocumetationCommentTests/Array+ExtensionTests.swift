//
//  Array+ExtensionTests.swift
//  
//
//  Created by Fumito Ito on 2024/04/26.
//

import XCTest
import Markdown
@testable import DocumetationComment

final class Array_ExtensionTests: XCTestCase {
    func testAppendIfNotEmpty() {
        var array = [Markup]()
        let markup = Document(parsing: "- Parameter x: This is parameter x")

        array.appendIfNotEmpty(markup)

        XCTAssertEqual(array.count, 1)
    }

    func testNewLineIsEmpty() {
        var array = [Markup]()
        let markup = Document(parsing: "\n")

        array.appendIfNotEmpty(markup)

        XCTAssertEqual(array.count, 0)
    }

    func testNotAppendIfEmpty() {
        var array = [Markup]()
        let markup = Document(parsing: "")

        array.appendIfNotEmpty(markup)

        XCTAssertEqual(array.count, 0)
    }
}
