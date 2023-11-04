//
//  CalenderView.swift
//  Rehab1
//
//  Created by Ali, Ali on 18/9/2023.
//

import ElegantCalendar
import SwiftUI

struct ExampleCalendarView: View {

    @ObservedObject private var calendarManager: ElegantCalendarManager
    @State private var calendarTheme: CalendarTheme = .royalBlue
    @ObservedObject private var moodController = MoodModelController()

    init() {
        let startDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (-30 * 36)))
        let endDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (30 * 36)))
        let configuration = CalendarConfiguration(
            calendar: Calendar.current,
            startDate: startDate,
            endDate: endDate)

        calendarManager = ElegantCalendarManager(
            configuration: configuration,
            initialMonth: Date())

        calendarManager.datasource = self
        calendarManager.delegate = self
    }

    @State private var showingSheet = false

    var body: some View {
        NavigationView{
            ZStack {
                ElegantCalendarView(calendarManager: calendarManager)
                    .theme(calendarTheme)
                VStack(alignment:.trailing) {
                    Spacer()
                    HStack {
                        Spacer()
                        AddMoodButton()
                            .onTapGesture {
                                if calendarManager.selectedDate == nil {
                                    calendarManager.scrollToDay(Date())
                                }
                                showingSheet.toggle()
                            }
                            .sheet(isPresented: $showingSheet, onDismiss: {
                                calendarManager.monthlyManager.scrollToDay(calendarManager.selectedDate ?? Date())
                            }, content: {
                                if let date = calendarManager.selectedDate {
                                    AddMoodPage(controller: moodController, date: date)
                                }
                            })
                        .padding(30)
                    }
                }

            }
        }
    }
}

extension ExampleCalendarView: ElegantCalendarDataSource {

    func calendar(backgroundColorForDate date: Date) -> Color {
        guard let mood = moodController.getMood(date: date) else { return Color(hex: "cfcfc4") }
        return mood.emotion.moodColor
    }

    func calendar(viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        guard let mood = moodController.getMood(date: date) else { return AnyView(EmptyView())}
        return DayDescriptionView(text: mood.comment).erased
    }

}

extension ExampleCalendarView: ElegantCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
    }

    func calendar(willDisplayMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }

}

struct ExampleCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleCalendarView()
    }
}

struct DayDescriptionView: View {
    let text: String

    var body: some View {
        Text(text)
    }
}
