//
//  CoreDataStack.swift
//  Collection App
//
//  Created by Nathalia do Valle Papst on 28/07/21.
//

import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    private let model: String
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model)
        let defaultURL = NSPersistentContainer.defaultDirectoryURL()
        let sqliteURL = defaultURL.appendingPathComponent("\(self.model).sqlite")
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    private init(model: String = "Collection app") {
        self.model = model
    }
    
    func save() throws {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            }
            
            catch {
                throw CoreDataStackError.failedToSave
            }
        }
        
        else {
            throw CoreDataStackError.contextHasNoChanges
        }
    }
    
    func createCollection(name: String, photo: Data) throws -> Collection {
        let collection = Collection(context: mainContext)
        collection.name = name
        collection.photo = photo
        try save()
        return collection
    }
    
    func createElement(name: String, date: String, place: String, price: String, notes: String, photo: Data, collection: Collection) throws -> Element {
        let element = Element(context: mainContext)
        element.name = name
        element.date = date
        element.place = place
        element.notes = notes
        element.photo = photo
        collection.addToContainElements(element)
        try save()
        return element
    }
    
    func deleteCollection(collection: Collection) throws {
        mainContext.delete(collection)
        try save()
    }
    
    func deleteElement(element: Element) throws {
        mainContext.delete(element)
        try save()
    }
    
}

enum CoreDataStackError: Error {
    case failedToSave
    case contextHasNoChanges
}
