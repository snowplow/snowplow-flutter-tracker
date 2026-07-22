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
@testable import snowplow_tracker

class MessageNotificationReaderTests: XCTestCase {

    func testReaderDecodesRequiredFields() throws {
        let json = """
        {"title": "Test Title", "body": "Test Body", "trigger": "push"}
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: data)

        XCTAssertEqual(reader.title, "Test Title")
        XCTAssertEqual(reader.body, "Test Body")
        XCTAssertEqual(reader.trigger, "push")
    }

    func testReaderDecodesOptionalFields() throws {
        let json = """
        {
            "title": "Title",
            "body": "Body",
            "trigger": "calendar",
            "action": "Open",
            "bodyLocArgs": ["bodyArg"],
            "bodyLocKey": "bodyKey",
            "category": "cat1",
            "contentAvailable": true,
            "group": "group1",
            "icon": "icon1",
            "notificationCount": 5,
            "notificationTimestamp": "2023-01-01T00:00:00Z",
            "sound": "default",
            "subtitle": "Subtitle",
            "tag": "tag1",
            "threadIdentifier": "thread1",
            "titleLocArgs": ["titleArg"],
            "titleLocKey": "titleKey"
        }
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: data)

        XCTAssertEqual(reader.action, "Open")
        XCTAssertEqual(reader.bodyLocArgs, ["bodyArg"])
        XCTAssertEqual(reader.bodyLocKey, "bodyKey")
        XCTAssertEqual(reader.category, "cat1")
        XCTAssertEqual(reader.contentAvailable, true)
        XCTAssertEqual(reader.group, "group1")
        XCTAssertEqual(reader.icon, "icon1")
        XCTAssertEqual(reader.notificationCount, 5)
        XCTAssertEqual(reader.notificationTimestamp, "2023-01-01T00:00:00Z")
        XCTAssertEqual(reader.sound, "default")
        XCTAssertEqual(reader.subtitle, "Subtitle")
        XCTAssertEqual(reader.tag, "tag1")
        XCTAssertEqual(reader.threadIdentifier, "thread1")
        XCTAssertEqual(reader.titleLocArgs, ["titleArg"])
        XCTAssertEqual(reader.titleLocKey, "titleKey")
    }

    func testReaderNullsAbsentOptionalFields() throws {
        let json = """
        {"title": "Title", "body": "Body", "trigger": "push"}
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: data)

        XCTAssertNil(reader.action)
        XCTAssertNil(reader.attachments)
        XCTAssertNil(reader.bodyLocArgs)
        XCTAssertNil(reader.bodyLocKey)
        XCTAssertNil(reader.category)
        XCTAssertNil(reader.contentAvailable)
        XCTAssertNil(reader.group)
        XCTAssertNil(reader.icon)
        XCTAssertNil(reader.notificationCount)
        XCTAssertNil(reader.notificationTimestamp)
        XCTAssertNil(reader.sound)
        XCTAssertNil(reader.subtitle)
        XCTAssertNil(reader.tag)
        XCTAssertNil(reader.threadIdentifier)
        XCTAssertNil(reader.titleLocArgs)
        XCTAssertNil(reader.titleLocKey)
    }

    func testToMessageNotificationProducesEvent() throws {
        let json = """
        {"title": "Title", "body": "Body", "trigger": "push"}
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: data)
        let event = reader.toMessageNotification()

        XCTAssertNotNil(event)
    }

    func testToMessageNotificationWithAllOptionalFields() throws {
        let json = """
        {
            "title": "Title",
            "body": "Body",
            "trigger": "timeInterval",
            "action": "Open",
            "category": "cat1",
            "notificationTimestamp": "2023-01-01T00:00:00Z",
            "sound": "default",
            "subtitle": "Subtitle",
            "threadIdentifier": "thread1",
            "attachments": [
                {"identifier": "att1", "type": "image/png", "url": "https://example.com/img.png"}
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: data)
        let event = reader.toMessageNotification()

        XCTAssertNotNil(event)
        XCTAssertEqual(reader.attachments?.count, 1)
        XCTAssertEqual(reader.attachments?.first?.identifier, "att1")
    }

    func testAllTriggerValuesProduceEvent() throws {
        for triggerStr in ["push", "calendar", "timeInterval", "location"] {
            let json = """
            {"title": "Title", "body": "Body", "trigger": "\(triggerStr)"}
            """
            let data = json.data(using: .utf8)!
            let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: data)
            let event = reader.toMessageNotification()
            XCTAssertNotNil(event, "Event should not be nil for trigger: \(triggerStr)")
        }
    }
}
