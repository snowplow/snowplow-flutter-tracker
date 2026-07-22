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

class DeepLinkReceivedReaderTests: XCTestCase {

    func testReaderDecodesRequiredUrl() throws {
        let json = """
        {"url": "https://example.com/path"}
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: data)

        XCTAssertEqual(reader.url, "https://example.com/path")
        XCTAssertNil(reader.referrer)
    }

    func testReaderDecodesOptionalReferrer() throws {
        let json = """
        {"url": "https://example.com/path", "referrer": "https://referrer.example.com"}
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: data)

        XCTAssertEqual(reader.url, "https://example.com/path")
        XCTAssertEqual(reader.referrer, "https://referrer.example.com")
    }

    func testToDeepLinkReceivedProducesEvent() throws {
        let json = """
        {"url": "https://example.com/path", "referrer": "https://referrer.example.com"}
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: data)
        let event = reader.toDeepLinkReceived()

        XCTAssertNotNil(event)
    }

    func testToDeepLinkReceivedWithoutReferrer() throws {
        let json = """
        {"url": "https://example.com/path"}
        """
        let data = json.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: data)
        let event = reader.toDeepLinkReceived()

        XCTAssertNotNil(event)
    }
}
