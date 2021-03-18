//
//  StorageManager.swift
//  notepad
//
//  Created by Никита on 18.03.2021.
//

import CoreData

class StorageManager {
    
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "notepad")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
    // MARK: - Public Methods
    func fetchData() -> [Note] {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
            
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    // Save data
    func save(_ title: String, _ text: String, completion: (Note) -> Void) {
  
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: persistentContainer.viewContext) else { return }
        let note = NSManagedObject(entity: entityDescription, insertInto: viewContext) as! Note
       note.title = title
        note.text = text
        
        completion(note)
        saveContext()
    }
    
    func edit(_ note: Note, title: String, text: String) {
        note.title = title
        note.text = text
        saveContext()

    }
    
    func delete(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
