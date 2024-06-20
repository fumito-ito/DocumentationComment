//
//  DocumentationCommentTests.swift
//  
//
//  Created by 伊藤史 on 2024/04/25.
//

// swiftlint:disable file_length
import XCTest
import Markdown
@testable import DocumetationComment

// swiftlint:disable:next type_body_length
final class DocumentationCommentTests: XCTestCase {
    // MARK: Constructor tests
    // swiftlint:disable:next function_body_length
    func testInitWithAnnotationCommentLines() throws {
        let blockComment = """
        /// Returns a command that runs unconditionally before every build.
        ///
        /// Prebuild commands can have a significant performance impact
        /// and should only be used when there would be no way to know the
        /// list of output file paths without first reading the contents
        /// of one or more input files. Typically there is no way to
        /// determine this list without first running the command, so
        /// instead of encoding that list, the caller supplies an
        /// `outputFilesDirectory` parameter, and all files in that
        /// directory after the command runs are treated as output files.
        ///
        /// ```
        /// let sampleText = "This is sample text"
        /// ```
        ///
        /// > the paths in the list of output files may depend on the list
        /// > of input file paths, but **must not** depend on reading the contents
        /// > of any input files. Such cases must be handled using a `prebuildCommand`.
        ///
        /// - Parameters:
        ///   - executable: The absolute path to the executable to be invoked.
        ///   - arguments: Command-line arguments to be passed to the executable.
        /// - Throws: Any error thrown by `deferred` or `work` (in that order).
        /// - Returns: `true` if a path from `source` to `destination` exists, `false` otherwise.
        /// - Attention: Special attention is needed for this part.
        /// - Author: Who is the original author of this code?
        """
        let blockCommentLines = blockComment.components(separatedBy: .newlines)

        let docComment = try DocumentationComment(lines: blockCommentLines)

        XCTAssertEqual(
            docComment.abstract?.stringify,
            "Returns a command that runs unconditionally before every build."
        )
        XCTAssertEqual(docComment.description?.stringify, """
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
        XCTAssertEqual(docComment.parameters.count, 2)
        docComment.parameters.enumerated().forEach { index, parameter in
            XCTAssertEqual(parameter.name, parameterExpect[index].name)
            XCTAssertEqual(parameter.description, parameterExpect[index].description)
        }

        XCTAssertEqual(docComment.throws.count, 1)
        let `throws` = try XCTUnwrap(docComment.throws.first)
        XCTAssertEqual(`throws`.description, "Any error thrown by `deferred` or `work` (in that order).")

        XCTAssertEqual(docComment.returns.count, 1)
        let returns = try XCTUnwrap(docComment.returns.first)
        XCTAssertEqual(
            returns.description,
            "`true` if a path from `source` to `destination` exists, `false` otherwise."
        )

        let fieldExtensionsExpect = [
            (name: "attention", description: "Special attention is needed for this part."),
            (name: "author", description: "Who is the original author of this code?")
        ]
        XCTAssertEqual(docComment.fieldExtensions.count, 2)
        docComment.fieldExtensions.enumerated().forEach { index, fieldExtension in
            XCTAssertEqual(fieldExtension.name, fieldExtensionsExpect[index].name)
            XCTAssertEqual(fieldExtension.description, fieldExtensionsExpect[index].description)
        }
    }

    // swiftlint:disable:next function_body_length
    func testInitWithAnnotationComment() throws {
        let blockComment = """
        /// Returns a command that runs unconditionally before every build.
        ///
        /// Prebuild commands can have a significant performance impact
        /// and should only be used when there would be no way to know the
        /// list of output file paths without first reading the contents
        /// of one or more input files. Typically there is no way to
        /// determine this list without first running the command, so
        /// instead of encoding that list, the caller supplies an
        /// `outputFilesDirectory` parameter, and all files in that
        /// directory after the command runs are treated as output files.
        ///
        /// ```
        /// let sampleText = "This is sample text"
        /// ```
        ///
        /// > the paths in the list of output files may depend on the list
        /// > of input file paths, but **must not** depend on reading the contents
        /// > of any input files. Such cases must be handled using a `prebuildCommand`.
        ///
        /// - Parameters:
        ///   - executable: The absolute path to the executable to be invoked.
        ///   - arguments: Command-line arguments to be passed to the executable.
        /// - Throws: Any error thrown by `deferred` or `work` (in that order).
        /// - Returns: `true` if a path from `source` to `destination` exists, `false` otherwise.
        /// - Attention: Special attention is needed for this part.
        /// - Author: Who is the original author of this code?
        """

        let docComment = try DocumentationComment(blockComment)

        XCTAssertEqual(
            docComment.abstract?.stringify,
            "Returns a command that runs unconditionally before every build."
        )
        XCTAssertEqual(docComment.description?.stringify, """
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
        XCTAssertEqual(docComment.parameters.count, 2)
        docComment.parameters.enumerated().forEach { index, parameter in
            XCTAssertEqual(parameter.name, parameterExpect[index].name)
            XCTAssertEqual(parameter.description, parameterExpect[index].description)
        }

        XCTAssertEqual(docComment.throws.count, 1)
        let `throws` = try XCTUnwrap(docComment.throws.first)
        XCTAssertEqual(`throws`.description, "Any error thrown by `deferred` or `work` (in that order).")

        XCTAssertEqual(docComment.returns.count, 1)
        let returns = try XCTUnwrap(docComment.returns.first)
        XCTAssertEqual(
            returns.description,
            "`true` if a path from `source` to `destination` exists, `false` otherwise."
        )

        let fieldExtensionsExpect = [
            (name: "attention", description: "Special attention is needed for this part."),
            (name: "author", description: "Who is the original author of this code?")
        ]
        XCTAssertEqual(docComment.fieldExtensions.count, 2)
        docComment.fieldExtensions.enumerated().forEach { index, fieldExtension in
            XCTAssertEqual(fieldExtension.name, fieldExtensionsExpect[index].name)
            XCTAssertEqual(fieldExtension.description, fieldExtensionsExpect[index].description)
        }
    }

    // swiftlint:disable:next function_body_length
    func testInitWithBlockCommentLines() throws {
        let blockComment = """
        /*
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
         */
        """
        let blockCommentLines = blockComment.components(separatedBy: .newlines)

        let docComment = try DocumentationComment(lines: blockCommentLines)

        XCTAssertEqual(
            docComment.abstract?.stringify,
            "Returns a command that runs unconditionally before every build."
        )
        XCTAssertEqual(docComment.description?.stringify, """
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
        XCTAssertEqual(docComment.parameters.count, 2)
        docComment.parameters.enumerated().forEach { index, parameter in
            XCTAssertEqual(parameter.name, parameterExpect[index].name)
            XCTAssertEqual(parameter.description, parameterExpect[index].description)
        }

        XCTAssertEqual(docComment.throws.count, 1)
        let `throws` = try XCTUnwrap(docComment.throws.first)
        XCTAssertEqual(`throws`.description, "Any error thrown by `deferred` or `work` (in that order).")

        XCTAssertEqual(docComment.returns.count, 1)
        let returns = try XCTUnwrap(docComment.returns.first)
        XCTAssertEqual(
            returns.description,
            "`true` if a path from `source` to `destination` exists, `false` otherwise."
        )

        let fieldExtensionsExpect = [
            (name: "attention", description: "Special attention is needed for this part."),
            (name: "author", description: "Who is the original author of this code?")
        ]
        XCTAssertEqual(docComment.fieldExtensions.count, 2)
        docComment.fieldExtensions.enumerated().forEach { index, fieldExtension in
            XCTAssertEqual(fieldExtension.name, fieldExtensionsExpect[index].name)
            XCTAssertEqual(fieldExtension.description, fieldExtensionsExpect[index].description)
        }
    }

    // swiftlint:disable:next function_body_length
    func testInitWithBlockComment() throws {
        let blockComment = """
        /*
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
         */
        """

        let docComment = try DocumentationComment(blockComment)

        XCTAssertEqual(
            docComment.abstract?.stringify,
            "Returns a command that runs unconditionally before every build."
        )
        XCTAssertEqual(docComment.description?.stringify, """
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
        XCTAssertEqual(docComment.parameters.count, 2)
        docComment.parameters.enumerated().forEach { index, parameter in
            XCTAssertEqual(parameter.name, parameterExpect[index].name)
            XCTAssertEqual(parameter.description, parameterExpect[index].description)
        }

        XCTAssertEqual(docComment.throws.count, 1)
        let `throws` = try XCTUnwrap(docComment.throws.first)
        XCTAssertEqual(`throws`.description, "Any error thrown by `deferred` or `work` (in that order).")

        XCTAssertEqual(docComment.returns.count, 1)
        let returns = try XCTUnwrap(docComment.returns.first)
        XCTAssertEqual(
            returns.description,
            "`true` if a path from `source` to `destination` exists, `false` otherwise."
        )

        let fieldExtensionsExpect = [
            (name: "attention", description: "Special attention is needed for this part."),
            (name: "author", description: "Who is the original author of this code?")
        ]
        XCTAssertEqual(docComment.fieldExtensions.count, 2)
        docComment.fieldExtensions.enumerated().forEach { index, fieldExtension in
            XCTAssertEqual(fieldExtension.name, fieldExtensionsExpect[index].name)
            XCTAssertEqual(fieldExtension.description, fieldExtensionsExpect[index].description)
        }
    }

    // MARK: Trimming tests
    func testTrimTheOptherParameterSyntaxComment() throws {
        let comment = """
        /// - parameter displayName: An optional string to show in build logs and other
        ///   status areas.
        /// - parameter executable: The absolute path to the executable to be invoked.
        /// - parameter arguments: Command-line arguments to be passed to the executable.
        /// - parameter environment: Environment variable assignments visible to the
        ///   executable.
        /// - parameter inputFiles: Files on which the contents of output files may depend.
        ///   Any paths passed as `arguments` should typically be passed here as
        ///   well.
        /// - parameter outputFiles: Files to be generated or updated by the executable.
        ///   Any files recognizable by their extension as source files
        ///   (e.g. `.swift`) are compiled into the target for which this command
        ///   was generated as if in its source directory; other files are treated
        ///   as resources as if explicitly listed in `Package.swift` using
        ///   `.process(...)`.
        """

        let expect = """
        - parameter displayName: An optional string to show in build logs and other
          status areas.
        - parameter executable: The absolute path to the executable to be invoked.
        - parameter arguments: Command-line arguments to be passed to the executable.
        - parameter environment: Environment variable assignments visible to the
          executable.
        - parameter inputFiles: Files on which the contents of output files may depend.
          Any paths passed as `arguments` should typically be passed here as
          well.
        - parameter outputFiles: Files to be generated or updated by the executable.
          Any files recognizable by their extension as source files
          (e.g. `.swift`) are compiled into the target for which this command
          was generated as if in its source directory; other files are treated
          as resources as if explicitly listed in `Package.swift` using
          `.process(...)`.
        """

        XCTAssertEqual(DocumentationComment.trimCommentSyntax(comment), expect)

    }

    func testTrimParameterOnlyComment() throws {
        let comment = """
        /// - parameters:
        ///   - displayName: An optional string to show in build logs and other
        ///     status areas.
        ///   - executable: The absolute path to the executable to be invoked.
        ///   - arguments: Command-line arguments to be passed to the executable.
        ///   - environment: Environment variable assignments visible to the
        ///     executable.
        ///   - inputFiles: Files on which the contents of output files may depend.
        ///     Any paths passed as `arguments` should typically be passed here as
        ///     well.
        ///   - outputFiles: Files to be generated or updated by the executable.
        ///     Any files recognizable by their extension as source files
        ///     (e.g. `.swift`) are compiled into the target for which this command
        ///     was generated as if in its source directory; other files are treated
        ///     as resources as if explicitly listed in `Package.swift` using
        ///     `.process(...)`.
        """

        let expect = """
        - parameters:
          - displayName: An optional string to show in build logs and other
            status areas.
          - executable: The absolute path to the executable to be invoked.
          - arguments: Command-line arguments to be passed to the executable.
          - environment: Environment variable assignments visible to the
            executable.
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

        XCTAssertEqual(DocumentationComment.trimCommentSyntax(comment), expect)

    }

    func testTrimAbstructAndDescriptionComment() throws {
        let comment = """
        /// Returns a command that runs when any of its output files are needed by
        /// the build, but out-of-date.
        ///
        /// An output file is out-of-date if it doesn't exist, or if any input files
        /// have changed since the command was last run.
        """

        let expect = """
        Returns a command that runs when any of its output files are needed by
        the build, but out-of-date.

        An output file is out-of-date if it doesn't exist, or if any input files
        have changed since the command was last run.
        """

        XCTAssertEqual(DocumentationComment.trimCommentSyntax(comment), expect)

    }

    func testTrimAbstructOnlyComment() throws {
        let comment = """
        /// Returns a command that runs when any of its output files are needed by
        /// the build, but out-of-date.
        """

        let expect = """
        Returns a command that runs when any of its output files are needed by
        the build, but out-of-date.
        """

        XCTAssertEqual(DocumentationComment.trimCommentSyntax(comment), expect)

    }

    // swiftlint:disable:next function_body_length
    func testTrimComplexComment() throws {
        let comment = """
        /// Returns a command that runs when any of its output files are needed by
        /// the build, but out-of-date.
        ///
        /// An output file is out-of-date if it doesn't exist, or if any input files
        /// have changed since the command was last run.
        ///
        /// - Note: the paths in the list of output files may depend on the list of
        ///   input file paths, but **must not** depend on reading the contents of
        ///   any input files. Such cases must be handled using a `prebuildCommand`.
        ///
        /// - parameters:
        ///   - displayName: An optional string to show in build logs and other
        ///     status areas.
        ///   - executable: The absolute path to the executable to be invoked.
        ///   - arguments: Command-line arguments to be passed to the executable.
        ///   - environment: Environment variable assignments visible to the
        ///     executable.
        ///   - inputFiles: Files on which the contents of output files may depend.
        ///     Any paths passed as `arguments` should typically be passed here as
        ///     well.
        ///   - outputFiles: Files to be generated or updated by the executable.
        ///     Any files recognizable by their extension as source files
        ///     (e.g. `.swift`) are compiled into the target for which this command
        ///     was generated as if in its source directory; other files are treated
        ///     as resources as if explicitly listed in `Package.swift` using
        ///     `.process(...)`.
        """

        let expect = """
        Returns a command that runs when any of its output files are needed by
        the build, but out-of-date.

        An output file is out-of-date if it doesn't exist, or if any input files
        have changed since the command was last run.

        - Note: the paths in the list of output files may depend on the list of
          input file paths, but **must not** depend on reading the contents of
          any input files. Such cases must be handled using a `prebuildCommand`.

        - parameters:
          - displayName: An optional string to show in build logs and other
            status areas.
          - executable: The absolute path to the executable to be invoked.
          - arguments: Command-line arguments to be passed to the executable.
          - environment: Environment variable assignments visible to the
            executable.
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

        XCTAssertEqual(DocumentationComment.trimCommentSyntax(comment), expect)
    }
}
// swiftlint:enable file_length
