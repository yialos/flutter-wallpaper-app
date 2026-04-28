/// Unsplash API configuration
class UnsplashConfig {
  // TODO: Replace with your actual Unsplash Access Key
  static const String accessKey = '56cP77x2DIqw5hhr6yTEXGAqcYzCE0bS-zxc6qLj8SM';

  // Unsplash API endpoints
  static const String photosEndpoint = '/photos';
  static const String searchEndpoint = '/search/photos';
  static const String randomEndpoint = '/photos/random';

  // Default parameters
  static const int defaultPerPage = 20;
  static const String defaultOrientation = 'portrait';
}
