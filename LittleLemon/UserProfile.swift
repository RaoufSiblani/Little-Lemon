//
//  UserProfile.swift
//  LittleLemon
//
//  Created by Carlos Martínez on 04/08/23.
//

import SwiftUI

struct UserProfile: View {
    
    private let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    private let lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    private let email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @Environment(\.presentationMode) var presentation
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Personal information")
                .font(.title)
            Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text("\(firstName) \(lastName)")
                .font(.title3)
            Text(email)
                .font(.headline)
            Button {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                path = NavigationPath(["login"])
            } label: {
                Text("Logout")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(GrowingButton())
        }.padding(.horizontal, 20)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        @State var path = NavigationPath()
        UserProfile(path: $path)
    }
}
