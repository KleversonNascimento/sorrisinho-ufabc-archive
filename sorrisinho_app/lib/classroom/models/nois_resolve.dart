class NoisResolve {
  final String text;
  final String link;

  const NoisResolve({
    required this.text,
    required this.link,
  });

  factory NoisResolve.fromJson(Map<String, dynamic> json) {
    return NoisResolve(
      text: json['text'],
      link: json['link'],
    );
  }
}
