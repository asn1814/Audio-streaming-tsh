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
    var inputNode: AVAudioInputNode
    var playerNode: AVAudioPlayerNode
    var bufferDuration: AVAudioFrameCount
    
    init() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        playerNode = AVAudioPlayerNode()
        bufferDuration = 960// AVAudioFrameCount(352)
    }
    
    func startStreaming() -> Void {
        // Configuration the session
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker])
            // TODO: Adjust to work with TSH model
            try audioSession.setPreferredSampleRate(96000)
            // 8ms buffers
            try audioSession.setPreferredIOBufferDuration(0.008)
            try audioSession.setActive(true)
            try audioSession.overrideOutputAudioPort(.speaker)
        } catch {
            print("Audio Session error: \(error)")
        }
      
      let fmt = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: AVAudioSession.sharedInstance().sampleRate, channels: 2, interleaved: false)
        
      var count = 0
      print(inputNode.rate)
      print(inputNode.latency)
      print(inputNode.outputPresentationLatency)
      print(inputNode.auAudioUnit.latency)
      print(inputNode.auAudioUnit.tailTime)
      inputNode.volume = 100 // doesnt seem to do anything
      playerNode.volume = 100
        // Set the playerNode to immedietly queue/play the recorded buffer
      inputNode.installTap(onBus: 0, bufferSize: bufferDuration, format: fmt/*inputNode.inputFormat(forBus: 0)*/) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            // Schedule the buffer for playback
            //buffer.frameLength = 9600;
            print(buffer.format)
            print(buffer.frameCapacity)
            print(buffer.frameLength)
            print(when.sampleRate)
            print(count)
            count = count + 1
            playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        }
        
        // Start the engine
        do {
            audioEngine.attach(playerNode)
            audioEngine.connect(playerNode, to: audioEngine.outputNode, format: fmt/*inputNode.inputFormat(forBus: 0)*/)
            
            try audioEngine.start()
            playerNode.play()
        } catch {
            print("Audio Engine start error: \(error)")
        }
        
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
