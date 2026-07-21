// Copyright (c) 2022-present Snowplow Analytics Ltd. All rights reserved.
//
// This program is licensed to you under the Apache License Version 2.0,
// and you may not use this file except in compliance with the Apache License Version 2.0.
// You may obtain a copy of the Apache License Version 2.0 at http://www.apache.org/licenses/LICENSE-2.0.
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the Apache License Version 2.0 is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the Apache License Version 2.0 for the specific language governing permissions and limitations there under.

import XCTest

class MessageNotificationReaderTests: XCTestCase {

    func testReadsRequiredFields() throws {
        let json = """
        {"title": "My Title", "body": "My Body", "trigger": "push"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        XCTAssertEqual(reader.title, "My Title")
        XCTAssertEqual(reader.body, "My Body")
        XCTAssertEqual(reader.trigger, "push")
    }

    func testOptionalFieldsAreNilWhenAbsent() throws {
        let json = """
        {"title": "T", "body": "B", "trigger": "push"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        XCTAssertNil(reader.action)
        XCTAssertNil(reader.attachments)
        XCTAssertNil(reader.categoryIdentifier)
        XCTAssertNil(reader.badge)
        XCTAssertNil(reader.launchImageName)
        XCTAssertNil(reader.notificationTimestamp)
        XCTAssertNil(reader.sound)
        XCTAssertNil(reader.subtitle)
        XCTAssertNil(reader.thread)
    }

    func testReadsAllOptionalFields() throws {
        let json = """
        {
            "title": "Title",
            "body": "Body",
            "trigger": "calendar",
            "action": "Open",
            "attachments": [{"identifier": "att1", "type": "image/png", "url": "https://example.com/img.png"}],
            "categoryIdentifier": "cat1",
            "badge": 3,
            "launchImageName": "launch",
            "notificationTimestamp": "2021-01-01T00:00:00.000Z",
            "sound": "default",
            "subtitle": "Sub",
            "thread": "thread1"
        }
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        XCTAssertEqual(reader.action, "Open")
        XCTAssertEqual(reader.categoryIdentifier, "cat1")
        XCTAssertEqual(reader.badge, 3)
        XCTAssertEqual(reader.launchImageName, "launch")
        XCTAssertEqual(reader.notificationTimestamp, "2021-01-01T00:00:00.000Z")
        XCTAssertEqual(reader.sound, "default")
        XCTAssertEqual(reader.subtitle, "Sub")
        XCTAssertEqual(reader.thread, "thread1")
        XCTAssertEqual(reader.attachments?.count, 1)
        XCTAssertEqual(reader.attachments?[0].identifier, "att1")
        XCTAssertEqual(reader.attachments?[0].type, "image/png")
        XCTAssertEqual(reader.attachments?[0].url, "https://example.com/img.png")
    }

    func testToMessageNotificationPushTrigger() throws {
        let json = """
        {"title": "T", "body": "B", "trigger": "push"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
    }

    func testToMessageNotificationLocationTrigger() throws {
        let json = """
        {"title": "T", "body": "B", "trigger": "location"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
    }

    func testToMessageNotificationCalendarTrigger() throws {
        let json = """
        {"title": "T", "body": "B", "trigger": "calendar"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
    }

    func testToMessageNotificationTimeIntervalTrigger() throws {
        let json = """
        {"title": "T", "body": "B", "trigger": "timeInterval"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
    }

    func testToMessageNotificationOtherTrigger() throws {
        let json = """
        {"title": "T", "body": "B", "trigger": "other"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
    }

    func testToMessageNotificationUnknownTriggerFallsBackToOther() throws {
        let json = """
        {"title": "T", "body": "B", "trigger": "unknownTrigger"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
    }
}
