class ResultType {
  ResultType(this.name);

  static ResultType criticalFailure = ResultType('Critical Failure');
  static ResultType failure = ResultType('Failure');
  static ResultType success = ResultType('Success');
  static ResultType criticalSuccess = ResultType('Critical Success');

  static Map<String, ResultType> _values = {
    criticalFailure.name: criticalFailure,
    failure.name: failure,
    success.name: success,
    criticalSuccess.name: criticalSuccess,
  };

  final String name;

  static ResultType fromString(String name) => _values[name];
}
