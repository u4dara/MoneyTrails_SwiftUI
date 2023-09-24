//
//  MoneyTrails_SwiftUIApp.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-03.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MoneyTrails_SwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var viewModel = AuthViewModel()
    @StateObject var categoryViewModel = CategoryViewModel()
    @StateObject var addExpenseViewModel = AddExpenseViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(categoryViewModel)
                .environmentObject(addExpenseViewModel)
                
        }
    }
}
