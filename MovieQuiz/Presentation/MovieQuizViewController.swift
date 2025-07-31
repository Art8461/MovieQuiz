import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol, AlertPresenterProtocol {
    
    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButtonClicked: UIButton!
    @IBOutlet private weak var noButtonClicked: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    //MARK: - Private properties
    
    private var presenter: MovieQuizPresenter!
    private lazy var alertPresenter = AlertPresenter(view: self)
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        // Добавляем accessibilityIdentifier для UI-тестов
                imageView.accessibilityIdentifier = "Poster"
                counterLabel.accessibilityIdentifier = "Index"
                yesButtonClicked.accessibilityIdentifier = "Yes"
                noButtonClicked.accessibilityIdentifier = "No"
    }
    
    //MARK: - AlertPresenterProtocol
    
    func present(alert: UIAlertController, animated: Bool) {
        self.present(alert, animated: animated)
    }
    
    //MARK: - Public methods
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Что-то пошло не так(",
                               message: "Невозможно загрузить данные",
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            self.presenter.loadData()
        }
        
        alertPresenter.show(alert: model)
    }
    
    func show(quiz step: QuizStep) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
    }
    
    func show(result: QuizResults) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
        imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}
