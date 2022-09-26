//
//  UserListView.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/09/03.
//

import SwiftUI

struct UserListView: View {

    @StateObject private var userListVM = UserListViewModel()

    var body: some View {

        // ログインユーザ自身のuidを取得
        let fromUID = userListVM.logInUserData.uid

        List(userListVM.userDataList) { user in

                // ループ参照データからユーザのuid取得
                // 自身のuid情報はUserListViewModel内で予め除外されるため、必ず相手のuidが格納される
                let toUID = user.userID

            NavigationLink {

                // MessageViewへの遷移時に自身と相手のuidを渡す
                MessageView(fromUID: fromUID, toUID: toUID)

            } label: {

                HStack {

                    // PhotoURLがisEmptyだった場合、SF Symbolを代用して表示
                    if user.photoURL.isEmpty {

                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 30, height: 30)

                    } else {
                        // 画像を非同期にロードして表示する
                        // 画像取得までの間ProgressView()を表示
                        AsyncImage(url: URL(string: "\(user.photoURL)")) { image in

                            image.resizable()

                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 30, height: 30)
                    }

                    Text(user.name)

                } // HStack
            } // NavigationLink(リスト一要素ここまで)
        } // List

        .onAppear {
            // NavigationLinkを使った画面遷移の場合は、親画面へ戻る時に親画面の再描画が走り、
            // このタイミングでonAppearが呼ばれる(モーダル遷移(sheet)時には呼ばれない)
            // 親Viewに戻るたびにfetchしてしまうのを防ぐため、if分岐
            if userListVM.userDataList.isEmpty {

                userListVM.fetchUserList()

            } // if
        } // onAppear

    } // body
} // View

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
