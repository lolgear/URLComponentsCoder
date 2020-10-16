import XCTest

import URLComponentsCoderTests

var tests = [XCTestCaseEntry]()
tests += URLComponentsCoderTests.allTests()
tests += DecodingTests.allTests()
tests += EncodingTests.allTests()
XCTMain(tests)
