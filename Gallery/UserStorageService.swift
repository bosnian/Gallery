//
//  UserStorageService.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import CoreData

class UserStorageService: DataStorageService, IUserStorageService {
    
    func GetAll() -> [UsersModelCD] {
        
        let request = NSFetchRequest<UsersModelCD>(entityName: "UsersModelCD")
        
        do {
            return try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return [UsersModelCD]();
    }
    
    func Get(id: Int) -> UsersModelCD? {
        let request = NSFetchRequest<UsersModelCD>(entityName: "UsersModelCD")
        request.predicate = NSPredicate(format: "id = \(id)")
        
        do {
            let users = try context.fetch(request)
            if let user = users.first {
                return user
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return nil
    }
    
    func Sync(users: [UserModel]) {
        
        let entity = NSEntityDescription.entity(forEntityName: "UsersModelCD", in: context)!
        let addressEntity = NSEntityDescription.entity(forEntityName: "AddressModelCD", in: context)!
        let geoEntity = NSEntityDescription.entity(forEntityName: "GeoCoModelCD", in: context)!
        let companyEntity = NSEntityDescription.entity(forEntityName: "CompanyModelCD", in: context)!
        
        var savedUsers = GetAll()
        
        
        for user in users {
            
            var u: UsersModelCD?
            
            //Check if exists
            u = savedUsers.first(where: {
                m in
                if m.id == Int64(user.id!){
                    return true
                }
                return false
            })
            
            if let u = u {
                savedUsers.remove(at: savedUsers.index(of: u)!)
            } else {
                u = UsersModelCD(entity: entity, insertInto: context) //Create new one if does not exits
                u?.address = AddressModelCD(entity: addressEntity, insertInto: context)
                u?.address?.geo = GeoCoModelCD(entity: geoEntity, insertInto: context)
                u?.company = CompanyModelCD(entity: companyEntity, insertInto: context)
            }
            
            u?.id = Int64(user.id!)
            u?.name = user.name
            u?.phone = user.phone
            u?.username = user.username
            u?.website = user.website
            u?.email = user.email
            u?.address?.city = user.address?.city
            u?.address?.suite = user.address?.suite
            u?.address?.street = user.address?.street
            u?.address?.zipcode = user.address?.zipcode
            u?.address?.geo?.lat = user.address?.geo?.lat
            u?.address?.geo?.lng = user.address?.geo?.lng
            u?.company?.name = user.company?.name
            u?.company?.catchPhrase = user.company?.catchPhrase
            u?.company?.bs = user.company?.bs
        }
        
        //Remove objects that were not updated
        for su in savedUsers {
            context.delete(su)
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
