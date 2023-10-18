

enum SnackBarType {
  error,
  success,
  unconnected,
  info,
}

enum PostStatus {
  feedPost,
  deletedPost,
  archivedPost,
}

enum ActionNotification {
  chatMessage,
  notification,
  startChat,
  feedback,

  friendRequest,
}

enum ActionCreatePost {
  gallery,
  camera,
  text,
}

enum SearchFrom {
  messagesScreen,
  homeScreen,
  createStoryScreen,
}

enum BookingState {
  waiting,
  accepted,
  canceled,
  completed,
}

enum LayoutMode {
  defaultLayout,
  full,
  hostTopCenter,
  hostCenter,
}

enum ActionSelect {
  gallery,
  camera,
}

enum RequestState {
  init,
  loading,
  loaded,
  network,
  error,
  logout,
}

enum Genders {
  male(0, 'male'),
  female(1, 'female'),
  other(2, 'other');
  final int id;
  final String value;
  const Genders(this.id, this.value);
}