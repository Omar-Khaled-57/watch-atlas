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
  String get appearance => 'Appearance';

  @override
  String get account => 'Account';

  @override
  String get userProfile => 'User Profile';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get profileNotFound => 'Profile not found';

  @override
  String get changePassword => 'Change Password';

  @override
  String get moderation => 'Moderation';

  @override
  String get recommendationsAndPrivacy => 'Recommendations & Privacy';

  @override
  String get personalizedRecommendations => 'Personalized Recommendations';

  @override
  String get clearRecommendationHistory => 'Clear Recommendation History';

  @override
  String get removeAllBehavioralData => 'Remove all behavioral data';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get followSystem => 'Follow system settings';

  @override
  String get displayName => 'Display Name';

  @override
  String get username => 'Username';

  @override
  String get age => 'Age';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get ratherNotSay => 'Rather not say';

  @override
  String get viewTracking => 'View Tracking';

  @override
  String get viewAnalytics => 'View Analytics';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String get sendResetLink => 'Send Reset Link';

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

  @override
  String get termsOfServiceTitle => 'Terms of Service';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get termsOfServiceBody =>
      'By using WatchAtlas, you agree to these terms. Please read them carefully.\n\n[Full terms would go here]';

  @override
  String get privacyPolicyBody =>
      'Your privacy matters to us.\n\n[Full privacy policy would go here]';

  @override
  String get lastUpdated => 'Last updated: June 26, 2026';

  @override
  String get acceptanceOfTerms => '1. Acceptance of Terms';

  @override
  String get acceptanceOfTermsBody =>
      'By accessing or using Watch Atlas, you agree to be bound by these Terms of Service. If you do not agree, do not use the service.';

  @override
  String get descriptionOfService => '2. Description of Service';

  @override
  String get descriptionOfServiceBody =>
      'Watch Atlas is a media tracking application that allows users to discover, track, and organize movies, TV shows, and anime. Users can rate, review, and maintain watch lists.';

  @override
  String get userAccounts => '3. User Accounts';

  @override
  String get userAccountsBody =>
      'You must sign in via Google OAuth to use the service. You are responsible for maintaining the confidentiality of your account. You must be at least 13 years old to use this service.';

  @override
  String get userConduct => '4. User Conduct';

  @override
  String get userConductBody =>
      'You agree not to: post abusive, harassing, or inappropriate content; impersonate others; attempt to circumvent security measures; use the service for any illegal purpose.';

  @override
  String get intellectualProperty => '5. Intellectual Property';

  @override
  String get intellectualPropertyBody =>
      'Media metadata and images are provided by TMDB and AniList under their respective licenses. The Watch Atlas application and code are proprietary. User-generated content (reviews, ratings) remains owned by you, with a license granted to Watch Atlas to display it within the service.';

  @override
  String get limitationOfLiability => '6. Limitation of Liability';

  @override
  String get limitationOfLiabilityBody =>
      'Watch Atlas is provided as is without warranties of any kind. We are not responsible for the accuracy of third-party metadata. We reserve the right to modify or discontinue the service at any time.';

  @override
  String get termination => '7. Termination';

  @override
  String get terminationBody =>
      'We reserve the right to suspend or terminate accounts that violate these terms. You may delete your account at any time.';

  @override
  String get changesToTerms => '8. Changes to Terms';

  @override
  String get changesToTermsBody =>
      'We may update these terms at any time. Continued use after changes constitutes acceptance. Users will be notified of material changes via email or in-app notification.';

  @override
  String get contactSection => '9. Contact';

  @override
  String get contactLegal =>
      'For questions about these terms, contact: legal@watchatlas.app';

  @override
  String get contactPrivacy =>
      'For privacy-related inquiries, contact: privacy@watchatlas.app';

  @override
  String get informationWeCollect => '1. Information We Collect';

  @override
  String get informationWeCollectBody =>
      'When you sign in with Google OAuth, we collect your email address and display name. We also store media you track (movies, TV shows, anime) along with your watch status, ratings, and reviews. Profile avatars and display names are stored via Supabase storage.';

  @override
  String get howWeUseInfo => '2. How We Use Your Information';

  @override
  String get howWeUseInfoBody =>
      'Your information is used to provide and improve the service: personalize your experience, maintain your watch lists and reviews, generate analytics based on your tracked media, and communicate service updates if necessary.';

  @override
  String get dataStorage => '3. Data Storage & Security';

  @override
  String get dataStorageBody =>
      'Your data is stored securely on Supabase (PostgreSQL) and Google Cloud infrastructure. We use Row Level Security to ensure you can only access your own data. Passwords are never stored — authentication is handled entirely by Google OAuth.';

  @override
  String get thirdPartyServices => '4. Third-Party Services';

  @override
  String get thirdPartyServicesBody =>
      'We use TMDB (The Movie Database) to fetch media metadata. Your searches and viewed media IDs are sent to TMDB\'s API. We also use AniList for anime metadata. Google OAuth is used for authentication.';

  @override
  String get dataRetention => '5. Data Retention';

  @override
  String get dataRetentionBody =>
      'Your data is retained for as long as your account is active. You may delete your account and associated data at any time by contacting us.';

  @override
  String get yourRights => '6. Your Rights';

  @override
  String get yourRightsBody =>
      'You may request a copy of your data, correction of inaccurate data, or deletion of your account and associated data. Contact us at the email below.';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseConfirmPassword => 'Please confirm your password';

  @override
  String get enterEmailForReset =>
      'Enter your email to receive a password reset link';

  @override
  String get backToSignIn => 'Back to Sign In';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get setUpProfile => 'Set up your profile';

  @override
  String get chooseAvatar => 'Choose an avatar';

  @override
  String get uploadPhoto => 'Upload a photo';

  @override
  String get orPickDefault => 'Or pick one of the defaults below';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get selectDateOfBirth => 'Select your date of birth';

  @override
  String get completeSetup => 'Complete Setup';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get mustBe13 => 'You must be at least 13 years old to use this app';

  @override
  String get failedToSaveProfile => 'Failed to save profile';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get pleaseConfirmEmail => 'Please confirm your email address';

  @override
  String get accountAlreadyExists =>
      'An account with this email already exists';

  @override
  String get chooseAccount => 'Choose an account';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get signInToGoogle => 'Sign in to a Google account';

  @override
  String get previouslyUsed => 'Previously used';

  @override
  String get signInTo => 'Sign in to';

  @override
  String get tryAnotherAccount => 'Try another account';

  @override
  String get useDifferentGoogleAccount => 'Use a different Google account';

  @override
  String get couldNotLoadContinueWatching => 'Could not load continue watching';

  @override
  String get noContentInProgress => 'No content in progress';

  @override
  String get searchMoviesTv => 'Search movies, TV shows...';

  @override
  String get searchFailed => 'Search failed';

  @override
  String get discover => 'Discover';

  @override
  String get tryAdjustingFilters => 'Try adjusting your filters';

  @override
  String get searchMoviesTvAnime => 'Search movies, TV shows, anime...';

  @override
  String get advancedFilters => 'Advanced Filters';

  @override
  String get allCountries => 'All Countries';

  @override
  String get yearRange => 'Year Range';

  @override
  String get ratingRange => 'Rating Range';

  @override
  String get reset => 'Reset';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get failedToLoadDetails => 'Failed to load details';

  @override
  String get writeReview => 'Write Review';

  @override
  String get noReviewsYet => 'No reviews yet. Be the first to review!';

  @override
  String get failedToLoadReviews => 'Failed to load reviews';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get createNewList => 'Create New List';

  @override
  String get addedTo => 'Added to';

  @override
  String addedToTitle(String title) {
    return 'Added to \"$title\"';
  }

  @override
  String get listCreated => 'List created';

  @override
  String get removeFromTrackingList => 'Remove from this list';

  @override
  String get tracking => 'Tracking';

  @override
  String get recentlyUpdated => 'Recently Updated';

  @override
  String get noMediaInList => 'No media in this list';

  @override
  String get failedToLoadTracking => 'Failed to load tracking data';

  @override
  String get myCollections => 'My Collections';

  @override
  String get allCollections => 'All Collections';

  @override
  String get selectList => 'Select a list';

  @override
  String get chooseListFromSidebar =>
      'Choose a list from the sidebar to view its contents';

  @override
  String get yourCollections => 'Your Collections';

  @override
  String get allItems => 'All Items';

  @override
  String get noItemsInList => 'No items in this list';

  @override
  String get addMediaFromDetails => 'Add media from the details page';

  @override
  String get noOtherListsToMoveTo => 'No other lists to move to';

  @override
  String get noOtherListsToCopyTo => 'No other lists to copy to';

  @override
  String get moveTo => 'Move to...';

  @override
  String get copyTo => 'Copy to...';

  @override
  String get movedTo => 'Moved to';

  @override
  String get copiedTo => 'Copied to';

  @override
  String get removedFromList => 'Removed from list';

  @override
  String get toggleView => 'Toggle view';

  @override
  String get searchItems => 'Search items...';

  @override
  String get failedToLoadList => 'Failed to load list';

  @override
  String get listNotFound => 'List not found';

  @override
  String get listCouldNotBeFound => 'This list could not be found';

  @override
  String checkOutMyList(Object title) {
    return 'Check out my list: $title on WatchAtlas';
  }

  @override
  String get failedToLoadItems => 'Failed to load items';

  @override
  String get enterListName => 'Enter list name';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get describeList => 'Describe this list';

  @override
  String get anyoneCanSee => 'Anyone can see this list';

  @override
  String get onlyYouCanSee => 'Only you can see this list';

  @override
  String get othersCanAddRemove => 'Others can add and remove items';

  @override
  String get noItemsMatch => 'No items match';

  @override
  String get across => 'Across';

  @override
  String deleteListConfirm(Object title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get deleteListWarning =>
      'This will permanently remove the list and all media entries it contains. This action cannot be undone.';

  @override
  String get listDeleted => 'deleted';

  @override
  String get community => 'Community';

  @override
  String get failedToLoadFollowing => 'Failed to load following';

  @override
  String get notFollowingAnyone => 'Not following anyone';

  @override
  String get findFriendsToFollow =>
      'Find friends to follow and see their activity.';

  @override
  String get failedToLoadFollowers => 'Failed to load followers';

  @override
  String get noFollowersYet => 'No followers yet';

  @override
  String get whenSomeoneFollowsYou =>
      'When someone follows you, they will appear here.';

  @override
  String get failedToLoadActivity => 'Failed to load activity';

  @override
  String get noFriendActivity => 'No friend activity';

  @override
  String get activityFromPeopleYouFollow =>
      'Activity from people you follow will appear here.';

  @override
  String get searchByUsername => 'Search by username...';

  @override
  String get failedToLoadNotifications => 'Failed to load notifications';

  @override
  String get youreAllCaughtUp => 'You\'re all caught up!';

  @override
  String get clearAllNotificationsConfirm => 'Clear all notifications?';

  @override
  String get clearAllWarning =>
      'This action cannot be undone. All notifications will be permanently deleted.';

  @override
  String get unknown => 'Unknown';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get noModeratorPermissions => 'You do not have moderator permissions.';

  @override
  String get reports => 'Reports';

  @override
  String get failedToLoadReports => 'Failed to load reports';

  @override
  String get noPendingReports => 'No pending reports';

  @override
  String get allClear => 'All clear!';

  @override
  String get reportedUser => 'Reported User';

  @override
  String get mediaId => 'Media ID';

  @override
  String get reporter => 'Reporter';

  @override
  String get takeAction => 'Take Action';

  @override
  String get warnUser => 'Warn User';

  @override
  String get sendWarningToUser => 'Send a warning to the user';

  @override
  String get hideContent => 'Hide Content';

  @override
  String get makeContentInvisible => 'Make content invisible to users';

  @override
  String get deleteContent => 'Delete Content';

  @override
  String get permanentlyRemoveContent => 'Permanently remove this content';

  @override
  String get confirmDeletion => 'Confirm Deletion';

  @override
  String get confirmDeleteContent =>
      'Are you sure you want to permanently delete this content?';

  @override
  String get banUser => 'Ban User';

  @override
  String get permanentlyBanUser =>
      'Permanently ban this user from the platform';

  @override
  String get confirmBan => 'Confirm Ban';

  @override
  String get confirmBanUser =>
      'Are you sure you want to permanently ban this user?';

  @override
  String get ban => 'Ban';

  @override
  String get users => 'Users';

  @override
  String get failedToLoadUsers => 'Failed to load users';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get staff => 'Staff';

  @override
  String get roleUser => 'USER';

  @override
  String get roleModerator => 'MODERATOR';

  @override
  String get roleAdmin => 'ADMIN';

  @override
  String get failedToLoadStats => 'Failed to load stats';

  @override
  String get yearlyActivity => 'Yearly Activity';

  @override
  String get countryDistribution => 'Country Distribution';

  @override
  String get ratingDistribution => 'Rating Distribution';

  @override
  String get avgRating => 'Avg Rating';

  @override
  String get mostWatchedDecade => 'Most Watched Decade';

  @override
  String get noDataAvailable => 'No data available yet';

  @override
  String get other => 'Other';

  @override
  String get totalItems => 'Total Items';

  @override
  String get splashSubtitle => 'Your global watch list';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get enterDisplayName => 'Enter your display name';

  @override
  String get displayNameMax50 => 'Display name must be 50 characters or less';

  @override
  String get tellOthersAboutYourself => 'Tell others about yourself';

  @override
  String get bioMax500 => 'Bio must be 500 characters or less';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get confirm => 'Confirm';

  @override
  String get continueAction => 'Continue';

  @override
  String get remove => 'Remove';

  @override
  String get rename => 'Rename';

  @override
  String get move => 'Move';

  @override
  String get copy => 'Copy';

  @override
  String get create => 'Create';

  @override
  String get name => 'Name';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get visibility => 'Visibility';

  @override
  String get type => 'Type';

  @override
  String get tryAgain => 'Try again';

  @override
  String get items => 'items';

  @override
  String get item => 'item';

  @override
  String get noResultsForSearch => 'No results';

  @override
  String get tryDifferentSearchTerm => 'Try a different search term';

  @override
  String get watchingBadge => 'WATCHING';

  @override
  String get completedBadge => 'DONE';

  @override
  String get onHoldBadge => 'HOLD';

  @override
  String get droppedBadge => 'DROP';

  @override
  String get planToWatchBadge => 'PLAN';

  @override
  String get rewatchingBadge => 'REWATCH';

  @override
  String removeListTitle(String title) {
    return 'Remove \"$title\"?';
  }

  @override
  String get removeFromListWarning =>
      'This will remove the item from this list.';

  @override
  String get clearActivityWarning =>
      'This will remove all your activity data used for recommendations. Continue?';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get deleteAccountWarning =>
      'This action is permanent and cannot be undone. All your data will be deleted.';

  @override
  String get aboutAppDescription =>
      'A modern media tracking platform to discover, track, and share your favorite movies, TV shows, and more.';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get inYourList => 'In Your List';

  @override
  String get inYourLibrary => 'In Your Library';

  @override
  String get addedLabel => 'Added';

  @override
  String get updatedLabel => 'Updated';

  @override
  String get notTracked => 'Not tracked';

  @override
  String get detailsLabel => 'Details';

  @override
  String recommendationReason(String reason) {
    return 'Recommendation reason: $reason';
  }

  @override
  String get likeLabel => 'Like';

  @override
  String get previousSlide => 'Previous slide';

  @override
  String get nextSlide => 'Next slide';

  @override
  String errorWithDetails(String error) {
    return 'Error: $error';
  }

  @override
  String get reviewsScreen => 'Reviews Screen';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: '0 items',
    );
    return '$_temp0';
  }

  @override
  String movedToTitle(String title) {
    return 'Moved to \"$title\"';
  }

  @override
  String copiedToTitle(String title) {
    return 'Copied to \"$title\"';
  }

  @override
  String ratedStars(double stars) {
    return 'Rated: $stars stars';
  }
}
