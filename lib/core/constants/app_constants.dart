/// Application Constants
class AppConstants {
  // Storage Keys
  static const String idTokenKey = 'id_token';
  static const String usernameKey = 'username';
  static const String userTopicKey = 'user_topic';
  static const String pendingGoogleUsernameKey = 'pending_google_username';
  static const String pendingGoogleTopicKey = 'pending_google_topic';
  
  // Topic Options
  static const List<Map<String, String>> topicOptions = [
    {'value': '', 'label': 'Select a topic'},
    {'value': 'Cloud', 'label': 'Cloud'},
    {'value': 'AI', 'label': 'AI'},
    {'value': 'Full Stack', 'label': 'Full Stack'},
    {'value': 'Testing', 'label': 'Testing'}
  ];
  
  // Validation
  static const int minUsernameLength = 3;
  static const int minPasswordLength = 8;
  
  // Razorpay
  static String get razorpayKeyId => const String.fromEnvironment(
    'RAZORPAY_KEY_ID',
    defaultValue: 'rzp_test_RbvMQRpHT3gMcN'
  );
}
