//
//  FoodItems+CoreDataProperties.swift
//  foodrink
//
//  Created by jhon on 4/18/24.
//
//

import Foundation
import CoreData


extension FoodItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodItems> {
        return NSFetchRequest<FoodItems>(entityName: "FoodItems")
    }

    @NSManaged public var consumptionDate: Date?
    @NSManaged public var experience: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var name: String?
    @NSManaged public var priority: Int16
    @NSManaged public var recipe: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var tastingnote: String?
    @NSManaged public var whiskyleft: Int16
    @NSManaged public var type: String?
    @NSManaged public var images: NSOrderedSet?

}

// MARK: Generated accessors for images
extension FoodItems {

    @objc(insertObject:inImagesAtIndex:)
    @NSManaged public func insertIntoImages(_ value: ImageContainer, at idx: Int)

    @objc(removeObjectFromImagesAtIndex:)
    @NSManaged public func removeFromImages(at idx: Int)

    @objc(insertImages:atIndexes:)
    @NSManaged public func insertIntoImages(_ values: [ImageContainer], at indexes: NSIndexSet)

    @objc(removeImagesAtIndexes:)
    @NSManaged public func removeFromImages(at indexes: NSIndexSet)

    @objc(replaceObjectInImagesAtIndex:withObject:)
    @NSManaged public func replaceImages(at idx: Int, with value: ImageContainer)

    @objc(replaceImagesAtIndexes:withImages:)
    @NSManaged public func replaceImages(at indexes: NSIndexSet, with values: [ImageContainer])

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageContainer)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageContainer)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSOrderedSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSOrderedSet)

}

extension FoodItems : Identifiable {

}
