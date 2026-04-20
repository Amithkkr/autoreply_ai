import 'package:dio/dio.dart';

import 'package:autoreply_ai/ui/review/review_models.dart';

class OpenAIReplyService {
  OpenAIReplyService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://api.openai.com/v1',
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
              headers: {'Content-Type': 'application/json'},
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 20),
            ),
          );

  final Dio _dio;

  static const String _apiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const String _model = String.fromEnvironment(
    'OPENAI_MODEL',
    defaultValue: 'gpt-4o-mini',
  );

  bool get isConfigured => _apiKey.trim().isNotEmpty;

  Future<String?> generateReply({
    required String reviewText,
    required ReplyTone tone,
    String? companyName,
  }) async {
    if (!isConfigured) return null;

    final toneLabel = switch (tone) {
      ReplyTone.friendly => 'friendly',
      ReplyTone.professional => 'professional',
      ReplyTone.casual => 'casual',
    };

    final business = (companyName == null || companyName.trim().isEmpty)
        ? 'the business'
        : companyName.trim();

    final systemPrompt =
        'You are a customer support reply writer for $business. '
        'Write concise, human-like public responses to customer reviews. '
        'Use a $toneLabel tone. '
        'Rules: 2-4 sentences, empathetic, no fake promises, no markdown, no emojis.';

    final userPrompt =
        'Customer review:\n$reviewText\n\nWrite a response that acknowledges the review and, if needed, apologizes or thanks clearly.';

    final response = await _dio.post<Map<String, dynamic>>(
      '/chat/completions',
      data: {
        'model': _model,
        'temperature': 0.7,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
      },
      options: Options(headers: {'Authorization': 'Bearer $_apiKey'}),
    );

    final data = response.data;
    if (data == null) return null;
    final choices = data['choices'];
    if (choices is! List || choices.isEmpty) return null;

    final first = choices.first;
    if (first is! Map<String, dynamic>) return null;
    final message = first['message'];
    if (message is! Map<String, dynamic>) return null;
    final content = message['content'];

    if (content is String && content.trim().isNotEmpty) {
      return content.trim();
    }

    if (content is List) {
      final buffer = StringBuffer();
      for (final part in content) {
        if (part is Map<String, dynamic>) {
          final text = part['text'];
          if (text is String) buffer.write(text);
        }
      }
      final text = buffer.toString().trim();
      if (text.isNotEmpty) return text;
    }

    return null;
  }

  String buildFallbackReply({required String review, required ReplyTone tone}) {
    final safeReview = review.toLowerCase();
    final mentionsIssue =
        safeReview.contains('issue') ||
        safeReview.contains('bad') ||
        safeReview.contains('damaged') ||
        safeReview.contains('late');

    switch (tone) {
      case ReplyTone.friendly:
        if (mentionsIssue) {
          return 'Thanks for sharing this with us. We are really sorry the experience was not smooth this time. We are already looking into it and will do better on your next visit.';
        }
        return 'Thank you so much for the lovely review. We are happy you had a great experience and we cannot wait to serve you again.';
      case ReplyTone.professional:
        if (mentionsIssue) {
          return 'Thank you for your feedback. We apologize for the inconvenience and appreciate you bringing this to our attention. Our team is taking corrective action to prevent this issue in the future.';
        }
        return 'Thank you for your positive review. We appreciate your trust and are pleased to know our service met your expectations.';
      case ReplyTone.casual:
        if (mentionsIssue) {
          return 'Thanks for the honest feedback. Sorry this one was not perfect. We are fixing it and will make sure your next experience is much better.';
        }
        return 'Thanks a lot for the shoutout. Glad you enjoyed it. See you again soon.';
    }
  }
}
