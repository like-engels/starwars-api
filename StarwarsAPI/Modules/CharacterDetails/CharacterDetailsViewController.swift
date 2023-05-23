//
//  CharacterDetailsViewController.swift
//  CatsAPITest
//
//  Created by Higashikata Maverick on 19/5/23.
//

import UIKit

class CharacterDetailsViewController: UIViewController {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterGender: UILabel!
    @IBOutlet weak var characterHomeworld: UILabel!
    @IBOutlet weak var characterBirthdate: UILabel!
    private let character: CharacterModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(character.name) Details"
        
        characterName.text = character.name
        characterGender.text = character.gender.rawValue
        characterHomeworld.text = character.homeworld
        characterBirthdate.text = character.birthYear

        // Do any additional setup after loading the view.
    }
    
    init(character: CharacterModel) {
        self.character = character
        super.init(nibName: "CharacterDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
