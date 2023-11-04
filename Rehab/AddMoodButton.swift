//
//  AddMoodButton.swift
//  Rehab1
//
//  Created by Ali, Ali on 19/9/2023.
//

import SwiftUI

struct AddMoodButton: View {

    var body: some View {
        Image(systemName: "plus").resizable().frame(width: 18, height: 18).foregroundColor(.white)
        .padding()
        .background(Color.blue)
        .clipShape(Circle())
    }
}
