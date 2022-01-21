//
//  MedicationVC.swift
//  Clinic
//
//  Created by Ressam Al-Thebailah on 23/05/1443 AH.
//

import UIKit
import FirebaseDatabase

class AddMedicationVC: UIViewController {
  
  @IBOutlet weak var patientNameLabel: UILabel!
  @IBOutlet weak var doctorNameLabel: UILabel!
  @IBOutlet weak var departmentNameLabel: UILabel!
  @IBOutlet weak var treatmentTextField: UITextField!
  
  var ref : DatabaseReference!
  var confirmedModel = ConfirmedBooksModel()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ref = Database.database().reference()
    setUpElements()
    initData()
  }
  
  
  func setUpElements() {
    patientNameLabel.styleLabel()
    departmentNameLabel.styleLabel()
    treatmentTextField.styleTextField()
    doctorNameLabel.styleLabel()
  }
  
  
  private func initData() {
    
    ref.child("Doctor").child(confirmedModel.doctorId).getData { error,
                                                                 Data in
      if let data = Data.value as? NSDictionary {
        
        self.doctorNameLabel.text! = data["doctorName"] as? String ?? "No data"
        self.departmentNameLabel.text!   = data["clinicName"] as? String ?? "No data"
      }
    }
    
    ref.child(K.FireStore.usersCollection).child(confirmedModel.userId).getData { error, Data in
      
      if let data = Data.value as? NSDictionary {
        let first  = data["FirstName"] as? String ?? "No data"
        let last  = data["LastName"] as? String ?? "No data"
        self.patientNameLabel.text! = first + " " + last
        
      }
    }
    
    ref.child("Medication").child(confirmedModel.bookId).getData{ error , Data in
      if let data = Data.value as? NSDictionary,Data.exists(){
        self.treatmentTextField.text = data["medication"] as? String ?? "No data"
      }
    }
  }
  

  @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
      treatmentTextField.resignFirstResponder()
  }

  
  @IBAction func addButtonTapped(_ sender: UIButton) {
    let model = MedicationModel(bookId: confirmedModel.bookId, medication: treatmentTextField.text!)
      ref.child("Medication").child(confirmedModel.bookId).setValue(model.toDic()){ [self]
      error , result in
      if error == nil
      {
        self.showaAlertDoneView(Title: "Done!",
                                Msg: "Medicine have been added successfully")
          self.confirmedModel.haveMedication = true
          self.ref.child("confirmedBooks").child(self.confirmedModel.bookId).setValue(self.confirmedModel.toDic())
      }else{
        self.showaAlertDoneView(Title: "Error!",
                                Msg: error.debugDescription)
      }
    }
  }
}


