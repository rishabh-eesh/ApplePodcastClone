//
//  SearchPodcastsUITest.swift
//  ApplePodcastCloneUITests
//
//  Created by Rishabh Dubey on 03/06/21.
//

import XCTest

class SearchPodcastsUITest: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
    }
    
    func test_SearchBar_textCheck() {
        app.launch()
        let searchBar = app.navigationBars["Search"].searchFields["Search"]
        
        XCTAssert(searchBar.exists)
        
        let textToType = "Garyvee"
                
        searchBar.tap()
        searchBar.typeText(textToType)
        
        searchBar.buttons["Clear text"].tap()
    }
    
    func test_Podcast_TableView() {
        app.launch()
        
        
        let searchBar = app.navigationBars["Search"].searchFields["Search"]
        
        XCTAssert(searchBar.exists)
        
        let textToType = "Gary Vaynerchuk"
                
        searchBar.tap()
        searchBar.typeText(textToType)

        let table = app.tables["PodcastSearchTable"]
        
        XCTAssertTrue(table.exists)
        
        let cell = table.cells.element(boundBy: 0)
        cell.tap()
        
        app.navigationBars.buttons["Cancel"].tap()
        
//        while !cell.exists {
//            app.swipeUp()
//        }
        let lastCell = table.cells.element(boundBy: table.cells.count - 1)
        table.scrollToElement(element: lastCell)
    }
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }

    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
