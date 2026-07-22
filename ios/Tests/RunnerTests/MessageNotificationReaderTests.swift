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
import SnowplowTracker

class MessageNotificationReaderTests: XCTestCase {

    func testReadsRequiredFields() throws {
        let json = """{"title":"Title","body":"Body","trigger":"push"}""".data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        XCTAssertEqual(reader.title, "Title")
        XCTAssertEqual(reader.body, "Body")
        XCTAssertEqual(reader.trigger, "push")
    }

    func testOptionalFieldsAreNilByDefault() throws {
        let json = """{"title":"T","body":"B","trigger":"push"}""".data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        XCTAssertNil(reader.notificationTimestamp)
        XCTAssertNil(reader.categoryIdentifier)
        XCTAssertNil(reader.threadIdentifier)
        XCTAssertNil(reader.subtitle)
        XCTAssertNil(reader.badge)
        XCTAssertNil(reader.sound)
        XCTAssertNil(reader.launchImageName)
        XCTAssertNil(reader.action)
        XCTAssertNil(reader.attachments)
    }

    func testReadsAllOptionalFields() throws {
        let json = """
        {
            "title":"T","body":"B","trigger":"push",
            "notificationTimestamp":"2023-01-01T00:00:00.000Z",
            "categoryIdentifier":"cat","threadIdentifier":"thread",
            "subtitle":"sub","badge":3,"sound":"sound.wav",
            "launchImageName":"launch.png","action":"click"
        }
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        XCTAssertEqual(reader.notificationTimestamp, "2023-01-01T00:00:00.000Z")
        XCTAssertEqual(reader.categoryIdentifier, "cat")
        XCTAssertEqual(reader.threadIdentifier, "thread")
        XCTAssertEqual(reader.subtitle, "sub")
        XCTAssertEqual(reader.badge, 3)
        XCTAssertEqual(reader.sound, "sound.wav")
        XCTAssertEqual(reader.launchImageName, "launch.png")
        XCTAssertEqual(reader.action, "click")
    }

    func testCreatesNativeMessageNotificationEvent() throws {
        let json = """{"title":"T","body":"B","trigger":"push"}""".data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
        XCTAssertTrue(event is MessageNotification)
    }

    func testMapsAllTriggerValues() throws {
        for trigger in ["push", "location", "calendar", "timeInterval"] {
            let json = "{\"title\":\"T\",\"body\":\"B\",\"trigger\":\"\(trigger)\"}".data(using: .utf8)!
            let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
            let event = reader.toMessageNotification()
            XCTAssertNotNil(event, "Failed for trigger: \(trigger)")
        }
    }

    func testReadsAttachments() throws {
        let json = """
        {
            "title":"T","body":"B","trigger":"push",
            "attachments":[{"identifier":"id1","type":"image/png","url":"https://example.com/img.png"}]
        }
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        XCTAssertEqual(reader.attachments?.count, 1)
        XCTAssertEqual(reader.attachments?.first?.identifier, "id1")
        XCTAssertEqual(reader.attachments?.first?.type, "image/png")
        XCTAssertEqual(reader.attachments?.first?.url, "https://example.com/img.png")
    }

    func testCreatesNativeEventWithAttachments() throws {
        let json = """
        {
            "title":"T","body":"B","trigger":"push",
            "attachments":[{"identifier":"id1","type":"image/png","url":"https://example.com/img.png"}]
        }
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(MessageNotificationReader.self, from: json)
        let event = reader.toMessageNotification()
        XCTAssertNotNil(event)
    }
}
