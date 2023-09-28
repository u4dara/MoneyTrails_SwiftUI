//
//  AuthViewModel.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-05.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

protocol AuthenticationFormProtocol {
    var formIsValid : Bool { get }
}

@MainActor
class AuthViewModel : ObservableObject {
    @Published var userSession : FirebaseAuth.User?
    @Published var currentUser : User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // User Login Function
    func signIn(withEmail email : String, password : String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
            await fetchUser()
        }
        catch{
            print("Debug : Failed to login user with error : \(error.localizedDescription)")
        }
    }
    
    // User Creation Function
    func createUser(withEmail email : String, password : String, fullname : String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email)
            
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            await fetchUser()
        }
        catch {
            print("Debug : Failed to create user with error : \(error.localizedDescription)")
        }
    }
    
    // User Logout Function
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }
        catch {
            print("Debug : Faild to Sign out user with error : \(error.localizedDescription)")
        }
    }
    
    // Delete User Account
    func deleteUserAccount() async throws {
        if let user = Auth.auth().currentUser {
            do {
                try await user.delete()
            } catch {
                throw error
            }
        } else {
            throw NSError(domain: "YourAppErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is currently signed in."])
        }
    }

    
    // Fetch login user Function
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        
    }
}
