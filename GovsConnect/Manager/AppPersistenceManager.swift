//
//  AppPersistenceManager.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/14.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import Foundation
import CoreData

class AppPersistenceManager{
    enum SavedEntity: String{
        case setting = "Setting"
        case imageData = "ImageData"
        case profileImageData = "ProfileImageData"
        case post = "Post"
        case comment = "Comment"
        case event = "Event"
    }
    public static let shared = AppPersistenceManager()
    var context: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GovsConnect")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init(){
        self.context = self.persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveObject(to entityName: SavedEntity, with items: Array<Any>){
        let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: self.context)
        let manager = NSManagedObject(entity: entity!, insertInto: self.context)
        switch entityName{
        case .setting:
            assert(items.count == 2)
            manager.setValue(items[0] as! String, forKey: "key")
            manager.setValue(items[1] as! String, forKey: "value")
        case .imageData, .profileImageData:
            assert(items.count == 2)
            manager.setValue(items[0] as! String, forKey: "key")
            manager.setValue(items[1] as! Data, forKey: "data")
        case .post:
            assert(items.count == 13)
            manager.setValue("\(items[0])", forKey: "author_uid")
            manager.setValue(items[1] as! Bool, forKey: "is_hide")
            manager.setValue("\(items[2])", forKey: "title")
            manager.setValue("\(items[3])", forKey: "content")
            manager.setValue(items[4] as! NSDate, forKey: "post_time")
            manager.setValue("\(items[5])", forKey: "post_image_url")
            manager.setValue(items[6] as! Bool, forKey: "is_liked")
            manager.setValue(items[7] as! Int16, forKey: "post_like_count")
            manager.setValue(items[8] as! Bool, forKey: "is_viewed")
            manager.setValue(items[9] as! Int16, forKey: "post_view_count")
            manager.setValue(items[10] as! Int16, forKey: "post_comment_count")
            manager.setValue("\(items[11])", forKey: "id")
            manager.setValue("\(items[12])", forKey: "comment_by_id")
        case .comment:
            assert(items.count == 6)
            manager.setValue("\(items[0])", forKey: "id")
            manager.setValue("\(items[1])", forKey: "sender_uid")
            manager.setValue("\(items[2])", forKey: "receiver_uid")
            manager.setValue("\(items[3])", forKey: "body")
            manager.setValue(Int16(items[4] as! Int), forKey: "like_count")
            manager.setValue(items[5] as! Bool, forKey: "is_liked")
        case .event:
            assert(items.count == 5)
            manager.setValue(items[0] as! NSDate, forKey: "startTime")
            manager.setValue(items[1] as! NSDate, forKey: "endTime")
            manager.setValue("\(items[2])", forKey: "title")
            manager.setValue("\(items[3])", forKey: "detail")
            manager.setValue(Int16(items[4] as! Int), forKey: "notificationState")
        }
        try! self.context.save()
    }
    
    func fetchObject(with entityName: SavedEntity) -> Array<Any>{
        switch entityName{
        case .setting:
            let items = try! self.context.fetch(Setting.fetchRequest())
            return items
        case .imageData:
            let items = try! self.context.fetch(ImageData.fetchRequest())
            return items
        case .profileImageData:
            let items = try! self.context.fetch(ProfileImageData.fetchRequest())
            return items
        case .post:
            let items = try! self.context.fetch(Post.fetchRequest())
            return items
        case .comment:
            let items = try! self.context.fetch(Comment.fetchRequest())
            return items
        case .event:
            let items = try! self.context.fetch(Event.fetchRequest())
            return items
        }
    }
    
    func filterObject(of entityName: SavedEntity, with predicate: NSPredicate) -> Array<Any>?{
        switch entityName{
        case .setting:
            let fetchRequest: NSFetchRequest<Setting> = Setting.fetchRequest()
            fetchRequest.predicate = predicate
            let res = try? self.context.fetch(fetchRequest)
            return res
        case .imageData:
            let fetchRequest: NSFetchRequest<ImageData> = ImageData.fetchRequest()
            fetchRequest.predicate = predicate
            let res = try? self.context.fetch(fetchRequest)
            return res
        case .profileImageData:
            let fetchRequest: NSFetchRequest<ProfileImageData> = ProfileImageData.fetchRequest()
            fetchRequest.predicate = predicate
            let res = try? self.context.fetch(fetchRequest)
            return res
        case .post:
            let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
            fetchRequest.predicate = predicate
            let res = try? self.context.fetch(fetchRequest)
            return res
        case .comment:
            let fetchRequest: NSFetchRequest<Comment> = Comment.fetchRequest()
            fetchRequest.predicate = predicate
            let res = try? self.context.fetch(fetchRequest)
            return res
        case .event:
            let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
            fetchRequest.predicate = predicate
            let res = try? self.context.fetch(fetchRequest)
            return res
        }
    }
    
    func updateObject(of entityName: SavedEntity, with predicate: NSPredicate, newVal: Any, forKey: Any) -> Bool{
        switch entityName{
        case .setting:
            let r = self.filterObject(of: entityName, with: predicate)
            if r != nil && r!.count != 0{
                let reses = r as! Array<Setting>
                //这里只能是value, 所以forkey就不switch了
                let newV = newVal as! String
                for res in reses{
                    res.value = newV
                }
                try! self.context.save()
                return true
            }
            return false
        case .imageData:
            let r = self.filterObject(of: entityName, with: predicate)
            if r != nil && r!.count != 0{
                let reses = r as! Array<ImageData>
                //这里只能是data, 所以forkey就不switch了
                let newV = newVal as! Data
                for res in reses{
                    res.data = NSData(data: newV)
                }
                try! self.context.save()
                return true
            }
            return false
        case .profileImageData:
            let r = self.filterObject(of: entityName, with: predicate)
            if r != nil && r!.count != 0{
                let reses = r as! Array<ProfileImageData>
                //这里只能是data, 所以forkey就不switch了
                let newV = newVal as! Data
                for res in reses{
                    res.data = NSData(data: newV)
                }
                try! self.context.save()
                return true
            }
            return false
        case .post:
            fatalError("update not supported for post")
        case .comment:
            fatalError("update not supported for comment")
        case .event:
            fatalError("update not supported for event")
        }
    }
    
    func deleteObject(of entityName: SavedEntity, with item: Any){
        switch entityName{
        case .setting:
            self.context.delete(item as! Setting)
            try! self.context.save()
        case .imageData:
            self.context.delete(item as! ImageData)
            try! self.context.save()
        case .profileImageData:
            self.context.delete(item as! ProfileImageData)
            try! self.context.save()
        case .post:
            self.context.delete(item as! Post)
            try! self.context.save()
        case .comment:
            self.context.delete(item as! Comment)
            try! self.context.save()
        case .event:
            self.context.delete(item as! Event)
            try! self.context.save()
        }
    }
}
