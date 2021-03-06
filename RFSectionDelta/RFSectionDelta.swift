//
//  RFSectionDelta.swift
//  RFSectionDelta
//
//  Created by Ryan Fitzgerald on 3/5/15.
//  Copyright (c) 2015 ryanfitz. All rights reserved.
//

public struct MovedIndex: Equatable, CustomStringConvertible {
    public let oldIndex: Int
    public let newIndex: Int

    public init (oldIndex: Int, newIndex: Int) {
        self.oldIndex = oldIndex
        self.newIndex = newIndex
    }

    public var description: String {
        return "oldIndex: \(oldIndex) newIndex: \(newIndex)"
    }
}

public func == (lhs: MovedIndex, rhs: MovedIndex) -> Bool {
    return lhs.oldIndex == rhs.oldIndex && lhs.newIndex == rhs.newIndex
}

public struct RFDelta {
    public let addedIndices: NSIndexSet?
    public let removedIndices: NSIndexSet?
    public let unchangedIndices: NSIndexSet?
    public let movedIndexes: [MovedIndex]?
}

open class RFSectionDelta {

    public init() {

    }

    open func generateDelta<T: Hashable>(fromOldArray oldArray: [T]?, toNewArray newArray: [T]?) -> RFDelta {
        let removeSets = NSMutableIndexSet()
        let insertSets = NSMutableIndexSet()
        let unchangedSets = NSMutableIndexSet()
        var movedIndexes = [MovedIndex]()

        if let oldData = oldArray {
            if let newData = newArray {

                let newItemsSet = indexArray(newData)
                let oldItemSet = indexArray(oldData)

                for (item, newIdx) in newItemsSet {
                    if let oldIdx = oldItemSet[item] {
                        if newIdx == oldIdx {
                            unchangedSets.add(newIdx)
                        } else {
                            movedIndexes.append(MovedIndex(oldIndex: oldIdx, newIndex: newIdx))
                        }
                    } else {
                        insertSets.add(newIdx)
                    }
                }

                for (item, oldIdx) in oldItemSet {
                    if newItemsSet[item] == nil {
                       removeSets.add(oldIdx)
                    }
                }
            } else {
                // new array is nil so remove all
                for (idx, _) in oldData.enumerated() {
                    removeSets.add(idx)
                }
            }
        } else if let newData = newArray {
            for (idx, _) in newData.enumerated() {
                insertSets.add(idx)
            }
        }

        let addedIndices: NSIndexSet? = insertSets.count > 0 ? insertSets : nil
        let removedIndices: NSIndexSet? = (removeSets.count > 0 ? removeSets : nil )
        let unchangedIndices: NSIndexSet? = (unchangedSets.count > 0 ? unchangedSets : nil )
        let movedIndices: [MovedIndex]? = (movedIndexes.count > 0 ? movedIndexes : nil )

        return RFDelta(addedIndices: addedIndices, removedIndices: removedIndices, unchangedIndices: unchangedIndices, movedIndexes: movedIndices)
    }

    fileprivate func indexArray<T: Hashable>(_ array: [T]) -> [Int : Int] {
        var result = [Int : Int]()

        for (idx, item) in array.enumerated() {
            result[item.hashValue] = idx
        }

        return result
    }
}
