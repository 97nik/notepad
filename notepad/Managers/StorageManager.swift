//
//  StorageManager.swift
//  notepad
//
//  Created by Никита on 18.03.2021.
//
import UIKit
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
            let test = try viewContext.fetch(fetchRequest)
            if test.count == 0 {
                getDataFromFile()
            }
            return try viewContext.fetch(fetchRequest)
            
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
        
    }
    
    func getDataFromFile()  {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title != nil")
        
        guard let pathToFile = Bundle.main.path(forResource: "data", ofType: "plist"),
              let dataArray = NSArray(contentsOfFile: pathToFile) else {
            
            return }
        
        for dictionary in dataArray {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: persistentContainer.viewContext) else { return }
            let note = NSManagedObject(entity: entityDescription, insertInto: viewContext) as! Note
            let carDictionary = dictionary as! [String : AnyObject]
            note.title = carDictionary["title"] as? String
            note.text = carDictionary["text"] as? String
            
            
            if let imageName = carDictionary["image"] as? String {
                print("image")
                print(imageName)
                let image = UIImage(named: imageName)
                let imageData = image!.pngData()
                note.image = imageData
            } else {
                return
            }
        }
        
    }
    
    // Save data
    func save(_ title: String, _ text: String, _ image: Data?, completion: (Note) -> Void) {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Note", in: persistentContainer.viewContext) else { return }
        let note = NSManagedObject(entity: entityDescription, insertInto: viewContext) as! Note
        note.title = title
        note.text = text
        note.image = image
        
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
