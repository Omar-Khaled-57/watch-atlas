enum MediaType {
  movie,
  tv,
  anime,
  kdrama,
  cdrama,
  jdrama,
  thaiDrama,
  asianDrama,
  egyptianMovie,
  egyptianSeries,
  arabicMovie,
  arabicSeries,
  documentary,
  webSeries,
  custom,
}

enum WatchStatus {
  watching,
  completed,
  onHold,
  dropped,
  planToWatch,
  rewatching,
}

enum MediaListType {
  public,
  private,
  collaborative,
}

enum UserRole {
  user,
  moderator,
  admin,
}

enum ReportReason {
  spam,
  inappropriate,
  copyright,
  incorrect,
  other,
}

enum SyncOperation {
  create,
  update,
  delete,
}

enum NotificationType {
  newSeason,
  newEpisode,
  friendFollow,
  listUpdate,
  review,
  comment,
  recommendation,
}
