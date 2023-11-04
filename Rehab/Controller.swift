//
//  Controller.swift
//  Rehab1
//
//  Created by Ali, Ali on 18/9/2023.
//

import ElegantCalendar
import SwiftUI

class MoodModelController: ElegantCalendarDataSource, ObservableObject {

    //MARK: - Properties
    @Published var moods: [Date: Mood] = [:]

    init() {
        loadFromPersistentStore()
    }


    //MARK: - CRUD Functions
    func createMood(emotion: Emotion, comment: String, date: Date) {
        for mood in moods where Calendar.current.isDate(date, equalTo: mood.key, toGranularity: .day) {
            updateMoodComment(comment: comment, emotion: emotion, date: mood.key)
            return
        }
        let newMood = Mood(emotion: emotion, comment: comment, date: date)
        moods[date] = newMood
        saveToPersistentStore()
    }

    func getMood(date: Date) -> Mood? {
        for mood in moods where Calendar.current.isDate(date, equalTo: mood.key, toGranularity: .day) {
            return mood.value
        }
        return nil
    }

    func deleteMood(at date: Date) {
        if moods.removeValue(forKey: date) != nil {
            return
        }

        var dateToRemove: Date?
        for mood in moods where Calendar.current.isDate(date, equalTo: mood.key, toGranularity: .day) {
            dateToRemove = mood.key
        }
        if let dateToRemove {
            moods.removeValue(forKey: dateToRemove)
            saveToPersistentStore()
        }
    }


    func updateMoodComment(comment: String, emotion: Emotion, date: Date) {
        guard var updatedMood = getMood(date: date) else { return }
        updatedMood.comment = comment
        updatedMood.emotion = emotion
        moods[updatedMood.date] = updatedMood
        saveToPersistentStore()
    }

    // MARK: Save, Load from Persistent
    private var persistentFileURL: URL? {
      let fileManager = FileManager.default
      guard let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return nil }

      return documents.appendingPathComponent("mood.plist")
    }

    func saveToPersistentStore() {

        // Stars -> Data -> Plist
        guard let url = persistentFileURL else { return }

        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(moods)
            try data.write(to: url)
        } catch {
            print("Error saving stars data: \(error)")
        }
    }

    func loadFromPersistentStore() {

        // Plist -> Data -> Stars
        let fileManager = FileManager.default
        guard let url = persistentFileURL, fileManager.fileExists(atPath: url.path) else { return }

        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            moods = try decoder.decode([Date: Mood].self, from: data)
        } catch {
            print("error loading stars data: \(error)")
        }
    }
}
