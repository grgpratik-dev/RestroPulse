enum ApiErrorType {
  cancelled,
  connection,
  timeout,
  badCertificate,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  methodNotAllowed,
  conflict,
  unsupportedMediaType,
  validation,
  tooManyRequests,
  client,
  server,
  parsing,
  unknown,
}

// global application status
enum AppStatus { initializing, onboarding, unauthenticated, authenticated }
