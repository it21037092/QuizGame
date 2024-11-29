import UIKit

class QuizViewController: UIViewController {
    
    private var questions: [(question: String, answers: [String], correctIndex: Int)] = [
        ("What is the largest planet in our solar system?", ["Earth", "Venus", "Jupiter", "Mars"], 2),
                ("In which year did the Titanic sink?", ["1912", "1898", "1905", "1923"], 0),
                ("What is the hardest natural substance on Earth?", ["Gold", "Diamond", "Iron", "Platinum"], 1),
                ("What is the longest river in the world?", ["Amazon River", "Nile River", "Yangtze River", "Mississippi River"], 1),
                ("What is the smallest country in the world?", ["Monaco", "San Marino", "Vatican City", "Nauru"], 2),
                ("Who was the first President of the United States?", ["Thomas Jefferson", "John Adams", "Abraham Lincoln", "George Washington"], 3),
                ("What is the currency used in Japan?", ["Yen", "Won", "Ringgit", "Baht"], 0),
                ("Who discovered gravity when an apple fell on his head?", ["Nikola Tesla", "Albert Einstein", "Isaac Newton", "Galileo Galilei"], 2),
                ("What is the symbol for gold on the periodic table?", ["Au ", "Ag", "Hg", "Pb"], 0),
                ("In what year did World War II end?", ["1940", "1943", "1945", "1950"], 2)
    ]
    
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    
    private let questionLabel = UILabel()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Question Label
        questionLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Stack View for Answers
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func randomColor() -> UIColor {
        // Generate random values for red, green, and blue components
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    private func loadQuestion() {
        // Clear existing buttons
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Get current question
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.question
        
        // Create two horizontal stack views for two answers per row
        var rowStackViews: [UIStackView] = []
        
        for i in stride(from: 0, to: currentQuestion.answers.count, by: 2) {
            // Create a horizontal stack view for each row
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 20
            rowStackView.alignment = .center
            rowStackView.distribution = .fillEqually
            
            // Add two buttons per row
            for j in 0..<2 {
                let buttonIndex = i + j
                if buttonIndex < currentQuestion.answers.count {
                    let button = UIButton(type: .system)
                    button.setTitle(currentQuestion.answers[buttonIndex], for: .normal)
                    button.setTitleColor(.black, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 45, weight: .medium)
                    button.backgroundColor = randomColor()  // Set a random color
                    button.layer.cornerRadius = 15
                    button.tag = buttonIndex
                    button.addTarget(self, action: #selector(answerTapped(_:)), for: .primaryActionTriggered)
                    
                    // Add the button to the row stack view
                    rowStackView.addArrangedSubview(button)
                    
                    // Set width and height for each button
                    button.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        button.widthAnchor.constraint(equalToConstant: 150), // Reduced width
                        button.heightAnchor.constraint(equalToConstant: 300) // Height as per previous design
                    ])
                }
            }
            
            // Add the row stack view to the main stack view
            rowStackViews.append(rowStackView)
        }
        
        // Add each row stack view to the main stack view
        for rowStackView in rowStackViews {
            stackView.addArrangedSubview(rowStackView)
        }
    }
    
    @objc private func answerTapped(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = sender.tag == currentQuestion.correctIndex
        
        if isCorrect {
            correctAnswersCount += 1
        }
        
        showResultAlert(isCorrect: isCorrect)
    }
    
    private func showResultAlert(isCorrect: Bool) {
        let alert = UIAlertController(
            title: isCorrect ? "Correct!" : "Wrong!",
            message: isCorrect
                ? "Good job! You selected the correct answer."
                : "Oops! The correct answer was \(questions[currentQuestionIndex].answers[questions[currentQuestionIndex].correctIndex]).",
            preferredStyle: .alert
        )
        
        let nextAction = UIAlertAction(title: "Next", style: .default) { [weak self] _ in
            self?.handleNextQuestion()
        }
        alert.addAction(nextAction)
        present(alert, animated: true)
    }
    
    private func handleNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            loadQuestion()
        } else {
            navigateToEndingScreen()
        }
    }
    
    private func navigateToEndingScreen() {
        let endingVC = EndingViewController()
        endingVC.score = correctAnswersCount
        endingVC.totalQuestions = questions.count
        navigationController?.pushViewController(endingVC, animated: true)
    }
    
    func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswersCount = 0
        loadQuestion()
    }
}
