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

// - 초기 : [o]시작버튼
//   -> 랩 비활성화
//   -> 헤더랩뷰 숨김

// 초기 시작버튼 눌렀을 때
//   -> [o]랩 버튼 활성화
//   -> [o]중단 버튼으로 변경
//   -> [o]Timer start -> label에 데이터 바인딩 (비동기로 계속 타이머 유지되어야함)
//   -> [o]헤더랩뷰에 값 보냄 -> label에 데이터 바인딩(비동기로 계속 타이머 유지되어야함)

// [o]중단 버튼 눌렀을 때
//   -> [o]Timer pause
//   -> [o]Start 버튼으로 변경
//   -> [o]lap 버튼은 재설정으로 변경
//   -> [o]셀에 연결된 타이머도 중단

// [o]시작 버튼 다시 누르면
//   -> [o]타이머 다시 시작
//   -> [o]이후동작은 초기 시작버튼 눌렀을 때와 동일

// [o]랩 버튼 터치시
//   -> [o]콜렉션뷰에 아이템 append
//   -> [o]기록된 랩타입 array중에서 최대값, 최소값을 가지고 있는 모델을 구한다
//   -> [o]최대값, 최소값 모델에 따라 isMax, isMin 값을 true로 변경해주고
//   -> [o]나머지는 isMax, isMin 값을 false로 변경해준다

    @Published var items: [RecordInfo] = []
    var subscriptions = Set<AnyCancellable>()
    
    var timer: Timer?
    var isPlaying: Bool = false
    let TIME_INTERVAL: CGFloat = 0.01
    let CELL_HEIGHT: CGFloat = 50
    var time = Double()
    var lappedTime = Double()
    
    let mainTime = CurrentValueSubject<Double, Never>(0)
    let lapTime = PassthroughSubject<RecordInfo, Never>()
    
    var numOfItems : Int {
        return items.count
    }
    
    var lapRecordInfo: RecordInfo {
        return RecordInfo(title: "Lap \(self.numOfItems + 1)", time: self.lappedTime, isMax: false, isMin: false)
    }
    
    func setCollectionViewHeight() -> CGFloat {
        if isPlaying {
            return CGFloat(numOfItems) * CELL_HEIGHT
        } else {
            return .zero
        }
        
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // input : click action //
    func onClickStartButton() {
        if isPlaying {
            self.stopTimer()
        } else {
            self.startTimer()
        }
        isPlaying.toggle()
    }
    
    func onClickResetButton() {
        if isPlaying {
            self.lapTimer()
        } else {
            self.resetTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TIME_INTERVAL, repeats: true) { _ in
            self.time += self.TIME_INTERVAL
            self.lappedTime += self.TIME_INTERVAL
            self.mainTime.send(self.time)
            self.lapTime.send(self.lapRecordInfo)
        }
    }
    
    func stopTimer() {
        self.invalidateTimer()
    }
    
    func lapTimer() {
        self.items = getCheckedMaxMinRecordList()
        self.lappedTime = 0
    }
    
    func resetTimer() {
        self.invalidateTimer()
        self.time = 0
        self.lappedTime = 0
        self.items = []
        self.mainTime.send(self.time)
        self.lapTime.send(RecordInfo(title: "", time: self.lappedTime, isMax: false, isMin: false))
    }
    
    func getCheckedMaxMinRecordList() -> [RecordInfo] {
        var tempItems = self.items
        let item = lapRecordInfo
        tempItems.append(item)
        
        if tempItems.count > 1 {
            let maxRecord = tempItems.max { a, b in a.time < b.time }
            let minRecord = tempItems.min { a, b in a.time < b.time }
//            print("song \(maxRecord)")
//            print("song \(minRecord)")
            
            tempItems = tempItems.map {
                if maxRecord == $0 {
                    return RecordInfo(title: $0.title, time: $0.time, isMax: true, isMin: false)
                } else if minRecord == $0 {
                    return RecordInfo(title: $0.title, time: $0.time, isMax: false, isMin: true)
                } else {
                    return RecordInfo(title: $0.title, time: $0.time, isMax: false, isMin: false)
                }
            }
        }
        return tempItems
    }
    
}
