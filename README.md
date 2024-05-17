# DocumentationComment

An Entity to extract Swift documentation comment.

## Installation

### Swift Package Manager

Just add to your Package.swift under dependencies

```swift
let package = Package(
    name: "MyPackage",
    products: [...],
    targets: [
        .target(
            "YouAppModule",
            dependencies: [
                .product(name: "DocumentationComment", package: "DocumentationComment")
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/fumito-ito/DocumentationComment.git", .upToNextMajor(from: "0.0.2"))
    ]
)
```

## Usage

You can generate a `DocumentationComment` object by passing Swift's Annotation Comment as a string.

```swift
let annotationComment = """
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

let doc = try DocumentationComment(annotationComment)
```

`DocumentationComment` extracts a summary, arguments, etc. from the comment.

```swift
print(doc.abstract?.stringify) // => Returns a command that runs unconditionally before every build.
print(doc.parameters.first?.name) // => executable
print(doc.parameters.first?.description) // => The absolute path to the executable to be invoked.
```

Block Comment format comments can also be handled.

```swift
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

 \```
 let sampleText = "This is sample text"
 \```

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

let doc = try DocumentationComment(blockComment)
```

### Supported fields

#### Abstract

Extract the string corresponding to the first paragraph of the comment as a summary of that comment.

#### Description

Extracts the second and subsequent paragraphs as comment details.

#### [Parameter](https://github.com/apple/swift/blob/main/docs/DocumentationComments.md#parameters)

Extract parameter names and their details from the `Parameters` section or `Parameter` field.

##### Parameters section

```markdown
- Parameters:
  - x: ...
  - y: ...
  - z: ...
```

##### Parameter field

```markdown
- Parameter x: ...
- Parameter y: ...
```

#### [Throws](https://github.com/apple/swift/blob/main/docs/DocumentationComments.md#throwing-functions)

Extract its details from the `Throws` field.

```markdown
- Throws: ...
```

#### [Returns](https://github.com/apple/swift/blob/main/docs/DocumentationComments.md#returns-field)

Extract its details from the `Returns` field.

```markdown
- Returns: ...
```

#### [FieldExtension](https://github.com/apple/swift/blob/main/docs/DocumentationComments.md#field-extensions)

Extract its name and details from the Field Extensions field highlighted in Xcode's QuickHelp.

```markdown
- Attention: ...
- Author: ...
- Authors: ...
- Bug: ...
- Complexity: ...
- Copyright: ...
- Date: ...
- Experiment: ...
- Important: ...
- Invariant: ...
- Note: ...
- Postcondition: ...
- Precondition: ...
- Remark: ...
- Remarks: ...
- Requires: ...
- See: ...
- Since: ...
- Todo: ...
- Version: ...
- Warning: ...
```
