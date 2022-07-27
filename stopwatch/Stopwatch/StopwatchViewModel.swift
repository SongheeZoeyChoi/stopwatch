//
//  StopwatchViewModel.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/07/27.
//

import UIKit
import Combine

final class StopwatchViewModel {
    
// 타이머는 한개

// - 초기 : [o]시작버튼 -> 랩 비활성화

// 초기 시작버튼 눌렀을 때
//   -> [o]랩 버튼 활성화
//   -> [o]중단 버튼으로 변경
//   -> [o]Timer start -> label에 데이터 바인딩 (비동기로 계속 타이머 유지되어야함)
//   -> [ ]콜렉션뷰 append -> label에 데이터 바인딩(비동기로 계속 타이머 유지되어야함)

// [o]중단 버튼 눌렀을 때
//   -> [o]Timer pause
//   -> [o]Start 버튼으로 변경
//   -> [o]lap 버튼은 재설정으로 변경
//   -> [o]셀에 연결된 타이머도 중단

// [o]시작 버튼 다시 누르면
//   -> [o]타이머 다시 시작
//   -> [o]이후동작은 초기 시작버튼 눌렀을 때와 동일

// 랩 버튼 터치시
//   -> 콜렉션뷰에 아이템 append

    @Published var items: [RecordInfo] = []
    var subscriptions = Set<AnyCancellable>()
    
    var timer: Timer?
    var isPlaying: Bool = false
    var time: Double = 0
    
    let mainTime = CurrentValueSubject<Double, Never>(0)
    
    // input : click action //
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.time += 0.01
            self.mainTime.send(self.time)
        }
        
        // TODO: 콜렉션뷰 맨 나중에 기록되는 라벨 비동기 연결
    }
    
    func stopTimer() {
        self.invalidateTimer()
    }
    
    func lapTimer() {
        // 랩 눌렀을 때
        // time -> 콜렉션 뷰 items에 넣기
        let item = RecordInfo(time: self.time)
        self.items.append(item)
    }
    
    func resetTimer() {
        self.invalidateTimer()
        self.time = 0
        self.items = [] // TODO: 초기화가 왜 안될까? 
        self.mainTime.send(self.time)
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
