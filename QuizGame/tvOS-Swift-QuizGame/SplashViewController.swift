import UIKit

class SplashViewController: UIViewController {
    
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigateToQuiz()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // App Title Label
        titleLabel.text = "General Knowledge!"
        titleLabel.font = UIFont.systemFont(ofSize: 84, weight: .bold)
        titleLabel.textColor = .systemGreen
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func navigateToQuiz() {
        // Transition to QuizViewController after 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            guard let self = self else { return }
            
            let quizVC = QuizViewController()
            let navigationController = UINavigationController(rootViewController: quizVC)
            navigationController.navigationBar.isHidden = true
            
            // Replace the splash screen with QuizViewController
            self.view.window?.rootViewController = navigationController
        }
    }
}
