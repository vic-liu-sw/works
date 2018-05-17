//
//  ReachNetwork.swift
//  
//
//  Created by vic_liu on 2018/4/27.
//

import Foundation
import Reachability     // 檢測網路狀態
let reachability = Reachability()!
reachability.whenReachable = { reachability in
    if reachability.connection == .wifi {
        print("Reachable via WiFi")
    } else {
        print("Reachable via Cellular")
    }
}
reachability.whenUnreachable = { _ in
    print("Not reachable")
}

do {
    try reachability.startNotifier()
} catch {
    print("Unable to start notifier")
}

