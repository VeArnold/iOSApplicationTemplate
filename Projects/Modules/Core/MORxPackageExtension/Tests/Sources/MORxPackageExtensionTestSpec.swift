import Foundation
import XCTest
import RxSwift
import RxRelay
import RxBlocking
import RxTest
import Quick
import Nimble
import RxNimbleRxTest
import RxNimbleRxBlocking
@testable import MORxPackageExtension

final class MORxPackageExtensionTestSpec: QuickSpec {
    override func spec() {
        describe("Given") {
            context("When") {
                it("Then") {
                    expect(1 + 1).to(equal(2))
                    expect(1.2).to(beCloseTo(1.1, within: 0.1))
                    expect(3) > 2
                }
            }
        }
    }
}
