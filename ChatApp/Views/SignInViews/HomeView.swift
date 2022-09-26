//
//  ContentView.swift
//  ChatApp
//
//  Created by 中川賢亮 on 2022/08/17.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var userSignManeger = UserSignManeger()
    @State private var isShowSheet = false

    var body: some View {
        NavigationView {

            VStack {

                // ログアウト状態の場合
                if userSignManeger.signInState == false {

                    Button {
                        isShowSheet.toggle()
                    } label: {
                        Text("Sign-In")
                    }

                    // ログイン状態の場合
                } else {
                    // UserListView ⇨ ログインが完了したらユーザーリストをホーム画面に表示
                    UserListView()

                } // if (ログイン状態分岐)
            } // VStack

            .sheet(isPresented: $isShowSheet) {
                FirebaseUIView()
            }
            // ⬇︎のModifierはiOS14から使えるようになっており、
            // これまでの.navigationBarTitle()はDeprecated（非推奨）
            .navigationTitle("Chat APP")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {

                    Button {
                        userSignManeger.signOut()
                    } label: {
                        if userSignManeger.signInState == true {
                            Text("Sign Out")
                        }
                    } // Button(Sign-Out)
                } // ToolBarItem
            } // .toolBar ここまで
        } // NavigationView
    } // body
} // View

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
