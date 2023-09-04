//
//  Dashboard.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-04.
//

import SwiftUI

struct Dashboard: View {
    
    @StateObject var loginVM : LoginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea(.all)

            VStack {
                Text("Text")
                HStack {
                    Image(systemName: "person.circle.fill")
                    TextField("Username", text: $loginVM.name)
                }.padding()
                    .background(
                    RoundedRectangle(cornerRadius: 10).foregroundColor(.white))

            }.padding()
            
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
