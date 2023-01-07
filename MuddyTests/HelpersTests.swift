//
//  HelpersTests.swift
//  MuddyTests
//
//  Created by Bora Erdem on 8.01.2023.
//

@testable import Muddy
import XCTest

final class HelpersTests: XCTestCase {
    
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    func test_getYearFromDate_returnsYearString() {
        let dateString = "2002/10/15"
        let year: String!
        year = getYearFromDate(dateString: dateString)
        
        XCTAssertEqual(year, "2002")
    }
    
    func test_extractQuotedStrings_returnsListFromParagraph() {
        let paragraph = "bora erdem \"çok\" iyi bir \"insandır\""
        let dizi = extractQuotedStrings(from: paragraph)
        
        XCTAssertEqual(dizi, ["çok", "insandır"])
    }
    
    func test_extractStringBetweenParentheses_returnsSentenceFromParagraph() {
        let paragraph = "bu bir test (mesajıdır)"
        let sentence = extractStringBetweenParentheses(from: paragraph)
        
        XCTAssertEqual(sentence, "mesajıdır")
    }
}
