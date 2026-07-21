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

class DeepLinkReceivedReaderTests: XCTestCase {

    func testReadsRequiredUrlField() throws {
        let json = """
        {"url": "https://example.com"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: json)
        XCTAssertEqual(reader.url, "https://example.com")
        XCTAssertNil(reader.referrer)
    }

    func testReadsOptionalReferrer() throws {
        let json = """
        {"url": "https://example.com", "referrer": "https://referrer.com"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: json)
        XCTAssertEqual(reader.url, "https://example.com")
        XCTAssertEqual(reader.referrer, "https://referrer.com")
    }

    func testToDeepLinkReceivedWithUrlOnly() throws {
        let json = """
        {"url": "https://example.com"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: json)
        let event = reader.toDeepLinkReceived()
        XCTAssertNotNil(event)
    }

    func testToDeepLinkReceivedWithReferrer() throws {
        let json = """
        {"url": "https://example.com", "referrer": "https://referrer.com"}
        """.data(using: .utf8)!
        let reader = try JSONDecoder().decode(DeepLinkReceivedReader.self, from: json)
        let event = reader.toDeepLinkReceived()
        XCTAssertNotNil(event)
    }
}
