//
//  HeaderViewUITests.swift
//  EntainDemoApp
//
//  Created by Adam Ware on 11/11/2024.
//

import XCTest
@testable import EntainDemoApp

// Example UI test
class HeaderViewUITests: XCTestCase {

    override func setUpWithError() throws {
        // Continue after failure to see all test results
        continueAfterFailure = false

        // Launch the application
        let app = XCUIApplication()
        app.launch()
    }

    func testHeaderViewElementsExist() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Check that the header view label exists
        let headerTitle = app.staticTexts["Entain Demo App"]
        XCTAssertTrue(headerTitle.exists, "The title text is not displayed.")
    }
}
