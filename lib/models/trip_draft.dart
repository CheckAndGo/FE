class TripDraft {
  String? country;
  String? city;
  DateTime? startDate;
  DateTime? endDate;

  int? people;
  String? budget;
  String? tripName;
  String? purpose;

  String? stayType;
  String? transport;

  TripDraft({
    this.country,
    this.city,
    this.startDate,
    this.endDate,
    this.people,
    this.budget,
    this.tripName,
    this.purpose,
    this.stayType,
    this.transport,
  });

  TripDraft copyWith({
    String? country,
    String? city,
    DateTime? startDate,
    DateTime? endDate,
    int? people,
    String? budget,
    String? tripName,
    String? purpose,
    String? stayType,
    String? transport,
  }) {
    return TripDraft(
      country: country ?? this.country,
      city: city ?? this.city,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      people: people ?? this.people,
      budget: budget ?? this.budget,
      tripName: tripName ?? this.tripName,
      purpose: purpose ?? this.purpose,
      stayType: stayType ?? this.stayType,
      transport: transport ?? this.transport,
    );
  }
}
