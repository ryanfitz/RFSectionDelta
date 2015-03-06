//
//  RFSectionDeltaTests.swift
//  RFSectionDeltaTests
//
//  Created by Ryan Fitzgerald on 3/5/15.
//  Copyright (c) 2015 ryanfitz. All rights reserved.
//

import UIKit
import XCTest
import RFSectionDelta

class RFSectionDeltaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func assertIndexSetEquals(indexSet : NSIndexSet, expected : [Int]) {
        var indexes = [Int]()
        
        indexSet.enumerateIndexesUsingBlock { (idx, _) in
            indexes.append(idx)
        }
        
        XCTAssertEqual(indexes, expected, "indexsets match")
    }
    
    func testAddItemsWithNilArray() {
        let newArray  = [1,2,3,4]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: nil, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
        
        XCTAssertNotNil(delta.addedIndices, "added indices")
        assertIndexSetEquals(delta.addedIndices!, expected : [0, 1, 2, 3])
    }
    
    func testAddItemsWithEmptyArray() {
        let newArray  = [1,2,3,4]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: [], toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
        
        XCTAssertNotNil(delta.addedIndices, "added indices")
        assertIndexSetEquals(delta.addedIndices!, expected : [0, 1, 2, 3])
    }
    
    func testRemoveAllItems() {
        let oldArray  = [1,2,3,4]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: nil)
        
        XCTAssertNotNil(delta.removedIndices, "removed indices not nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
        XCTAssertNil(delta.addedIndices, "added indices")
        
        assertIndexSetEquals(delta.removedIndices!, expected : [0, 1, 2, 3])
    }
    
    func testRemoveAllItemsWithEmptyArray() {
        let oldArray  = [1,2,3,4]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: [])
        
        XCTAssertNotNil(delta.removedIndices, "removed indices not nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
        XCTAssertNil(delta.addedIndices, "added indices")
        
        assertIndexSetEquals(delta.removedIndices!, expected : [0, 1, 2, 3])
    }
    
    func testAddItemsToExistingArray() {
        let oldArray  = [1,2,3,4]
        let newArray  = [1,2,3,4,5,6]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNotNil(delta.addedIndices, "added indices not nil")
        XCTAssertNotNil(delta.unchangedIndices, "unchanged indices not nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
        
        assertIndexSetEquals(delta.addedIndices!, expected : [4,5])
        assertIndexSetEquals(delta.unchangedIndices!, expected : [0,1,2,3])
    }
    
    func testAddAndRemoveItems() {
        let oldArray  = [1,2,3]
        let newArray  = [1,2,4,5,6]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNotNil(delta.removedIndices, "removed indices not nil")
        XCTAssertNotNil(delta.addedIndices, "added indices not nil")
        XCTAssertNotNil(delta.unchangedIndices, "unchanged indices not nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
        
        assertIndexSetEquals(delta.removedIndices!, expected : [2])
        assertIndexSetEquals(delta.addedIndices!, expected : [2,3,4])
        assertIndexSetEquals(delta.unchangedIndices!, expected : [0,1])
    }
    
    func testAllUnchangedItems() {
        let oldArray  = [1,2,3]
        let newArray  = [1,2,3]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.addedIndices, "added indices nil")
        XCTAssertNotNil(delta.unchangedIndices, "unchanged indices not nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
        
        assertIndexSetEquals(delta.unchangedIndices!, expected : [0,1,2])
    }
    
    func testSwapItems() {
        let oldArray  = [1,2]
        let newArray  = [2,1]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.addedIndices, "added indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes?.count == 2, "moved indices not nil")
        
        let first = MovedIndex(oldIndex: 1, newIndex: 0)
        let sec = MovedIndex(oldIndex: 0, newIndex: 1)
        XCTAssertEqual(delta.movedIndexes!.first!, first, "first moved")
        XCTAssertEqual(delta.movedIndexes![1], sec, "second moved")
    }
    
    func testMoveItemToStart() {
        let oldArray  = [1,2,3]
        let newArray  = [3,1,2]
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.addedIndices, "added indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes?.count == 3, "moved indices not nil")
        
        let first = MovedIndex(oldIndex: 1, newIndex: 2)
        let sec = MovedIndex(oldIndex: 2, newIndex: 0)
        let third = MovedIndex(oldIndex: 0, newIndex: 1)
        
        XCTAssertEqual(delta.movedIndexes!.first!, first, "first moved")
        XCTAssertEqual(delta.movedIndexes![1], sec, "sec moved")
        XCTAssertEqual(delta.movedIndexes![2], third, "third moved")
    }
    
    func testNilHandling() {
        var oldArray : [Int]?
        var newArray : [Int]?
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.addedIndices, "added indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
    }
    
    func testEmptyArraysHandling() {
        var oldArray = [Int]()
        var newArray = [Int]()
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.addedIndices, "added indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
    }
    
    func testEmptyArrayAndNilArrayHandling() {
        var oldArray = [Int]()
        var newArray : [Int]?
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.addedIndices, "added indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
    }
    
    func testNilArrayAndEmptyArrayHandling() {
        var oldArray : [Int]?
        var newArray = [Int]()
        
        let section = RFSectionDelta()
        let delta = section.generateDelta(fromOldArray: oldArray, toNewArray: newArray)
        
        XCTAssertNil(delta.removedIndices, "removed indices nil")
        XCTAssertNil(delta.addedIndices, "added indices nil")
        XCTAssertNil(delta.unchangedIndices, "unchanged indices nil")
        XCTAssert(delta.movedIndexes == nil, "moved indices nil")
    }
}
