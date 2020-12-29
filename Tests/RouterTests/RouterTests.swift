import XCTest
@testable import Router

final class RouterTests: XCTestCase {

    func testContextIsTrue() {
        XCTAssertEqual(Context(pattern: "/", path: "/").isMatch, true)
        XCTAssertEqual(Context(pattern: "/a", path: "/a").isMatch, true)
        XCTAssertEqual(Context(pattern: "/1", path: "/1").isMatch, true)
        XCTAssertEqual(Context(pattern: "/{a}", path: "/a").isMatch, true)
        XCTAssertEqual(Context(pattern: "/{a}", path: "/1").isMatch, true)
        XCTAssertEqual(Context(pattern: "/{a}/{b}", path: "/a/b").isMatch, true)
        XCTAssertEqual(Context(pattern: "/{a}/{b}", path: "/1/2").isMatch, true)
        XCTAssertEqual(Context(pattern: "/a/{a}/b/{b}", path: "/a/a/b/b").isMatch, true)
        XCTAssertEqual(Context(pattern: "/a/{a}/b/{b}", path: "/a/1/b/2").isMatch, true)
    }

    func testContextIsFalse() {
        XCTAssertEqual(Context(pattern: "/", path: "/a").isMatch, false)
        XCTAssertEqual(Context(pattern: "/a", path: "/b").isMatch, false)
        XCTAssertEqual(Context(pattern: "/1", path: "/2").isMatch, false)
        XCTAssertEqual(Context(pattern: "/{a}", path: "/a/a").isMatch, false)
        XCTAssertEqual(Context(pattern: "/{a}", path: "/1/a").isMatch, false)
        XCTAssertEqual(Context(pattern: "/{a}/{b}", path: "/a/b/c").isMatch, false)
        XCTAssertEqual(Context(pattern: "/{a}/{b}", path: "/1/2/3").isMatch, false)
        XCTAssertEqual(Context(pattern: "/a/{a}/b/{b}/c", path: "/a/a/b/b/").isMatch, false)
        XCTAssertEqual(Context(pattern: "/a/{a}/b/{b}/c", path: "/a/1/b/2/").isMatch, false)
        XCTAssertEqual(Context(pattern: "/b/{a}", path: "/a/a").isMatch, false)
        XCTAssertEqual(Context(pattern: "/b/{a}", path: "/a/1").isMatch, false)
    }

    func testContextParameters() {
        XCTAssertEqual(Context(pattern: "/{a}", path: "/a").paramaters["a"], "a")
        XCTAssertEqual(Context(pattern: "/{key}", path: "/a").paramaters["key"], "a")
        XCTAssertEqual(Context(pattern: "/{key}", path: "/1").paramaters["key"], "1")
        XCTAssertEqual(Context(pattern: "/{a}/{b}", path: "/a/b").paramaters["a"], "a")
        XCTAssertEqual(Context(pattern: "/{a}/{b}", path: "/a/b").paramaters["b"], "b")
        XCTAssertEqual(Context(pattern: "/user/{uid}", path: "/user/b").paramaters["uid"], "b")
        XCTAssertEqual(Context(pattern: "/user/{uid}/products/{product_id}", path: "/user/a/products/0").paramaters["uid"], "a")
        XCTAssertEqual(Context(pattern: "/user/{uid}/products/{product_id}", path: "/user/a/products/0").paramaters["product_id"], "0")
    }

    static var allTests = [
        ("testContextIsTrue", testContextIsTrue),
        ("testContextIsFalse", testContextIsFalse),
        ("testContextParameters", testContextParameters)
    ]
}
