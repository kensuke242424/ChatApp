//
//  UserModel.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/09/10.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserData: Codable, Identifiable {

    @DocumentID var id = UUID().uuidString
    var name: String
    var userID: String
    var photoURL: String
}
