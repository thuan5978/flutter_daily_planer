class Task {
  String? title;
  String? content;
  String? dateCreated;
  String? location;
  String? startTime;
  String? endTime;   
  String? endDate;
  String? host;
  String? note;
  String? userCreated;

  Task({
    this.title,
    this.content,
    this.dateCreated,
    this.location,
    this.startTime,
    this.endTime,
    this.endDate, 
    this.host,
    this.note,
    this.userCreated,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['Title'],
      content: json['Content'],
      dateCreated: json['DateCreated'],
      location: json['Location'],
      startTime: json['StartTime'],
      endTime: json['EndTime'],
      endDate: json['EndDate'],
      host: json['Host'],
      note: json['Notes'],
      userCreated: json['UserCreated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Content': content,
      'DateCreated': dateCreated,
      'Location': location,
      'StartTime': startTime,
      'EndTime': endTime,
      'EndDate': endDate, 
      'Host': host,
      'Notes': note,
      'UserCreated': userCreated,
    };
  }
}
