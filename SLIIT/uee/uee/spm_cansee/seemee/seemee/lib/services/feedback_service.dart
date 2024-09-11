class FeedbackService {
  String _feedback = '';

  String get feedback => _feedback;

  void createFeedback(String feedback) {
    _feedback = feedback;
  }

  void updateFeedback(String updatedFeedback) {
    _feedback = updatedFeedback;
  }

  void deleteFeedback() {
    _feedback = '';
  }

  bool hasFeedback() {
    return _feedback.isNotEmpty;
  }
}
