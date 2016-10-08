//
//  SegmentedControlTests.swift
//  NXTSegmentedControl
//
//  Created by Patrick Mick on 10/8/16.
//  Copyright © 2016 Patrick Mick. All rights reserved.
//

import XCTest
@testable import NXTSegmentedControl

class SegmentedControlTests: XCTestCase {
    func testCreationWithItems() {
        let sut = SegmentedControl(items: ["test"])
    }
    
    func testCreationSettingItemsAfter() {
        let sut = SegmentedControl()
        sut.items = ["test"]
    }
    
    func testGettingAnItemWithNoItemsReturnsNil() {
        let sut = SegmentedControl()
        XCTAssertNil(sut.titleForSegment(atIndex:0))
    }
}
