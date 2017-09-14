//
//  BaseTestCase.swift
//  Gallery
//
//  Created by Ammar Hadzic on 9/13/17.
//  Copyright © 2017 Ammar Hadzic. All rights reserved.
//

import XCTest
import Swinject
@testable import Gallery

class BaseTestCase: XCTestCase {
    
    var DI = Container()
    
    override func setUp() {
        DI = ServiceUtil.RegisterServicesInMemory(container: DI)
    }
    
    override func tearDown() {
        ServiceUtil.RemoveAll(container: DI)
    }
    
}
