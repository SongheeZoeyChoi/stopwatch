//
//  StopwatchViewController.swift
//  stopwatch
//
//  Created by Songhee Choi on 2022/07/26.
//

import UIKit
import Combine

class StopwatchViewController: BaseViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Item = RecordInfo
    enum Section {
        case main 
    }
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    let viewModel = StopwatchViewModel()
    var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureCollectionView()
        bind()
    }
        
    private func setupUI() {
        resetButton.layer.masksToBounds = true
        resetButton.layer.cornerRadius = 40
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 40
        
        updateButtonUI()
    }
    
    private func updateButtonUI() {
        updateResetButtonUI()
        updateStartButtonUI()
    }
    
    private func updateResetButtonUI() {
        var title = String()
        var alpha = CGFloat()
        var isEnabled = Bool()
        if viewModel.time == 0,!viewModel.isPlaying { // 초기값
            title = "Lap"
            alpha = 0.5
            isEnabled = false
        } else if viewModel.isPlaying {
            title = "Lap"
            alpha = 1
            isEnabled = true
        } else { //멈춤 상태
            title = "Reset"
            alpha = 1
            isEnabled = true
        }
        resetButton.setTitle(title, for: .normal)
        resetButton.backgroundColor?.withAlphaComponent(alpha)
        resetButton.isEnabled = isEnabled
    }
    
    private func updateStartButtonUI() {
        let isPlaying = viewModel.isPlaying
        let title: String = isPlaying ? "Stop" : "Start"
        let color: UIColor = isPlaying ? .systemRed : .systemGreen
        startButton.setTitle(title, for: .normal)
        startButton.backgroundColor = color
        
    }
    
    private func configureCollectionView() {
        //presentation
        datasource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecordCell", for: indexPath) as? RecordCell else { return nil }
            
            cell.configure(item: item, index: indexPath.item)
            return cell
        })
        
        // layout
        collectionView.collectionViewLayout = layout()
        
        // data
        initDataSource()
    }
    
    private func initDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([], toSection: .main)
        datasource.apply(snapshot)
    }
    
    private func applyItems(_ items: [RecordInfo]) {
        var snapshot = datasource.snapshot()
        snapshot.appendItems(items, toSection: .main)
        datasource.apply(snapshot)
    }
    
    private func bind() {
        // output : data binding
        viewModel.mainTime
            .receive(on: RunLoop.main)
            .sink { time in
                print("메인시간 \(time)")
                self.timeLabel.text = String(format: "%.2f", time)
            }.store(in: &subscriptions)
        
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink { item in
                print("기록된 Lap 시간: \(item)")
                self.applyItems(item)
            }.store(in: &subscriptions)
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @IBAction func onClickStart(_ sender: Any) { // or Stop
        if viewModel.isPlaying {
            self.viewModel.stopTimer()
        } else {
            self.viewModel.startTimer()
        }
        viewModel.isPlaying.toggle()
        updateButtonUI()
    }
    
    @IBAction func onClickReset(_ sender: Any) { // or lap
        if viewModel.isPlaying {
            self.viewModel.lapTimer()
        } else {
            self.viewModel.resetTimer()
            self.initDataSource()
        }
        updateButtonUI()
    }
    
    
    
}
