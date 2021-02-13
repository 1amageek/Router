import XCTest
@testable import Router

final class RouterTests: XCTestCase {

    func testRouteContextIsTrue() {
        XCTAssertEqual(RouteContext(pattern: "/", path: "/").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/a", path: "/a").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/1", path: "/1").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/{a}", path: "/a").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/{a}", path: "/1").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/{a}/{b}", path: "/a/b").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/{a}/{b}", path: "/1/2").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/a/{a}/b/{b}", path: "/a/a/b/b").isMatch, true)
        XCTAssertEqual(RouteContext(pattern: "/a/{a}/b/{b}", path: "/a/1/b/2").isMatch, true)
    }

    func testRouteContextIsFalse() {
        XCTAssertEqual(RouteContext(pattern: "/", path: "/a").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/a", path: "/b").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/1", path: "/2").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/{a}", path: "/a/a").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/{a}", path: "/1/a").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/{a}/{b}", path: "/a/b/c").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/{a}/{b}", path: "/1/2/3").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/a/{a}/b/{b}/c", path: "/a/a/b/b/").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/a/{a}/b/{b}/c", path: "/a/1/b/2/").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/b/{a}", path: "/a/a").isMatch, false)
        XCTAssertEqual(RouteContext(pattern: "/b/{a}", path: "/a/1").isMatch, false)
    }

    func testRouteContextParameters() {
        XCTAssertEqual(RouteContext(pattern: "/{a}", path: "/a").paramaters["a"], "a")
        XCTAssertEqual(RouteContext(pattern: "/{key}", path: "/a").paramaters["key"], "a")
        XCTAssertEqual(RouteContext(pattern: "/{key}", path: "/1").paramaters["key"], "1")
        XCTAssertEqual(RouteContext(pattern: "/{a}/{b}", path: "/a/b").paramaters["a"], "a")
        XCTAssertEqual(RouteContext(pattern: "/{a}/{b}", path: "/a/b").paramaters["b"], "b")
        XCTAssertEqual(RouteContext(pattern: "/user/{uid}", path: "/user/b").paramaters["uid"], "b")
        XCTAssertEqual(RouteContext(pattern: "/user/{uid}/products/{product_id}", path: "/user/a/products/0").paramaters["uid"], "a")
        XCTAssertEqual(RouteContext(pattern: "/user/{uid}/products/{product_id}", path: "/user/a/products/0").paramaters["product_id"], "0")
    }

    static var allTests = [
        ("testRouteContextIsTrue", testRouteContextIsTrue),
        ("testRouteContextIsFalse", testRouteContextIsFalse),
        ("testRouteContextParameters", testRouteContextParameters)
    ]
}
