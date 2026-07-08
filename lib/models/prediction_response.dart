class PredictionResponse {
  final String prediction;
  final int classValue;
  final double probability;
  final String confidence;
  final double threshold;

  PredictionResponse({
    required this.prediction,
    required this.classValue,
    required this.probability,
    required this.confidence,
    required this.threshold,
  });

  factory PredictionResponse.fromJson(Map<String, dynamic> json) {
    return PredictionResponse(
      prediction: json['prediction'] as String,
      classValue: (json['class'] ?? json['classValue'] ?? 0) as int,
      probability: (json['probability'] as num).toDouble(),
      confidence: json['confidence'] as String,
      threshold: (json['threshold'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prediction': prediction,
      'class': classValue,
      'probability': probability,
      'confidence': confidence,
      'threshold': threshold,
    };
  }
}
