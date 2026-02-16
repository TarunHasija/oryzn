//
//  oryzn_widgetLiveActivity.swift
//  oryzn_widget
//
//  Created by Tarun hasija on 09/02/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct oryzn_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct oryzn_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: oryzn_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension oryzn_widgetAttributes {
    fileprivate static var preview: oryzn_widgetAttributes {
        oryzn_widgetAttributes(name: "World")
    }
}

extension oryzn_widgetAttributes.ContentState {
    fileprivate static var smiley: oryzn_widgetAttributes.ContentState {
        oryzn_widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: oryzn_widgetAttributes.ContentState {
         oryzn_widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: oryzn_widgetAttributes.preview) {
   oryzn_widgetLiveActivity()
} contentStates: {
    oryzn_widgetAttributes.ContentState.smiley
    oryzn_widgetAttributes.ContentState.starEyes
}
