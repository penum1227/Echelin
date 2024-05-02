//
//  ImageContainer+CoreDataProperties.swift
//  foodrink
//
//  Created by jhon on 4/17/24.
//
//

import Foundation
import CoreData


extension ImageContainer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageContainer> {
        return NSFetchRequest<ImageContainer>(entityName: "ImageContainer")
    }

    @NSManaged public var content: Data?
    @NSManaged public var title: String?
    @NSManaged public var food: FoodItems?

}

extension ImageContainer : Identifiable {

}
