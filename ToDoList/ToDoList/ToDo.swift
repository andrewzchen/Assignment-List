//
//  ToDo.swift
//  ToDoList
//
//  Created by Andrew Chen on 7/23/19.
//  Copyright © 2019 Andrew Chen. All rights reserved.
//

import Foundation

struct ToDo: Codable {
    
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
    
    static func loadAll() -> [ToDo]? {
        guard let codedList = try? Data(contentsOf: ArchiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self , from: codedList)
    }
    
    static func saveAll(_ todoList: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedList = try? propertyListEncoder.encode(todoList)
        try? codedList?.write(to: ArchiveURL, options: .noFileProtection)
    }
    var title: String
    var dueDate: Date
    var isComplete: Bool
    var classType: className// use Enum
    var notes: String?

    
    static func sampleList() -> [ToDo] {
        let item1 = ToDo(title: "Coding 1", dueDate: Date(), isComplete: false, classType: className.ITP303, notes: "Notes 1")
        let item2 = ToDo(title: "Essay 1", dueDate: Date(), isComplete: true, classType: className.CTWR211, notes: "Notes 2")
        let item3 = ToDo(title: "Coding 2", dueDate: Date(), isComplete: false, classType: className.CS270, notes: "Notes 3")
        let todoList = [item1, item2, item3]

        return todoList
    }
    // DateFormatter objects are time-consuming to create: just create one and use it throughout program
    static let duoDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter;
    }()
}

enum className{
    
    case CS270
    case ITP303
    case CS356
    case CTWR211
}

extension className: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    enum CodingError: Error {
        case unknownValue
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .CS270
        case 1:
            self = .CS356
        case 2:
            self = .CTWR211
        case 3:
            self = .ITP303
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .CS270:
            try container.encode(0, forKey: .rawValue)
        case .CS356:
            try container.encode(1, forKey: .rawValue)
        case .CTWR211:
            try container.encode(2, forKey: .rawValue)
        case .ITP303:
            try container.encode(3, forKey: .rawValue)
        }
    }
    
}

