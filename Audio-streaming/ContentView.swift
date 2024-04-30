//
//  ContentView.swift
//  Audio-streaming
//
//  Created by Eyoel Gebre on 2/27/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
  var audioEngine: AVAudioEngine
  
  init() {
    audioEngine = AVAudioEngine()
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(.playAndRecord)
    try! session.setPreferredIOBufferDuration(0.008)
    try! session.setActive(true)
  }
  
  func startStreaming() -> Void {
    // Configure the session
    self.audioEngine.connect(self.audioEngine.inputNode, to: self.audioEngine.outputNode, format: nil)
    try! self.audioEngine.start()
  }
  
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
        .onAppear {
          self.startStreaming()
        }
    }
    .padding()
  }
}

#Preview {
    ContentView()
}
