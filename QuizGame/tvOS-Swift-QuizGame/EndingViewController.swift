import UIKit

class EndingViewController: UIViewController {
    
    private let messageLabel = UILabel()
    private let emojiLabel = UILabel()
    private let scoreLabel = UILabel()
    private let restartButton = UIButton(type: .system)
    
    var score: Int = 0
    var totalQuestions: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureResultMessage()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Emoji Label
        emojiLabel.font = UIFont.systemFont(ofSize: 100)
        emojiLabel.textAlignment = .center
        view.addSubview(emojiLabel)
        
        // Message Label
        messageLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        view.addSubview(messageLabel)
        
        // Score Label
        scoreLabel.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        scoreLabel.textColor = .white
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
        
        // Restart Button
        configureButton(restartButton, title: "Restart Quiz", color: .orange)
        restartButton.addTarget(self, action: #selector(restartQuiz), for: .primaryActionTriggered)
        view.addSubview(restartButton)
        
        // Layout
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            scoreLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            restartButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 280),
            restartButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureButton(_ button: UIButton, title: String, color: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .medium)
    }
    
    private func configureResultMessage() {
        let performance = Double(score) / Double(totalQuestions)
        
        switch performance {
        case 0.8...1.0:
            emojiLabel.text = "🎉"
            messageLabel.text = "Excellent Job!"
        case 0.5..<0.8:
            emojiLabel.text = "🙂"
            messageLabel.text = "Good Effort!"
        default:
            emojiLabel.text = "😢"
            messageLabel.text = "Better Luck Next Time!"
        }
        
        scoreLabel.text = "You scored \(score) out of \(totalQuestions)!"
    }
    
    @objc private func restartQuiz() {
        guard let navigationController = navigationController else { return }
        
        if let quizVC = navigationController.viewControllers.first as? QuizViewController {
            quizVC.resetQuiz()
        }
        navigationController.popToRootViewController(animated: true)
    }
}
