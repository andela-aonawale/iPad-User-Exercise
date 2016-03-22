//
//  iPadUsersTests.swift
//  iPadUsersTests
//
//  Created by Ahmed Onawale on 3/21/16.
//  Copyright © 2016 Ahmed Onawale. All rights reserved.
//

import XCTest
@testable import SHERPANY_Users

class iPadUsersTests: XCTestCase {
    
    var user: User!
    var albums: [Album]!
    var photos: [Photo]!
    
    override func setUp() {
        super.setUp()
        let dict = [
            "id": 1,
            "name": "Leanne Graham",
            "username": "Bret",
            "email": "Sincere@april.biz",
            "address": [
                "street": "Kulas Light",
                "suite": "Apt. 556",
                "city": "Gwenborough",
                "zipcode": "92998-3874",
                "geo": [
                    "lat": "-37.3159",
                    "lng": "81.1496"
                ]
            ],
            "phone": "1-770-736-8031 x56442",
            "website": "hildegard.org",
            "company": [
                "name": "Romaguera-Crona",
                "catchPhrase": "Multi-layered client-server neural-net",
                "bs": "harness real-time e-markets"
            ]
        ]
        let albums = [
            [
                "userId": 1,
                "id": 1,
                "title": "quidem molestiae enim"
            ],
            [
                "userId": 1,
                "id": 2,
                "title": "sunt qui excepturi placeat culpa"
            ]
        ]
        let photos = [
            [
                "albumId": 1,
                "id": 1,
                "title": "accusamus beatae ad facilis cum similique qui sunt",
                "url": "http://placehold.it/600/92c952",
                "thumbnailUrl": "http://placehold.it/150/30ac17"
            ],
            [
                "albumId": 1,
                "id": 2,
                "title": "reprehenderit est deserunt velit ipsam",
                "url": "http://placehold.it/600/771796",
                "thumbnailUrl": "http://placehold.it/150/dff9f6"
            ]
        ]
        let context = PersistenceStack.sharedStack().managedObjectContext
        user = User(dictionary: dict, insertIntoManagedObjectContext: context)
        for i in 0..<albums.count {
            let album = Album(dictionary: albums[i], insertIntoManagedObjectContext: context)
            album.user = user
            let photo = Photo(dictionary: photos[i], insertIntoManagedObjectContext: context)
            photo.album = album
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        user = nil
        albums = nil
        photos = nil
    }
    
    func testUser() {
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, 1)
        XCTAssertEqual(user.name, "Leanne Graham")
        XCTAssertNotNil(user.address)
        XCTAssertNotNil(user.company)
        XCTAssertNotNil(user.address.geoLocation)
    }
    
    func testAlbumRelationship() {
        XCTAssertEqual(user.albums.count, 2)
        user.albums.forEach { XCTAssertEqual($0.user, user) }
    }
    
    func testPhotoRelationship() {
        XCTAssertEqual(user.albums.first?.photos.count, 1)
        XCTAssertEqual(user.albums.last?.photos.count, 1)
        let album = user.albums.first
        let photo = album?.photos.first
        XCTAssertEqual(photo?.album, album)
    }
    
}
