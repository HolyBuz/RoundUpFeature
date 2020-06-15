import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
}


final class MainCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var childCoordinators = [Coordinator]()
    
    func start() {
        setupNavigationBar()
        
        let service = CoreService()
        let facade = ProfileFacadeImpl(service: service)
        let productListViewController = ProfileViewController(facade: facade, coordinator: self)
        navigationController.viewControllers = [productListViewController]
    }
    
    private func childCoordinatorDidFinish(_ child: Coordinator?) {
        childCoordinators.removeAll(where: {child === $0})
        navigationController.popToRootViewController(animated: true)
    }
    
    private func setupNavigationBar() {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear
    }
}
