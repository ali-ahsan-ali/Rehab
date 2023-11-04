//
//  AddMoodPage.swift
//  Rehab1
//
//  Created by Ali, Ali on 19/9/2023.
//

import SwiftUI

struct AddMoodPage: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var controller: MoodModelController
    let date: Date
    @State var mood: Mood = Mood(emotion: Emotion(state: .neutral), date: Date())

    @State var cryingTap = false
    @State var sadTap = false
    @State var neutralTap = false
    @State var happyTap = false
    @FocusState private var isFocussed: Bool

    init(controller: MoodModelController, date: Date) {
        self.controller = controller
        self.date = date

        if controller.getMood(date: date) == nil {
            controller.createMood(emotion: Emotion(state: .neutral), comment: "", date: date)
        }
        if let mood = controller.getMood(date: date){
            _mood = State(initialValue: mood)
        }

        switch mood.emotion.state {
        case .bad:
            _cryingTap = State(initialValue: true)
        case .painNoImprovement:
            _sadTap = State(initialValue: true)
        case .neutral:
            _neutralTap = State(initialValue: true)
        case .good:
            _happyTap = State(initialValue: true)

        }
    }

    var body: some View {
        NavigationStack {
            ZStack (alignment: .top){
                VStack{
                    HStack{
                        Image("crying")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(cryingTap ? Color(hex: "#FF0000").clipShape(Circle()).padding(2) : nil)
                            .onTapGesture {
                                cryingTap.toggle()
                                sadTap = false
                                neutralTap = false
                                happyTap = false
                            }
                        Spacer()
                            .frame(width: 30)

                        Image("sad")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(sadTap ? Color(hex: "#ffa001").clipShape(Circle()).padding(2) : nil)
                            .onTapGesture {
                                sadTap.toggle()
                                cryingTap = false
                                neutralTap = false
                                happyTap = false
                            }
                        Spacer()
                            .frame(width: 30)

                        Image("neutral")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(neutralTap ? Color.gray.clipShape(Circle()).padding(2) : nil)
                            .onTapGesture {
                                neutralTap.toggle()
                                cryingTap = false
                                sadTap = false
                                happyTap = false
                            }
                        Spacer()
                            .frame(width: 30)

                        Image("happy")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(happyTap ? Color(hex: "#76dd78").clipShape(Circle()).padding(2) : nil)
                            .onTapGesture {
                                happyTap.toggle()
                                cryingTap = false
                                sadTap = false
                                neutralTap = false
                            }
                    }
                    .padding()
                    VStack (alignment: .leading){
                        Text("Comments:")
                        VStack{
                            TextEditor(text: $mood.comment)
                                .focused($isFocussed)
                                .scrollContentBackground(.hidden)
                                .background(Color(hex: "ADD8E6"))
                                .padding()
                        }.overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color("royalBlue"), lineWidth:2)
                        ).toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button("Done") {
                                    isFocussed = false
                                }


                            }
                        }
                    }.padding()
                    Button("Add") {
                        var mappedEmotion: Emotion = .init(state: .neutral)
                        if cryingTap {
                            mappedEmotion = Emotion(state: .bad)
                        }
                        if sadTap {
                            mappedEmotion = Emotion(state: .painNoImprovement)
                        }
                        if neutralTap {
                            mappedEmotion = Emotion(state: .neutral)
                        }
                        if happyTap {
                            mappedEmotion = Emotion(state: .good)
                        }
                        controller.updateMoodComment(comment: mood.comment, emotion: mappedEmotion, date: date)
                        dismiss()
                    }.buttonStyle(.borderedProminent)
                    Spacer()

                }
                .background(Color(hex: "ADD8E6"))
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Mood")
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        VStack (alignment: .leading) {
                            Image("close")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddMoodPage_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodPage(controller: MoodModelController(), date: Date())
    }
}
