//
//  MasterViewModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/12/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import CoreData


class MasterViewModel {
    
    let data = Data()
    
    private var networkService: INetworkService?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncData),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        
        _ = data._posts.observeNext { (_) in
            self.data.filter.value = self.data.filter.value
        }
        
        _ = data.filter.observeNext(with: { (keyword) in
            self.data.posts.value = self.data._posts.value.filter({ (post) -> Bool in
                return post.title.value.contains(keyword) || keyword.isEmpty
            })
        })
    }
    
    func fetchPosts() {
        data._posts.value = DI.resolve(IPostStorageService.self)!.GetAll().map {
            Post(post: $0)
        }
    }
    
    func removePost(id: Int) {
        DI.resolve(IPostStorageService.self)!.Remove(id: id)
        
        data._posts.silentUpdate(value: data._posts.value.filter({ (post) -> Bool in
            return post.id.value != id
        }))
        
        data.posts.value = data.posts.value.filter({ (post) -> Bool in
            return post.id.value != id
        })
    }
    
    @objc func syncData() {
        data.postSyncing.value = true
        networkService = DI.resolve(INetworkService.self)!
        syncUsers()
    }
    
    private func syncUsers() {
        networkService?.FetchAllUsers(success: { (users) in
            let storage = DI.resolve(IUserStorageService.self)!
            storage.Sync(users: users)
            self.syncPosts()
        }, error: errorOccured)
    }
    
    private func syncPosts() {
        networkService?.FetchAllPosts(success: { (posts) in
            let storage = DI.resolve(IPostStorageService.self)!
            storage.Sync(posts: posts)
            self.syncAlbums()
        }, error: errorOccured)
    }
    
    private func syncAlbums() {
        networkService?.FetchAllAlbums(success: { (albums) in
            let storage = DI.resolve(IAlbumStorageService.self)!
            storage.Sync(albums: albums)
            self.syncPhotos()
        }, error: errorOccured)
    }
    
    private func syncPhotos() {
        networkService?.FetchAllPhotos(success: { (photos) in
            let storage = DI.resolve(IPhotoStorageService.self)!
            storage.Sync(photos: photos)
            self.fetchPosts()
            self.data.postSyncing.value = false
        }, error: errorOccured)
    }
    
    private func errorOccured(error: Error?) {
        data.postSyncing.value = false
    }
    
    class Post {
        var id : Observable<Int>
        var title: Observable<String>
        var email: Observable<String>
        
        init(post: PostModelCD) {
            id = Observable<Int>(Int(post.id))
            title = Observable<String>(post.title ?? "")
            email = Observable<String>(post.user?.email ?? "")
        }
    }
    
    class Data {
        var selectedId = Observable<Int>(0)
        var filter = Observable<String>("")
        var title = Observable<String>("Title".localized)
        
        
        var postSyncing = Observable<Bool>(false)
        
        var _posts = Observable<[Post]>([Post]())
        var posts = Observable<[Post]>([Post]())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
