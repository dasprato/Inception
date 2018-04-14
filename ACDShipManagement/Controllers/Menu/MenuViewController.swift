//
//  MenuViewController.swift
//  ACDShipManagement
//
//  Created by Prato Das on 2018-02-02.
//  Copyright © 2018 Prato Das. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController {

var arrayOfMenus = [Menu]()
    
let interactor = Interactor()

var currentCellIndex: Int!
let mainCollectionViewCellId = "mainCollectionViewCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfMenus.append(Menu(titleForCell: "Trip", operations: "crs"))
        arrayOfMenus.append(Menu(titleForCell: "Ship", operations: "cr"))
        arrayOfMenus.append(Menu(titleForCell: "Company", operations: "cr"))
        arrayOfMenus.append(Menu(titleForCell: "Contact", operations: "cr"))
        arrayOfMenus.append(Menu(titleForCell: "QR Code", operations: "r"))
//        arrayOfMenus.append(Menu(titleForCell: "Developer", operations: ""))
        
        setupMainCollectionView()
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .gray
        self.navigationController?.navigationBar.addShadow()
        view.backgroundColor = .darkGray
        self.navigationItem.title = "Menu"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        updateUserInterface()
        setupObservers()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
    func setupMainCollectionView() {
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: mainCollectionViewCellId)
        
        view.addSubview(menuCollectionView)
        NSLayoutConstraint.activate([menuCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor), menuCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor), menuCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), menuCollectionView.topAnchor.constraint(equalTo: view.topAnchor)])
        
    }
    
    func setupObservers() {

        NotificationCenter.default.addObserver(self, selector: #selector(createShip), name: NSNotification.Name.init("create Ship"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readShip), name: NSNotification.Name.init("read Ship"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateShip), name: NSNotification.Name.init("update Ship"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteShip), name: NSNotification.Name.init("delete Ship"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(createCompany), name: NSNotification.Name.init("create Company"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readCompany), name: NSNotification.Name.init("read Company"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateCompany), name: NSNotification.Name.init("update Company"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCompany), name: NSNotification.Name.init("delete Company"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(createTrip), name: NSNotification.Name.init("create Trip"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readTrip), name: NSNotification.Name.init("read Trip"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTrip), name: NSNotification.Name.init("update Trip"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTrip), name: NSNotification.Name.init("delete Trip"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sailTrip), name: NSNotification.Name.init("sail Trip"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(createContact), name: NSNotification.Name.init("create Contact"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(readContact), name: NSNotification.Name.init("read Contact"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateContact), name: NSNotification.Name.init("update Contact"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(deleteContact), name: NSNotification.Name.init("delete Contact"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(readQRCode), name: NSNotification.Name.init("read QR Code"), object: nil)
        
//
//        NotificationCenter.default.addObserver(self, selector: #selector(openShubranilInfo), name: NSNotification.Name.init("shubranil"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(openSumitInfo), name: NSNotification.Name.init("sumit"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(openPratoInfo), name: NSNotification.Name.init("prato"), object: nil)
    }
    

    private var menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        let rcv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        rcv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        rcv.backgroundColor = .clear
        rcv.translatesAutoresizingMaskIntoConstraints = false
        rcv.clipsToBounds = true
        rcv.keyboardDismissMode = .interactive
        rcv.tag = 1
        rcv.showsVerticalScrollIndicator = false
        rcv.alwaysBounceVertical = true
        return rcv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
//        print("The view appeared; do something about it now; thanks")
        
        
        // To let the cells know that the view will appear
//        NotificationCenter.default.post(name: NSNotification.Name.init("theMenuHasAppeared"), object: self, userInfo: nil)
    }
}


extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfMenus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCollectionViewCellId, for: indexPath) as! MenuCollectionViewCell
        cell.isPortraint = true
        if !collectionView.isDragging || !collectionView.isDecelerating {
            UIView.animate(withDuration: 0.5, animations: {
                cell.backgroundColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: (CGFloat(arc4random_uniform(255)))/255)
            })
            
        }
        cell.titleForCellText = arrayOfMenus[indexPath.row]
        return cell
    }
    
    
    @objc func open() {
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentCellIndex = indexPath.row
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width), height: ((collectionView.frame.width / 2) - 10) / 3)
    }

    
    override var shouldAutorotate: Bool {
        return false
    }
    
    

}


// extension for oppenning the other view controllers
extension MenuViewController {
    @objc func createShip() {
        self.present(UINavigationController(rootViewController: CreateShipViewController()), animated: true, completion: nil)
    }
    @objc func readShip() {
        self.present(UINavigationController(rootViewController: ReadShipViewController()), animated: true, completion: nil)
    }
    @objc func updateShip() {
        UpdateShipViewController().showInteractive()
    }

    @objc func deleteShip() {
        DeleteShipViewController().showInteractive()
    }
    
    
    @objc func createCompany() {
        self.present(UINavigationController(rootViewController: CreateCompanyViewController()), animated: true, completion: nil)
    }
    @objc func readCompany() {
        self.present(UINavigationController(rootViewController: ReadCompanyViewController()), animated: true, completion: nil)
    }
    @objc func updateCompany() {
        UpdateCompanyViewController().showInteractive()
    }
    
    @objc func deleteCompany() {
        DeleteCompanyViewController().showInteractive()
    }
    
    @objc func createTrip() {
        let vc = CreateTripViewController1()
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func sailTrip() {
        let vc = SailTripViewController1()
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    @objc func readTrip() {
        let vc = ReadTripViewController()
        vc.modalTransitionStyle = .crossDissolve
        self.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    @objc func updateTrip() {
        UpdateTripViewController().showInteractive()
    }
    
    @objc func deleteTrip() {
        DeleteTripViewController().showInteractive()
    }
    
    @objc func createContact() {
        
        self.present(UINavigationController(rootViewController: CreateContactViewController()), animated: true, completion: nil)
        
    }
    @objc func readQRCode() {
        self.present(UINavigationController(rootViewController: QRCodeReaderViewController()), animated: true, completion: nil)
    }
    @objc func readContact() {
        self.present(UINavigationController(rootViewController: ReadContactViewController()), animated: true, completion: nil)
    }

    @objc func openPratoInfo() {
        
        let developerInfoViewController = DeveloperInfoViewController()
        developerInfoViewController.developerName = "Prato Das"
        developerInfoViewController.developerImage = UIImage(named: "prato")
        developerInfoViewController.showInteractive()
    }
    
    @objc func openShubranilInfo() {
        
        let developerInfoViewController = DeveloperInfoViewController()
        developerInfoViewController.developerName = "Shubranil Sengupta"
        developerInfoViewController.developerImage = UIImage(named: "shubranil")
        developerInfoViewController.showInteractive()
    }
    
    @objc func openSumitInfo() {
        
        let developerInfoViewController = DeveloperInfoViewController()
        developerInfoViewController.developerName = "Sumit Somani"
        developerInfoViewController.developerImage = UIImage(named: "sumit")
        developerInfoViewController.showInteractive()
        
        
    }
    
    
    
}

extension MenuViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
    
    
    
    
    
    

