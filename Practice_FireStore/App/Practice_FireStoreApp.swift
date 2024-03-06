//
//  Practice_FireStoreApp.swift
//  Practice_FireStore
//
//  Created by 유지호 on 3/6/24.
//

import SwiftUI
import FirebaseCore

@main
struct Practice_FireStoreApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
