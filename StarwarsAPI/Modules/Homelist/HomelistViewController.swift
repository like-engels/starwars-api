//
//  HomelistViewController.swift
//  CatsAPITest
//
//  Created by Higashikata Maverick on 15/5/23.
//

import UIKit
import Combine

enum SectionIdentifier {
    case main
}

class HomelistViewController: UIViewController {
    
    let viewModel: HomelistViewModelRepresentable
    var data: [CharacterModel]?
    private var dataSource: UICollectionViewDiffableDataSource<SectionIdentifier, CharacterModel>!
    var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previousPageButtton: UIButton!
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var currentPageIndicatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomelistCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reusableCell")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Starwars API"
        
        viewModel.pageIndicatorSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { pageIndicator in
                self.currentPageIndicatorLabel.text = pageIndicator
            }
            .store(in: &self.cancellables)
        
        viewModel.thereIsPreviousPageSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { isEnabledValue in
                self.previousPageButtton.isEnabled = isEnabledValue
            }
            .store(in: &self.cancellables)
        
        viewModel.thereIsNextPageSubject
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { isEnabledValue in
                self.nextPageButton.isEnabled = isEnabledValue
            }
            .store(in: &self.cancellables)



        
        setupDataSource()
        fetchData()
        
        // Do any additional setup after loading the view.
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionIdentifier, CharacterModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> HomelistCollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableCell", for: indexPath) as! HomelistCollectionViewCell
            
                HttpImageDataClient().getData(from: "https://hdwpro.com/wp-content/uploads/2018/01/Free-Star-Wars-250x250.jpeg") { result in
                    if case .failure(let s) = result {
                        print(s)
                    }

                    if case .success(let t) = result {
                        cell.configure(with: t, and: itemIdentifier.name)
                    }
                }
            
            return cell
        })
    }
    
    func fetchData() {
        DispatchQueue.main.async {
            self.viewModel.loadData { data in
                
                if case .none = data { print("Ohno"); return }
                
                var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, CharacterModel>()
                snapshot.appendSections([.main])
                snapshot.appendItems(data!)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    init(nibName: String?, bundle: Bundle?, viewModel: HomelistViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func previousButtonTouchAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.viewModel.previousPage { data in
                if case .none = data {
                    print("oh no")
                    return
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, CharacterModel>()
                snapshot.appendSections([.main])
                snapshot.appendItems(data!)
                self.dataSource.apply(snapshot, animatingDifferences: true)
                
            }
        }
    }
    
    @IBAction func nextButtonTouchAction(_ sender: Any) {
        DispatchQueue.main.async {
            self.viewModel.nextPage { data in
                if case .none = data {
                    print("oh no")
                    return
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, CharacterModel>()
                snapshot.appendSections([.main])
                snapshot.appendItems(data!)
                self.dataSource.apply(snapshot, animatingDifferences: true)
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomelistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
            //print("Selected item: \(selectedItem)")
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(CharacterDetailsViewController(character: selectedItem), animated: true)
        }
    }
    
}
