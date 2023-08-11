import XCTest
import AppFeature

final class AppTests: XCTestCase {
  func testExample() throws {
    XCTAssertEqual(5, adition(3, 2))
    XCTAssertNotEqual(6, adition(3, 2))

    XCTAssertEqual(6, adition(4, 2))
  }
}
