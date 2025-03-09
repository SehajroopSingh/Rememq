import CoreData

class DataSyncManager {
    static let shared = DataSyncManager()

    private init() {}

    func fetchAndStoreQuickCaptures() {
        APIService.shared.performRequest(endpoint: "processor/list_quick_captures/") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(QuickCapturesResponse.self, from: data)
                        self.saveQuickCapturesToCoreData(decodedResponse.captures)
                    } catch {
                        print("❌ Decoding error: \(error.localizedDescription)")
                    }
                case .failure(let error):
                    print("🔴 API Request failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func saveQuickCapturesToCoreData(_ captures: [QuickCapture]) {
        let context = PersistenceController.shared.viewContext

        for capture in captures {
            let fetchRequest: NSFetchRequest<QuickCapture> = QuickCapture.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", capture.id)

            do {
                let results = try context.fetch(fetchRequest)
                let quickCapture = results.first ?? QuickCapture(context: context)
                quickCapture.id = capture.id
                quickCapture.content = capture.content
                quickCapture.summary = capture.summary
                quickCapture.category = capture.category
                quickCapture.created_at = capture.created_at

                quickCapture.quizzes.removeAll()
                for quiz in capture.quizzes {
                    let quizObject = Quiz(context: context)
                    quizObject.id = quiz.id
                    quizObject.question = quiz.question
                    quizObject.choices = quiz.choices
                    quizObject.correct_answer = quiz.correct_answer
                    quizObject.quiz_type = quiz.quiz_type
                    quickCapture.quizzes.insert(quizObject)
                }
            } catch {
                print("❌ Error fetching QuickCapture: \(error)")
            }
        }

        PersistenceController.shared.save()
    }
}
