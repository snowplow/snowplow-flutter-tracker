//
//  ScreenViewReader.swift
//  snowplow_flutter_tracker
//
//  Created by Matus Tomlein on 04/01/2022.
//

import Foundation
import SnowplowTracker

struct ScreenViewReader: Decodable {
    let name: String
    let id: String?
    let type: String?
    let previousName: String?
    let previousType: String?
    let previousId: String?
    let transitionType: String?
    
    var idUUID: UUID? {
        if let id = self.id {
            return UUID(uuidString: id)
        }
        return nil
    }
}

extension ScreenViewReader {
    func toScreenView() -> ScreenView {
        let event = ScreenView(name: name, screenId: idUUID)
        if let t = self.type { event.type(t) }
        if let pn = self.previousName { event.previousName(pn) }
        if let pt = self.previousType { event.previousType(pt) }
        if let pi = self.previousId { event.previousId(pi) }
        if let tt = self.transitionType { event.transitionType(tt) }
        return event
    }
}
