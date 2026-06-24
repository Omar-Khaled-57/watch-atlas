// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'WatchAtlas';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingMore => 'Loading more...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get noInternet => 'No internet connection';

  @override
  String get pullToRefresh => 'Pull to refresh';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navSearch => 'Search';

  @override
  String get navLists => 'Lists';

  @override
  String get navProfile => 'Profile';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get createAccount => 'Create Account';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get trendingNow => 'Trending Now';

  @override
  String get popularThisWeek => 'Popular This Week';

  @override
  String get continueWatching => 'Continue Watching';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get upcomingReleases => 'Upcoming Releases';

  @override
  String get recommendedForYou => 'Recommended for You';

  @override
  String get seeAll => 'See All';

  @override
  String get movies => 'Movies';

  @override
  String get tvShows => 'TV Shows';

  @override
  String get anime => 'Anime';

  @override
  String get kdrama => 'K-Drama';

  @override
  String get ratings => 'Ratings';

  @override
  String get overview => 'Overview';

  @override
  String get cast => 'Cast';

  @override
  String get crew => 'Crew';

  @override
  String get trailers => 'Trailers';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get reviews => 'Reviews';

  @override
  String get similar => 'Similar';

  @override
  String get addToList => 'Add to List';

  @override
  String get share => 'Share';

  @override
  String get mediaType => 'Media Type';

  @override
  String get releaseDate => 'Release Date';

  @override
  String get runtime => 'Runtime';

  @override
  String get genres => 'Genres';

  @override
  String get status => 'Status';

  @override
  String get language => 'Language';

  @override
  String get country => 'Country';

  @override
  String get watching => 'Watching';

  @override
  String get completed => 'Completed';

  @override
  String get onHold => 'On Hold';

  @override
  String get dropped => 'Dropped';

  @override
  String get planToWatch => 'Plan to Watch';

  @override
  String get rewatching => 'Rewatching';

  @override
  String get myTracking => 'My Tracking';

  @override
  String get totalWatched => 'Total Watched';

  @override
  String get totalEpisodes => 'Total Episodes';

  @override
  String get totalHours => 'Total Hours';

  @override
  String get progress => 'Progress';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get addToTracking => 'Add to Tracking';

  @override
  String get removeFromTracking => 'Remove from Tracking';

  @override
  String trackingCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count titles',
      one: '$count title',
    );
    return '$_temp0';
  }

  @override
  String episodeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count episodes',
      one: '$count episode',
    );
    return '$_temp0';
  }

  @override
  String get myLists => 'My Lists';

  @override
  String get createList => 'Create List';

  @override
  String get listTitle => 'List Title';

  @override
  String get listDescription => 'List Description';

  @override
  String get publicList => 'Public';

  @override
  String get privateList => 'Private';

  @override
  String get collaborative => 'Collaborative';

  @override
  String addToListTitle(Object title) {
    return 'Add $title to List';
  }

  @override
  String get noListsYet => 'No lists yet';

  @override
  String get createFirstList => 'Create your first list';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get bio => 'Bio';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

  @override
  String get activity => 'Activity';

  @override
  String get stats => 'Stats';

  @override
  String joinedOn(Object date) {
    return 'Joined on $date';
  }

  @override
  String get findFriends => 'Find Friends';

  @override
  String get follow => 'Follow';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get friendActivity => 'Friend Activity';

  @override
  String get noFriendsYet => 'No friends yet';

  @override
  String get suggestedFriends => 'Suggested Friends';

  @override
  String get searchHint => 'Search movies, shows, anime...';

  @override
  String get searchHistory => 'Search History';

  @override
  String get trendingSearches => 'Trending Searches';

  @override
  String get noResults => 'No results found';

  @override
  String get filters => 'Filters';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get searchResults => 'Search Results';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark All Read';

  @override
  String get clearAll => 'Clear All';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String notificationFollow(Object name) {
    return '$name started following you';
  }

  @override
  String notificationLike(Object name) {
    return '$name liked your review';
  }

  @override
  String notificationComment(Object name) {
    return '$name commented on your review';
  }

  @override
  String notificationList(Object name) {
    return '$name added you to a list';
  }

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get contentLanguage => 'Content Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System Mode';

  @override
  String get about => 'About';

  @override
  String get appVersion => 'App Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get licenses => 'Licenses';

  @override
  String get rateApp => 'Rate App';

  @override
  String get shareApp => 'Share App';

  @override
  String get logout => 'Log Out';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get statistics => 'Statistics';

  @override
  String get yourStats => 'Your Stats';

  @override
  String get totalWatchedCount => 'Total Watched';

  @override
  String get totalHoursCount => 'Total Hours';

  @override
  String get averageRating => 'Average Rating';

  @override
  String get genreDistribution => 'Genre Distribution';

  @override
  String get weeklyActivity => 'Weekly Activity';

  @override
  String get monthlyActivity => 'Monthly Activity';

  @override
  String get favoriteGenre => 'Favorite Genre';

  @override
  String get favoriteCountry => 'Favorite Country';

  @override
  String get mostWatchedGenre => 'Most Watched Genre';

  @override
  String get topRated => 'Top Rated';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object minutes) {
    return '${minutes}m ago';
  }

  @override
  String hoursAgo(Object hours) {
    return '${hours}h ago';
  }

  @override
  String daysAgo(Object days) {
    return '${days}d ago';
  }

  @override
  String weeksAgo(Object weeks) {
    return '${weeks}w ago';
  }

  @override
  String monthsAgo(Object months) {
    return '${months}mo ago';
  }

  @override
  String yearsAgo(Object years) {
    return '${years}y ago';
  }
}
