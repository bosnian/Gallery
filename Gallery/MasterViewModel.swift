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
    
    var selectedId = Observable<Int>(0)
    var filter = Observable<String>("")
    var title = Observable<String>("Title".localized)
    
    
    var postSyncing = Observable<Bool>(false)
    
    var _posts = Observable<[Post]>([Post]())
    var posts = Observable<[Post]>([Post]())
    
    private var networkService: INetworkService?
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(syncData),
                                               name: .UIApplicationDidBecomeActive,
                                               object: nil)
        
        _ = _posts.observeNext { (_) in
            self.filter.value = self.filter.value
        }
        
        _ = filter.observeNext(with: { (keyword) in
            self.posts.value = self._posts.value.filter({ (post) -> Bool in
                return post.title.value.contains(keyword) || keyword.isEmpty
            })
        })
    }
    
    func fetchPosts() {
        _posts.value = DI.resolve(IPostStorageService.self)!.GetAll().map {
            Post(post: $0)
        }
    }
    
    func removePost(id: Int) {
        DI.resolve(IPostStorageService.self)!.Remove(id: id)
        
        _posts.silentUpdate(value: _posts.value.filter({ (post) -> Bool in
            return post.id.value != id
        }))
        
        posts.value = posts.value.filter({ (post) -> Bool in
            return post.id.value != id
        })
    }
    
    @objc func syncData() {
        postSyncing.value = true
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
            self.postSyncing.value = false
        }, error: errorOccured)
    }
    
    private func errorOccured(error: Error?) {
        postSyncing.value = false
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
