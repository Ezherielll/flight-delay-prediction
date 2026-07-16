class InfoCenterData {
  InfoCenterData({
    required this.about,
    required this.classification,
    required this.airlines,
    required this.airports,
    required this.weatherParameters,
    required this.weatherSeverity,
    required this.predictionGuide,
    required this.mlModels,
    required this.featureImportance,
    required this.faq,
    required this.workflow,
    required this.glossary,
  });

  factory InfoCenterData.fromJson(Map<String, dynamic> json) {
    return InfoCenterData(
      about: AboutInfo.fromJson(json['about'] as Map<String, dynamic>),
      classification: ClassificationInfo.fromJson(json['classification'] as Map<String, dynamic>),
      airlines: (json['airlines'] as List<dynamic>)
          .map((e) => AirlineRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      airports: (json['airports'] as List<dynamic>)
          .map((e) => AirportRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      weatherParameters: (json['weather_parameters'] as List<dynamic>)
          .map((e) => WeatherParam.fromJson(e as Map<String, dynamic>))
          .toList(),
      weatherSeverity: WeatherSeverity.fromJson(json['weather_severity'] as Map<String, dynamic>),
      predictionGuide: PredictionGuide.fromJson(json['prediction_guide'] as Map<String, dynamic>),
      mlModels: (json['ml_models'] as List<dynamic>)
          .map((e) => MlModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      featureImportance: FeatureImportanceInfo.fromJson(json['feature_importance'] as Map<String, dynamic>),
      faq: (json['faq'] as List<dynamic>)
          .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      workflow: (json['workflow'] as List<dynamic>)
          .map((e) => WorkflowStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      glossary: (json['glossary'] as List<dynamic>)
          .map((e) => GlossaryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final AboutInfo about;
  final ClassificationInfo classification;
  final List<AirlineRef> airlines;
  final List<AirportRef> airports;
  final List<WeatherParam> weatherParameters;
  final WeatherSeverity weatherSeverity;
  final PredictionGuide predictionGuide;
  final List<MlModel> mlModels;
  final FeatureImportanceInfo featureImportance;
  final List<FaqItem> faq;
  final List<WorkflowStep> workflow;
  final List<GlossaryItem> glossary;
}

class AboutInfo {
  AboutInfo({
    required this.purpose,
    required this.importance,
    required this.mlUsage,
    required this.dataSources,
  });

  factory AboutInfo.fromJson(Map<String, dynamic> json) {
    return AboutInfo(
      purpose: json['purpose'] as String,
      importance: json['importance'] as String,
      mlUsage: json['ml_usage'] as String,
      dataSources: List<String>.from(json['data_sources'] as List<dynamic>),
    );
  }

  final String purpose;
  final String importance;
  final String mlUsage;
  final List<String> dataSources;
}

class ClassificationInfo {
  ClassificationInfo({
    required this.onTime,
    required this.delay,
    required this.definition,
  });

  factory ClassificationInfo.fromJson(Map<String, dynamic> json) {
    return ClassificationInfo(
      onTime: json['on_time'] as String,
      delay: json['delay'] as String,
      definition: json['definition'] as String,
    );
  }

  final String onTime;
  final String delay;
  final String definition;
}

class AirlineRef {
  AirlineRef({
    required this.code,
    required this.name,
    required this.country,
  });

  factory AirlineRef.fromJson(Map<String, dynamic> json) {
    return AirlineRef(
      code: json['code'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
    );
  }

  final String code;
  final String name;
  final String country;
}

class AirportRef {
  AirportRef({
    required this.iata,
    required this.name,
    required this.city,
    required this.country,
  });

  factory AirportRef.fromJson(Map<String, dynamic> json) {
    return AirportRef(
      iata: json['iata'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }

  final String iata;
  final String name;
  final String city;
  final String country;
}

class WeatherParam {
  WeatherParam({
    required this.name,
    required this.unit,
    required this.description,
    required this.impact,
  });

  factory WeatherParam.fromJson(Map<String, dynamic> json) {
    return WeatherParam(
      name: json['name'] as String,
      unit: json['unit'] as String,
      description: json['description'] as String,
      impact: json['impact'] as String,
    );
  }

  final String name;
  final String unit;
  final String description;
  final String impact;
}

class WeatherSeverity {
  WeatherSeverity({
    required this.visibility,
    required this.windSpeed,
    required this.rain,
  });

  factory WeatherSeverity.fromJson(Map<String, dynamic> json) {
    return WeatherSeverity(
      visibility: (json['visibility'] as List<dynamic>)
          .map((e) => SeverityBand.fromJson(e as Map<String, dynamic>))
          .toList(),
      windSpeed: (json['wind_speed'] as List<dynamic>)
          .map((e) => SeverityBand.fromJson(e as Map<String, dynamic>))
          .toList(),
      rain: (json['rain'] as List<dynamic>)
          .map((e) => SeverityBand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<SeverityBand> visibility;
  final List<SeverityBand> windSpeed;
  final List<SeverityBand> rain;
}

class SeverityBand {
  SeverityBand({
    required this.level,
    required this.range,
    required this.description,
  });

  factory SeverityBand.fromJson(Map<String, dynamic> json) {
    return SeverityBand(
      level: json['level'] as String,
      range: json['range'] as String,
      description: json['description'] as String,
    );
  }

  final String level;
  final String range;
  final String description;
}

class PredictionGuide {
  PredictionGuide({
    required this.onTimeMeaning,
    required this.delayMeaning,
    required this.confidenceExpl,
  });

  factory PredictionGuide.fromJson(Map<String, dynamic> json) {
    return PredictionGuide(
      onTimeMeaning: json['on_time_meaning'] as String,
      delayMeaning: json['delay_meaning'] as String,
      confidenceExpl: json['confidence_expl'] as String,
    );
  }

  final String onTimeMeaning;
  final String delayMeaning;
  final String confidenceExpl;
}

class MlModel {
  MlModel({
    required this.name,
    required this.advantages,
  });

  factory MlModel.fromJson(Map<String, dynamic> json) {
    return MlModel(
      name: json['name'] as String,
      advantages: List<String>.from(json['advantages'] as List<dynamic>),
    );
  }

  final String name;
  final List<String> advantages;
}

class FeatureImportanceInfo {
  FeatureImportanceInfo({
    required this.intro,
    required this.topFeatures,
  });

  factory FeatureImportanceInfo.fromJson(Map<String, dynamic> json) {
    return FeatureImportanceInfo(
      intro: json['intro'] as String,
      topFeatures: (json['top_features'] as List<dynamic>)
          .map((e) => FeatureWeight.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String intro;
  final List<FeatureWeight> topFeatures;
}

class FeatureWeight {
  FeatureWeight({
    required this.feature,
    required this.impact,
  });

  factory FeatureWeight.fromJson(Map<String, dynamic> json) {
    return FeatureWeight(
      feature: json['feature'] as String,
      impact: json['impact'] as String,
    );
  }

  final String feature;
  final String impact;
}

class FaqItem {
  FaqItem({
    required this.question,
    required this.answer,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  final String question;
  final String answer;
}

class WorkflowStep {
  WorkflowStep({
    required this.step,
    required this.name,
    required this.desc,
  });

  factory WorkflowStep.fromJson(Map<String, dynamic> json) {
    return WorkflowStep(
      step: json['step'] as String,
      name: json['name'] as String,
      desc: json['desc'] as String,
    );
  }

  final String step;
  final String name;
  final String desc;
}

class GlossaryItem {
  GlossaryItem({
    required this.term,
    required this.definition,
  });

  factory GlossaryItem.fromJson(Map<String, dynamic> json) {
    return GlossaryItem(
      term: json['term'] as String,
      definition: json['definition'] as String,
    );
  }

  final String term;
  final String definition;
}
