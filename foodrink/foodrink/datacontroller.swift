////
////  datacontroller.swift
////  foodrink
////
////  Created by jhon on 4/15/24.


import SwiftUI
import Foundation
import CoreData


enum SortOrder {
    case date, priority, none
}

extension FoodItems {
    var imagesArray: [ImageContainer] {
        // NSOrderedSet을 [ImageContainer]로 변환
        (images?.array as? [ImageContainer]) ?? []
    }

    var consumptionDateFormatted: String {
        guard let date = consumptionDate else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    var priorityDescription: String {
        "\(priority)"  // 예시에서는 간단한 숫자로 우선순위를 표현합니다.
    }
}


class ItemDataManager: ObservableObject {
    private let container: NSPersistentContainer
    @Published var foods: [FoodItems] = []  // 음식 아이템 배열
    @Published var drinks: [FoodItems] = []  // 음료 아이템 배열

    init() {
        container = NSPersistentContainer(name: "foodrink")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        fetchAllItems()
    }
    
    func fetchAllItems() {
        fetchFoods()
        fetchDrinks()
    }

    func fetchFoods() {
        let request: NSFetchRequest<FoodItems> = FoodItems.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", "food")
        do {
            foods = try container.viewContext.fetch(request)
        } catch let error as NSError {
            print("Could not fetch foods: \(error), \(error.userInfo)")
        }
    }

    func fetchDrinks() {
        let request: NSFetchRequest<FoodItems> = FoodItems.fetchRequest()
        request.predicate = NSPredicate(format: "type == %@", "drink")
        do {
            drinks = try container.viewContext.fetch(request)
        } catch let error as NSError {
            print("Could not fetch drinks: \(error), \(error.userInfo)")
        }
    }
    
    func addFood(name: String, consumptionDate: Date, priority: Int16, recipe: String?, images: [IdentifiableImage], experience: String?) {
        let newFood = FoodItems(context: container.viewContext)
        newFood.name = name
        newFood.consumptionDate = consumptionDate
        newFood.priority = priority
        newFood.recipe = recipe
        newFood.experience = experience
        newFood.type = "food"
        saveImages(images, to: newFood)
        saveContext()
        fetchFoods()
    }

    func addDrink(name: String, consumptionDate: Date, priority: Int16, whiskyleft: Int16, tastingnote: String?, images: [IdentifiableImage], experience: String?) {
        let newDrink = FoodItems(context: container.viewContext)
        newDrink.name = name
        newDrink.consumptionDate = consumptionDate
        newDrink.priority = priority
        newDrink.whiskyleft = whiskyleft
        newDrink.tastingnote = tastingnote
        newDrink.experience = experience
        newDrink.type = "drink"
        saveImages(images, to: newDrink)
        saveContext()
        fetchDrinks()
    }
    
    func saveImages(_ images: [IdentifiableImage], to item: FoodItems) {
        for img in images {
            if let data = img.uiImage.jpegData(compressionQuality: 0.5) {
                let newImage = ImageContainer(context: container.viewContext)
                newImage.content = data
                newImage.food = item
            }
        }
    }
    

    func sortItems(by sortOrder: SortOrder, itemType: String) {
        DispatchQueue.main.async {
            var sortedItems = [FoodItems]()
            
            if itemType == "food" {
                sortedItems = self.foods
            } else if itemType == "drink" {
                sortedItems = self.drinks
            }

            switch sortOrder {
            case .date:
                sortedItems.sort(by: { ($0.consumptionDate ?? Date()) < ($1.consumptionDate ?? Date()) })
            case .priority:
                sortedItems.sort(by: { $0.priority > $1.priority })
            case .none:
                self.fetchAllItems()
                return
            }

            if itemType == "food" {
                self.foods = sortedItems
            } else if itemType == "drink" {
                self.drinks = sortedItems
            }
        }
    }

    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch let error as NSError {
                print("An error occurred while saving: \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteFood(at offsets: IndexSet) {
        for index in offsets {
            let food = foods[index]
            container.viewContext.delete(food)
        }
        saveContext()
        fetchFoods()
    }

    func deleteDrink(at offsets: IndexSet) {
        for index in offsets {
            let drink = drinks[index]
            container.viewContext.delete(drink)
        }
        saveContext()
        fetchDrinks()
    }
}
