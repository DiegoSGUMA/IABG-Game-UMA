//
//  IABG_Game_UMAUITestsLaunchTests.swift
//  IABG Game UMAUITests
//
//  Created by Diego Sánchez on 9/9/24.
//

import XCTest

final class IABG_Game_UMAUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
