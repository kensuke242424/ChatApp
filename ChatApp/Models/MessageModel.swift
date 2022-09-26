//
//  MessageModel.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/09/10.
//

import FirebaseFirestore
import FirebaseFirestoreSwift


struct MessageData: Codable, Identifiable {

    // @DocumentID ⇨ Firestoreドキュメントから構造体にマップするたびに、Firesoreはドキュメントの値を検知マッピングする
    // @ServerTimestamp ⇨ Firestoreデータベースへの書き込み時に現在のサーバーのタイムスタンプをフィールドに入力
    @DocumentID var id: String? = UUID().uuidString
    @ServerTimestamp var createAt: Timestamp?
    let userID: String
    let message: String
    
}
