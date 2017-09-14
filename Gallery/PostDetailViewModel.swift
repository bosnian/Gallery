//
//  PostDetailViewModel.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/13/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit


class PostDetailViewModel {
    
    var id = Observable<Int>(0)
    var title = Observable<String>("")
    var body = Observable<String>("")
    var albumsRepository = MutableObservableArray([Album]())
    
    init() {
        _ = id.observeNext(with: fetch)
    }
    
    func fetch(id: Int) {
        albumsRepository.removeAll()
        let post = DI.resolve(IPostStorageService.self)!.Get(id: id)
        if let post = post {
            title.value = post.title!
            body.value = post.body!
            updateAlbums(model: post)
        } else {
            title.value = ""
            body.value = ""
        }
    }
    
    private func updateAlbums(model: PostModelCD) {
        if let albums = model.user?.albums?.allObjects as? [AlbumModelCD]{
            
            for album in albums {
                let p = getPhotosForAlbum(album: album)
                let a = Album(title: album.title ?? "Album",photos: p)
                albumsRepository.append(a)
            }
        }
    }
    
    private func getPhotosForAlbum(album: AlbumModelCD) -> [Photo] {
        var p = [Photo]()
        if let photos = album.photos?.allObjects as? [PhotoModelCD] {
            for photo in photos {
                if let url = photo.url {
                    p.append(Photo(url: url))
                }
            }
        }
        return p;
    }
    
    class Album {
        var title = Observable<String>("")
        var active = Observable<Bool>(false)
        var photos = Observable<[Photo]>([Photo]())
        
        init(title:String, photos: [Photo]) {
            self.title.value = title
            self.photos.value = photos
        }
    }
    
    class Photo {
        var url: Observable<URL>
        
        init(url: String) {
            self.url = Observable<URL>(URL(string: url)!)
        }
    }
}
