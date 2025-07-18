import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButtonClicked: UIButton!
    @IBOutlet private weak var noButtonClicked: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Properties
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var statisticService: StatisticServiceProtocol!
    private var alertPresenter: AlertPresenter?
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDependencies()
        loadData()
    }
    private func setupViews() {
        imageView.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true
        hideQuizUI()
    }

    private func setupDependencies() {
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
    }

    private func loadData() {
        activityIndicator.startAnimating()
        questionFactory?.loadData()
    }

    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func willLoadNextQuestion() {
        hideQuizUI()
        imageView.image = nil
    }
    
    func didFailToLoadData(with error: any Error) {
        activityIndicator.stopAnimating()
        showNetworkError(message: "Не возможно загрузить данные")
    }
    func didUpdateImage(for question: QuizQuestion) {
        currentQuestion = question
        if UIImage(data: question.image) != nil {
            UIView.transition(with: imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.imageView.image = UIImage(data: question.image)
            }, completion: nil)
        } else {
            imageView.image = UIImage()
        }
    }

    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        showQuizUI()
        show(quiz: viewModel)
        imageView.image = nil
    }
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: false)
    }
    
    // MARK: - Private Methods Game Logic
    
    private func handleAnswer(givenAnswer: Bool) {
        guard let currentQuestion else {
            return
        }
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        if isCorrect {
            correctAnswers += 1
        }
        showAnswerResult(isCorrect: isCorrect)
    }
    
    // MARK: - Converters
    
    private func convert(model: QuizQuestion) -> QuizStep {
        let questionStep = QuizStep(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
        return questionStep
    }
    
    // MARK: - Updates
    private func show(quiz step: QuizStep) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypsGreen.cgColor : UIColor.ypsRed.cgColor
        
        yesButtonClicked.isEnabled = false
        noButtonClicked.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self else { return }
            self.showNextQuestionOrResults()
            self.yesButtonClicked.isEnabled = true
            self.noButtonClicked.isEnabled = true
        }
    }
    private func showQuizResults() {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        let totalAccuracy = String(format: "%.2f", statisticService.totalAccuracy)
        
        let message = """
        Ваш результат: \(correctAnswers)/\(questionsAmount)
        Количество сыгранных игр: \(statisticService.gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
        Средняя точность: \(totalAccuracy)%
        """
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть ещё раз"
        ) { [weak self] in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.reset()
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(alert: alertModel)
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            showQuizResults()
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        
        let model = AlertModel(
            title: "Что-то пошло не так(",
            message: message,
            buttonText: "Попробовать еще раз"
        ) { [weak self] in
            guard let self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.show(alert: model)
    }
    
    // MARK: - UI Visibility
    private func hideQuizUI() {
        stackView.isHidden = true
    }
    
    private func showQuizUI() {
        stackView.isHidden = false
    }
}
