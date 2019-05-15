//
//  CoreDemo.swift
//  CoreDemo
//
//  Created by Cristian on 4/14/19.
//  Copyright © 2019 Cristian Palomino. All rights reserved.
//

import Foundation

public class CoreDemo {
    
    private static var _shared: CoreDemo = {
        let coreDemo = CoreDemo()
        return coreDemo
    }()
    
    private init() { }
    
    public class func shared() -> CoreDemo {
        return _shared
    }
    
    public internal(set) var session: Session = Session()
    public internal(set) var services: Services = Services()
}

public class Session {
    
    public var isLoggedIn: Bool = false
    
    public init() { }
    
}
