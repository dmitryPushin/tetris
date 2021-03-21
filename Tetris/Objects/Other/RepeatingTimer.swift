//
//  RepeatingTimer.swift
//  Tetris
//
//  Created by Dmitry Pushin on 26/10/2018.
//  Copyright © 2018 Dmitry Pushin. All rights reserved.
//

import Foundation

private enum State {
    case suspended
    case resumed
}

protocol RepeatingTimerInput {
    init(interval: TimeInterval,
         handler: @escaping () -> Void)

    func resume()
    func suspend()
}

class RepeatingTimer: RepeatingTimerInput {
    private let interval: TimeInterval
    private var eventHandler: (() -> Void)?
    private var state: State = .suspended

    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.interval, repeating: self.interval)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()

    required init(interval: TimeInterval, handler: @escaping () -> Void) {
        self.interval = interval
        self.eventHandler = handler
    }

    deinit {
        timer.setEventHandler {}
        timer.cancel()
        resume()
        eventHandler = nil
    }
    
    func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
