//
//  ApplePodcastCloneUITests.swift
//  ApplePodcastCloneUITests
//
//  Created by Rishabh Dubey on 29/05/21.
//

import XCTest

class ApplePodcastCloneUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func test_MainTapBarLoaded() {
        app.launch()
        XCTAssertTrue(app.isDisplayingTabBar)
    }
}

extension XCUIApplication {
    var isDisplayingTabBar: Bool {
        return otherElements["MainTabBarController"].exists
    }
}
