import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'WatchAtlas'**
  String get appName;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @loadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more...'**
  String get loadingMore;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @pullToRefresh.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navLists.
  ///
  /// In en, this message translates to:
  /// **'Lists'**
  String get navLists;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @trendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// No description provided for @popularThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Popular This Week'**
  String get popularThisWeek;

  /// No description provided for @continueWatching.
  ///
  /// In en, this message translates to:
  /// **'Continue Watching'**
  String get continueWatching;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @upcomingReleases.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Releases'**
  String get upcomingReleases;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for You'**
  String get recommendedForYou;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @tvShows.
  ///
  /// In en, this message translates to:
  /// **'TV Shows'**
  String get tvShows;

  /// No description provided for @anime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get anime;

  /// No description provided for @kdrama.
  ///
  /// In en, this message translates to:
  /// **'K-Drama'**
  String get kdrama;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @cast.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// No description provided for @crew.
  ///
  /// In en, this message translates to:
  /// **'Crew'**
  String get crew;

  /// No description provided for @trailers.
  ///
  /// In en, this message translates to:
  /// **'Trailers'**
  String get trailers;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @similar.
  ///
  /// In en, this message translates to:
  /// **'Similar'**
  String get similar;

  /// No description provided for @addToList.
  ///
  /// In en, this message translates to:
  /// **'Add to List'**
  String get addToList;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @mediaType.
  ///
  /// In en, this message translates to:
  /// **'Media Type'**
  String get mediaType;

  /// No description provided for @releaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// No description provided for @runtime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get runtime;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @watching.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get watching;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @onHold.
  ///
  /// In en, this message translates to:
  /// **'On Hold'**
  String get onHold;

  /// No description provided for @dropped.
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get dropped;

  /// No description provided for @planToWatch.
  ///
  /// In en, this message translates to:
  /// **'Plan to Watch'**
  String get planToWatch;

  /// No description provided for @rewatching.
  ///
  /// In en, this message translates to:
  /// **'Rewatching'**
  String get rewatching;

  /// No description provided for @myTracking.
  ///
  /// In en, this message translates to:
  /// **'My Tracking'**
  String get myTracking;

  /// No description provided for @totalWatched.
  ///
  /// In en, this message translates to:
  /// **'Total Watched'**
  String get totalWatched;

  /// No description provided for @totalEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Total Episodes'**
  String get totalEpisodes;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @addToTracking.
  ///
  /// In en, this message translates to:
  /// **'Add to Tracking'**
  String get addToTracking;

  /// No description provided for @removeFromTracking.
  ///
  /// In en, this message translates to:
  /// **'Remove from Tracking'**
  String get removeFromTracking;

  /// No description provided for @trackingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} title} other{{count} titles}}'**
  String trackingCount(num count);

  /// No description provided for @episodeCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} episode} other{{count} episodes}}'**
  String episodeCount(num count);

  /// No description provided for @myLists.
  ///
  /// In en, this message translates to:
  /// **'My Lists'**
  String get myLists;

  /// No description provided for @createList.
  ///
  /// In en, this message translates to:
  /// **'Create List'**
  String get createList;

  /// No description provided for @listTitle.
  ///
  /// In en, this message translates to:
  /// **'List Title'**
  String get listTitle;

  /// No description provided for @listDescription.
  ///
  /// In en, this message translates to:
  /// **'List Description'**
  String get listDescription;

  /// No description provided for @publicList.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get publicList;

  /// No description provided for @privateList.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privateList;

  /// No description provided for @collaborative.
  ///
  /// In en, this message translates to:
  /// **'Collaborative'**
  String get collaborative;

  /// No description provided for @addToListTitle.
  ///
  /// In en, this message translates to:
  /// **'Add {title} to List'**
  String addToListTitle(Object title);

  /// No description provided for @noListsYet.
  ///
  /// In en, this message translates to:
  /// **'No lists yet'**
  String get noListsYet;

  /// No description provided for @createFirstList.
  ///
  /// In en, this message translates to:
  /// **'Create your first list'**
  String get createFirstList;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @joinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined on {date}'**
  String joinedOn(Object date);

  /// No description provided for @findFriends.
  ///
  /// In en, this message translates to:
  /// **'Find Friends'**
  String get findFriends;

  /// No description provided for @follow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get follow;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollow;

  /// No description provided for @friendActivity.
  ///
  /// In en, this message translates to:
  /// **'Friend Activity'**
  String get friendActivity;

  /// No description provided for @noFriendsYet.
  ///
  /// In en, this message translates to:
  /// **'No friends yet'**
  String get noFriendsYet;

  /// No description provided for @suggestedFriends.
  ///
  /// In en, this message translates to:
  /// **'Suggested Friends'**
  String get suggestedFriends;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search movies, shows, anime...'**
  String get searchHint;

  /// No description provided for @searchHistory.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get searchHistory;

  /// No description provided for @trendingSearches.
  ///
  /// In en, this message translates to:
  /// **'Trending Searches'**
  String get trendingSearches;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get searchResults;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All Read'**
  String get markAllRead;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @notificationFollow.
  ///
  /// In en, this message translates to:
  /// **'{name} started following you'**
  String notificationFollow(Object name);

  /// No description provided for @notificationLike.
  ///
  /// In en, this message translates to:
  /// **'{name} liked your review'**
  String notificationLike(Object name);

  /// No description provided for @notificationComment.
  ///
  /// In en, this message translates to:
  /// **'{name} commented on your review'**
  String notificationComment(Object name);

  /// No description provided for @notificationList.
  ///
  /// In en, this message translates to:
  /// **'{name} added you to a list'**
  String notificationList(Object name);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @contentLanguage.
  ///
  /// In en, this message translates to:
  /// **'Content Language'**
  String get contentLanguage;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @moderation.
  ///
  /// In en, this message translates to:
  /// **'Moderation'**
  String get moderation;

  /// No description provided for @recommendationsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Recommendations & Privacy'**
  String get recommendationsAndPrivacy;

  /// No description provided for @personalizedRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Personalized Recommendations'**
  String get personalizedRecommendations;

  /// No description provided for @activityImprovesSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Let your activity improve suggestions'**
  String get activityImprovesSuggestions;

  /// No description provided for @clearRecommendationHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear Recommendation History'**
  String get clearRecommendationHistory;

  /// No description provided for @removeAllBehavioralData.
  ///
  /// In en, this message translates to:
  /// **'Remove all behavioral data'**
  String get removeAllBehavioralData;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system settings'**
  String get followSystem;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @ratherNotSay.
  ///
  /// In en, this message translates to:
  /// **'Rather not say'**
  String get ratherNotSay;

  /// No description provided for @viewTracking.
  ///
  /// In en, this message translates to:
  /// **'View Tracking'**
  String get viewTracking;

  /// No description provided for @viewAnalytics.
  ///
  /// In en, this message translates to:
  /// **'View Analytics'**
  String get viewAnalytics;

  /// No description provided for @signOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmation;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @yourStats.
  ///
  /// In en, this message translates to:
  /// **'Your Stats'**
  String get yourStats;

  /// No description provided for @totalWatchedCount.
  ///
  /// In en, this message translates to:
  /// **'Total Watched'**
  String get totalWatchedCount;

  /// No description provided for @totalHoursCount.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHoursCount;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRating;

  /// No description provided for @genreDistribution.
  ///
  /// In en, this message translates to:
  /// **'Genre Distribution'**
  String get genreDistribution;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// No description provided for @monthlyActivity.
  ///
  /// In en, this message translates to:
  /// **'Monthly Activity'**
  String get monthlyActivity;

  /// No description provided for @favoriteGenre.
  ///
  /// In en, this message translates to:
  /// **'Favorite Genre'**
  String get favoriteGenre;

  /// No description provided for @favoriteCountry.
  ///
  /// In en, this message translates to:
  /// **'Favorite Country'**
  String get favoriteCountry;

  /// No description provided for @mostWatchedGenre.
  ///
  /// In en, this message translates to:
  /// **'Most Watched Genre'**
  String get mostWatchedGenre;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get topRated;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(double count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(double count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(double count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{weeks}w ago'**
  String weeksAgo(Object weeks);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}mo ago'**
  String monthsAgo(double count);

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{years}y ago'**
  String yearsAgo(Object years);

  /// No description provided for @termsOfServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfServiceTitle;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @termsOfServiceBody.
  ///
  /// In en, this message translates to:
  /// **'By using WatchAtlas, you agree to these terms. Please read them carefully.\n\n[Full terms would go here]'**
  String get termsOfServiceBody;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Your privacy matters to us.\n\n[Full privacy policy would go here]'**
  String get privacyPolicyBody;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: June 26, 2026'**
  String get lastUpdated;

  /// No description provided for @acceptanceOfTerms.
  ///
  /// In en, this message translates to:
  /// **'1. Acceptance of Terms'**
  String get acceptanceOfTerms;

  /// No description provided for @acceptanceOfTermsBody.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using WatchAtlas, you agree to be bound by these Terms of Service. If you do not agree, do not use the service.'**
  String get acceptanceOfTermsBody;

  /// No description provided for @descriptionOfService.
  ///
  /// In en, this message translates to:
  /// **'2. Description of Service'**
  String get descriptionOfService;

  /// No description provided for @descriptionOfServiceBody.
  ///
  /// In en, this message translates to:
  /// **'WatchAtlas is a media tracking application that allows users to discover, track, and organize movies, TV shows, and anime. Users can rate, review, and maintain watch lists.'**
  String get descriptionOfServiceBody;

  /// No description provided for @userAccounts.
  ///
  /// In en, this message translates to:
  /// **'3. User Accounts'**
  String get userAccounts;

  /// No description provided for @userAccountsBody.
  ///
  /// In en, this message translates to:
  /// **'You must sign in via Google OAuth to use the service. You are responsible for maintaining the confidentiality of your account. You must be at least 13 years old to use this service.'**
  String get userAccountsBody;

  /// No description provided for @userResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'4. User Responsibilities'**
  String get userResponsibilities;

  /// No description provided for @userResponsibilitiesBody.
  ///
  /// In en, this message translates to:
  /// **'You agree not to post abusive, harassing, or inappropriate content; not to impersonate others; not to attempt to circumvent security measures; and not to use the service for any illegal purpose. You are responsible for all activity that occurs under your account.'**
  String get userResponsibilitiesBody;

  /// No description provided for @acceptableUse.
  ///
  /// In en, this message translates to:
  /// **'5. Acceptable Use'**
  String get acceptableUse;

  /// No description provided for @acceptableUseBody.
  ///
  /// In en, this message translates to:
  /// **'You may use the service only for lawful purposes. You agree not to interfere with or disrupt the integrity or performance of the service, or attempt to gain unauthorized access to any portion of the service or related systems.'**
  String get acceptableUseBody;

  /// No description provided for @userGeneratedContent.
  ///
  /// In en, this message translates to:
  /// **'6. User-Generated Content'**
  String get userGeneratedContent;

  /// No description provided for @userGeneratedContentBody.
  ///
  /// In en, this message translates to:
  /// **'You retain ownership of content you create, including lists, ratings, reviews, notes, and profile information. By using the service, you grant WatchAtlas a worldwide, non-exclusive license to store, display, and distribute that content in connection with providing the service. You are solely responsible for content you submit.'**
  String get userGeneratedContentBody;

  /// No description provided for @intellectualProperty.
  ///
  /// In en, this message translates to:
  /// **'7. Intellectual Property'**
  String get intellectualProperty;

  /// No description provided for @intellectualPropertyBody.
  ///
  /// In en, this message translates to:
  /// **'Media metadata and images are provided by TMDB and AniList under their respective licenses. The WatchAtlas application and code are proprietary. User-generated content (reviews, ratings, lists) remains owned by you, with a license granted to WatchAtlas to display it within the service.'**
  String get intellectualPropertyBody;

  /// No description provided for @thirdPartyServicesTerms.
  ///
  /// In en, this message translates to:
  /// **'8. Third-Party Services'**
  String get thirdPartyServicesTerms;

  /// No description provided for @thirdPartyServicesTermsBody.
  ///
  /// In en, this message translates to:
  /// **'The service may contain links to or integrate with third-party services, including TMDB, AniList, and Google OAuth. Your use of third-party services is governed by their respective terms and privacy policies. WatchAtlas is not responsible for the practices or content of third-party services.'**
  String get thirdPartyServicesTermsBody;

  /// No description provided for @externalLinks.
  ///
  /// In en, this message translates to:
  /// **'9. External Links'**
  String get externalLinks;

  /// No description provided for @externalLinksBody.
  ///
  /// In en, this message translates to:
  /// **'The service may contain links to external websites or resources. WatchAtlas is not responsible for the availability or content of these external sites and does not endorse any content, products, or services available from them.'**
  String get externalLinksBody;

  /// No description provided for @availabilityOfService.
  ///
  /// In en, this message translates to:
  /// **'10. Availability of Service'**
  String get availabilityOfService;

  /// No description provided for @availabilityOfServiceBody.
  ///
  /// In en, this message translates to:
  /// **'We strive to keep the service available, secure, and up to date. However, we do not guarantee uninterrupted access. The service may be temporarily unavailable due to maintenance, updates, or factors beyond our control.'**
  String get availabilityOfServiceBody;

  /// No description provided for @changesToFeatures.
  ///
  /// In en, this message translates to:
  /// **'11. Changes to Features'**
  String get changesToFeatures;

  /// No description provided for @changesToFeaturesBody.
  ///
  /// In en, this message translates to:
  /// **'We may modify, update, or discontinue features of the service at any time, with or without notice. We are not liable to you or any third party for any modification, suspension, or discontinuance of the service or any part thereof.'**
  String get changesToFeaturesBody;

  /// No description provided for @accountSuspension.
  ///
  /// In en, this message translates to:
  /// **'12. Account Suspension or Termination'**
  String get accountSuspension;

  /// No description provided for @accountSuspensionBody.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to suspend or terminate accounts that violate these terms. You may delete your account and associated data at any time through the app settings or by contacting us.'**
  String get accountSuspensionBody;

  /// No description provided for @disclaimers.
  ///
  /// In en, this message translates to:
  /// **'13. Disclaimers'**
  String get disclaimers;

  /// No description provided for @disclaimersBody.
  ///
  /// In en, this message translates to:
  /// **'The service is provided on an as-is and as-available basis. We make no warranties, express or implied, regarding the accuracy, reliability, or availability of the service. We do not guarantee that metadata, recommendations, or search results will be error-free or meet your expectations.'**
  String get disclaimersBody;

  /// No description provided for @privacyReference.
  ///
  /// In en, this message translates to:
  /// **'14. Privacy'**
  String get privacyReference;

  /// No description provided for @privacyReferenceBody.
  ///
  /// In en, this message translates to:
  /// **'Your use of the service is also governed by our Privacy Policy. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.'**
  String get privacyReferenceBody;

  /// No description provided for @changesToTerms.
  ///
  /// In en, this message translates to:
  /// **'15. Changes to Terms'**
  String get changesToTerms;

  /// No description provided for @changesToTermsBody.
  ///
  /// In en, this message translates to:
  /// **'We may update these terms at any time. Continued use after changes constitutes acceptance. Users will be notified of material changes via email or in-app notification.'**
  String get changesToTermsBody;

  /// No description provided for @contactSection.
  ///
  /// In en, this message translates to:
  /// **'16. Contact'**
  String get contactSection;

  /// No description provided for @contactLegal.
  ///
  /// In en, this message translates to:
  /// **'For questions about these terms, contact: legal@watchatlas.app'**
  String get contactLegal;

  /// No description provided for @contactPrivacy.
  ///
  /// In en, this message translates to:
  /// **'For privacy-related inquiries, contact: privacy@watchatlas.app'**
  String get contactPrivacy;

  /// No description provided for @informationWeCollect.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get informationWeCollect;

  /// No description provided for @informationWeCollectBody.
  ///
  /// In en, this message translates to:
  /// **'When you sign in with Google OAuth, we collect your email address and display name. We also store media you track (movies, TV shows, anime) along with your watch status, ratings, and reviews. Profile avatars and display names are stored via Supabase storage.\n\nOptional information you may provide includes your date of birth and gender, which are used only to personalize your experience.'**
  String get informationWeCollectBody;

  /// No description provided for @automaticallyCollectedData.
  ///
  /// In en, this message translates to:
  /// **'2. Automatically Collected Data'**
  String get automaticallyCollectedData;

  /// No description provided for @automaticallyCollectedDataBody.
  ///
  /// In en, this message translates to:
  /// **'We may automatically collect certain information when you use the app, including device type, app version, and crash reports if available. Authentication metadata is processed by our authentication provider (Google OAuth) to maintain your session securely.'**
  String get automaticallyCollectedDataBody;

  /// No description provided for @howWeUseInfo.
  ///
  /// In en, this message translates to:
  /// **'3. How We Use Your Information'**
  String get howWeUseInfo;

  /// No description provided for @howWeUseInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Your information is used to provide and improve the service: personalize your experience, maintain your watch lists and reviews, generate recommendations based on your activity, and communicate service updates if necessary.'**
  String get howWeUseInfoBody;

  /// No description provided for @dataStorage.
  ///
  /// In en, this message translates to:
  /// **'4. Data Storage & Security'**
  String get dataStorage;

  /// No description provided for @dataStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely on Supabase (PostgreSQL) and Google Cloud infrastructure. We use Row Level Security to ensure you can only access your own data. Passwords are never stored — authentication is handled entirely by Google OAuth. All data transmission uses secure HTTPS connections.'**
  String get dataStorageBody;

  /// No description provided for @thirdPartyServicesPrivacy.
  ///
  /// In en, this message translates to:
  /// **'5. Third-Party Services'**
  String get thirdPartyServicesPrivacy;

  /// No description provided for @thirdPartyServicesPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'We use TMDB (The Movie Database) to fetch media metadata. Your searches and viewed media IDs are sent to TMDB\'s API. We also use AniList for anime metadata. Google OAuth is used for authentication. Each third-party service processes data according to its own privacy policy.'**
  String get thirdPartyServicesPrivacyBody;

  /// No description provided for @cookiesLocalStorage.
  ///
  /// In en, this message translates to:
  /// **'6. Cookies & Local Storage'**
  String get cookiesLocalStorage;

  /// No description provided for @cookiesLocalStorageBody.
  ///
  /// In en, this message translates to:
  /// **'We use local storage to maintain your login session, remember your preferences (such as theme and language), and cache data to improve performance. We do not use tracking cookies or similar technologies for advertising purposes.'**
  String get cookiesLocalStorageBody;

  /// No description provided for @dataRetention.
  ///
  /// In en, this message translates to:
  /// **'7. Data Retention'**
  String get dataRetention;

  /// No description provided for @dataRetentionBody.
  ///
  /// In en, this message translates to:
  /// **'Your data is retained for as long as your account is active. You may delete your account and associated data at any time by contacting us or using the delete account feature in the app.'**
  String get dataRetentionBody;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'8. Your Rights'**
  String get yourRights;

  /// No description provided for @yourRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You may request a copy of your data, correction of inaccurate data, or deletion of your account and associated data at any time. You can update your profile information, manage your personalization preferences, change your language, or log out at any time through the app settings.'**
  String get yourRightsBody;

  /// No description provided for @childrensPrivacy.
  ///
  /// In en, this message translates to:
  /// **'9. Children\'s Privacy'**
  String get childrensPrivacy;

  /// No description provided for @childrensPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'WatchAtlas is intended for users aged 13 and older. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us so we can take appropriate action.'**
  String get childrensPrivacyBody;

  /// No description provided for @policyUpdates.
  ///
  /// In en, this message translates to:
  /// **'10. Policy Updates'**
  String get policyUpdates;

  /// No description provided for @policyUpdatesBody.
  ///
  /// In en, this message translates to:
  /// **'We may update this privacy policy from time to time. We will notify you of any material changes by posting the updated policy in the app and updating the Last Updated date above. Your continued use of the service after changes constitutes acceptance of the updated policy.'**
  String get policyUpdatesBody;

  /// No description provided for @openSourceNotice.
  ///
  /// In en, this message translates to:
  /// **'Open Source Notice'**
  String get openSourceNotice;

  /// No description provided for @openSourceNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'WatchAtlas uses various open-source libraries and frameworks. We gratefully acknowledge the contributions of the open-source community. The respective licenses for these libraries apply to their use within this application.'**
  String get openSourceNoticeBody;

  /// No description provided for @thirdPartyLibraries.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Libraries'**
  String get thirdPartyLibraries;

  /// No description provided for @thirdPartyLibrariesBody.
  ///
  /// In en, this message translates to:
  /// **'This application includes open-source software components. License details for these components are available through the License page below.'**
  String get thirdPartyLibrariesBody;

  /// No description provided for @mediaOwnership.
  ///
  /// In en, this message translates to:
  /// **'Media Ownership'**
  String get mediaOwnership;

  /// No description provided for @mediaOwnershipBody.
  ///
  /// In en, this message translates to:
  /// **'Movie, TV, anime, and other media metadata, posters, backdrops, logos, and promotional artwork belong to their respective owners and copyright holders. WatchAtlas does not claim ownership of any third-party media assets. Such content is used for identification, cataloging, and informational purposes only.'**
  String get mediaOwnershipBody;

  /// No description provided for @aiGeneratedLogo.
  ///
  /// In en, this message translates to:
  /// **'AI-Generated Logo'**
  String get aiGeneratedLogo;

  /// No description provided for @aiGeneratedLogoBody.
  ///
  /// In en, this message translates to:
  /// **'The WatchAtlas application logo was created using AI-assisted design tools. The logo is used as the application\'s visual identity. WatchAtlas does not claim exclusive ownership over the underlying AI model, generated style, or training data used to create it. Any rights associated with the generated logo are subject to the terms of the AI service used to create it. The logo should not be interpreted as claiming ownership over AI-generated methodologies or third-party intellectual property.'**
  String get aiGeneratedLogoBody;

  /// No description provided for @trademarks.
  ///
  /// In en, this message translates to:
  /// **'Trademarks'**
  String get trademarks;

  /// No description provided for @trademarksBody.
  ///
  /// In en, this message translates to:
  /// **'Movie titles, TV series names, anime titles, studio names, streaming platform names, company names, and trademarks appearing in the application are the property of their respective owners. Their appearance within WatchAtlas is for identification, cataloging, and informational purposes only.'**
  String get trademarksBody;

  /// No description provided for @metadataAttribution.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get metadataAttribution;

  /// No description provided for @metadataAttributionBody.
  ///
  /// In en, this message translates to:
  /// **'Media information displayed in the app — including titles, descriptions, ratings, genres, release dates, cast, crew, runtime, and production information — is obtained from third-party providers, primarily TMDB (The Movie Database) and AniList. This data is provided for informational purposes and may occasionally contain inaccuracies or be out of date.'**
  String get metadataAttributionBody;

  /// No description provided for @imagesAttribution.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get imagesAttribution;

  /// No description provided for @imagesAttributionBody.
  ///
  /// In en, this message translates to:
  /// **'Posters, backdrops, logos, and promotional artwork displayed in the app are the property of their respective copyright holders and are used under license or for identification purposes only. WatchAtlas does not claim ownership of any visual assets.'**
  String get imagesAttributionBody;

  /// No description provided for @recommendationSystemInfo.
  ///
  /// In en, this message translates to:
  /// **'Recommendation System'**
  String get recommendationSystemInfo;

  /// No description provided for @recommendationSystemInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Recommendations are generated automatically based on your activity and preferences, such as what you watch, rate, save, and search for. The goal is to improve content discovery. Recommendations are suggestions, not guarantees, and do not reflect any official endorsement by content creators or distributors.'**
  String get recommendationSystemInfoBody;

  /// No description provided for @userContentOwnership.
  ///
  /// In en, this message translates to:
  /// **'User Content'**
  String get userContentOwnership;

  /// No description provided for @userContentOwnershipBody.
  ///
  /// In en, this message translates to:
  /// **'You retain ownership of the content you create in WatchAtlas, including lists, ratings, favorites, notes, and reviews. By using the service, you grant WatchAtlas the necessary rights to store, display, and process that content within the app. You are responsible for the content you submit and should respect the rights of others.'**
  String get userContentOwnershipBody;

  /// No description provided for @accuracyDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracyDisclaimer;

  /// No description provided for @accuracyDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Although WatchAtlas strives to provide accurate and up-to-date information, metadata may occasionally contain inaccuracies or outdated information due to its reliance on third-party sources. We encourage users to verify important details through official sources.'**
  String get accuracyDisclaimerBody;

  /// No description provided for @contentAndAttribution.
  ///
  /// In en, this message translates to:
  /// **'Content & Attribution'**
  String get contentAndAttribution;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @enterEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a password reset link'**
  String get enterEmailForReset;

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get backToSignIn;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @setUpProfile.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile'**
  String get setUpProfile;

  /// No description provided for @chooseAvatar.
  ///
  /// In en, this message translates to:
  /// **'Choose an avatar'**
  String get chooseAvatar;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo'**
  String get uploadPhoto;

  /// No description provided for @orPickDefault.
  ///
  /// In en, this message translates to:
  /// **'Or pick one of the defaults below'**
  String get orPickDefault;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get selectDateOfBirth;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @mustBe13.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old to use this app'**
  String get mustBe13;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get failedToSaveProfile;

  /// No description provided for @invalidEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// No description provided for @pleaseConfirmEmail.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your email address'**
  String get pleaseConfirmEmail;

  /// No description provided for @accountAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'An account with this email already exists'**
  String get accountAlreadyExists;

  /// No description provided for @chooseAccount.
  ///
  /// In en, this message translates to:
  /// **'Choose an account'**
  String get chooseAccount;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @signInToGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to a Google account'**
  String get signInToGoogle;

  /// No description provided for @previouslyUsed.
  ///
  /// In en, this message translates to:
  /// **'Previously used'**
  String get previouslyUsed;

  /// No description provided for @signInTo.
  ///
  /// In en, this message translates to:
  /// **'Sign in to'**
  String get signInTo;

  /// No description provided for @tryAnotherAccount.
  ///
  /// In en, this message translates to:
  /// **'Try another account'**
  String get tryAnotherAccount;

  /// No description provided for @useDifferentGoogleAccount.
  ///
  /// In en, this message translates to:
  /// **'Use a different Google account'**
  String get useDifferentGoogleAccount;

  /// No description provided for @couldNotLoadContinueWatching.
  ///
  /// In en, this message translates to:
  /// **'Could not load continue watching'**
  String get couldNotLoadContinueWatching;

  /// No description provided for @noContentInProgress.
  ///
  /// In en, this message translates to:
  /// **'No content in progress'**
  String get noContentInProgress;

  /// No description provided for @searchMoviesTv.
  ///
  /// In en, this message translates to:
  /// **'Search movies, TV shows...'**
  String get searchMoviesTv;

  /// No description provided for @searchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed'**
  String get searchFailed;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @searchMoviesTvAnime.
  ///
  /// In en, this message translates to:
  /// **'Search movies, TV shows, anime...'**
  String get searchMoviesTvAnime;

  /// No description provided for @advancedFilters.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFilters;

  /// No description provided for @allCountries.
  ///
  /// In en, this message translates to:
  /// **'All Countries'**
  String get allCountries;

  /// No description provided for @yearRange.
  ///
  /// In en, this message translates to:
  /// **'Year Range'**
  String get yearRange;

  /// No description provided for @ratingRange.
  ///
  /// In en, this message translates to:
  /// **'Rating Range'**
  String get ratingRange;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @failedToLoadDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load details'**
  String get failedToLoadDetails;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get writeReview;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet. Be the first to review!'**
  String get noReviewsYet;

  /// No description provided for @failedToLoadReviews.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reviews'**
  String get failedToLoadReviews;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// No description provided for @createNewList.
  ///
  /// In en, this message translates to:
  /// **'Create New List'**
  String get createNewList;

  /// No description provided for @addedTo.
  ///
  /// In en, this message translates to:
  /// **'Added to'**
  String get addedTo;

  /// No description provided for @addedToTitle.
  ///
  /// In en, this message translates to:
  /// **'Added to \"{title}\"'**
  String addedToTitle(String title);

  /// No description provided for @listCreated.
  ///
  /// In en, this message translates to:
  /// **'List created'**
  String get listCreated;

  /// No description provided for @removeFromTrackingList.
  ///
  /// In en, this message translates to:
  /// **'Remove from this list'**
  String get removeFromTrackingList;

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// No description provided for @recentlyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recently Updated'**
  String get recentlyUpdated;

  /// No description provided for @noMediaInList.
  ///
  /// In en, this message translates to:
  /// **'No media in this list'**
  String get noMediaInList;

  /// No description provided for @failedToLoadTracking.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tracking data'**
  String get failedToLoadTracking;

  /// No description provided for @myCollections.
  ///
  /// In en, this message translates to:
  /// **'My Collections'**
  String get myCollections;

  /// No description provided for @allCollections.
  ///
  /// In en, this message translates to:
  /// **'All Collections'**
  String get allCollections;

  /// No description provided for @selectList.
  ///
  /// In en, this message translates to:
  /// **'Select a list'**
  String get selectList;

  /// No description provided for @chooseListFromSidebar.
  ///
  /// In en, this message translates to:
  /// **'Choose a list from the sidebar to view its contents'**
  String get chooseListFromSidebar;

  /// No description provided for @yourCollections.
  ///
  /// In en, this message translates to:
  /// **'Your Collections'**
  String get yourCollections;

  /// No description provided for @allItems.
  ///
  /// In en, this message translates to:
  /// **'All Items'**
  String get allItems;

  /// No description provided for @noItemsInList.
  ///
  /// In en, this message translates to:
  /// **'No items in this list'**
  String get noItemsInList;

  /// No description provided for @addMediaFromDetails.
  ///
  /// In en, this message translates to:
  /// **'Add media from the details page'**
  String get addMediaFromDetails;

  /// No description provided for @noOtherListsToMoveTo.
  ///
  /// In en, this message translates to:
  /// **'No other lists to move to'**
  String get noOtherListsToMoveTo;

  /// No description provided for @noOtherListsToCopyTo.
  ///
  /// In en, this message translates to:
  /// **'No other lists to copy to'**
  String get noOtherListsToCopyTo;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to...'**
  String get moveTo;

  /// No description provided for @copyTo.
  ///
  /// In en, this message translates to:
  /// **'Copy to...'**
  String get copyTo;

  /// No description provided for @movedTo.
  ///
  /// In en, this message translates to:
  /// **'Moved to'**
  String get movedTo;

  /// No description provided for @copiedTo.
  ///
  /// In en, this message translates to:
  /// **'Copied to'**
  String get copiedTo;

  /// No description provided for @removedFromList.
  ///
  /// In en, this message translates to:
  /// **'Removed from list'**
  String get removedFromList;

  /// No description provided for @toggleView.
  ///
  /// In en, this message translates to:
  /// **'Toggle view'**
  String get toggleView;

  /// No description provided for @searchItems.
  ///
  /// In en, this message translates to:
  /// **'Search items...'**
  String get searchItems;

  /// No description provided for @failedToLoadList.
  ///
  /// In en, this message translates to:
  /// **'Failed to load list'**
  String get failedToLoadList;

  /// No description provided for @listNotFound.
  ///
  /// In en, this message translates to:
  /// **'List not found'**
  String get listNotFound;

  /// No description provided for @listCouldNotBeFound.
  ///
  /// In en, this message translates to:
  /// **'This list could not be found'**
  String get listCouldNotBeFound;

  /// No description provided for @checkOutMyList.
  ///
  /// In en, this message translates to:
  /// **'Check out my list: {title} on WatchAtlas'**
  String checkOutMyList(Object title);

  /// No description provided for @failedToLoadItems.
  ///
  /// In en, this message translates to:
  /// **'Failed to load items'**
  String get failedToLoadItems;

  /// No description provided for @enterListName.
  ///
  /// In en, this message translates to:
  /// **'Enter list name'**
  String get enterListName;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @describeList.
  ///
  /// In en, this message translates to:
  /// **'Describe this list'**
  String get describeList;

  /// No description provided for @anyoneCanSee.
  ///
  /// In en, this message translates to:
  /// **'Anyone can see this list'**
  String get anyoneCanSee;

  /// No description provided for @onlyYouCanSee.
  ///
  /// In en, this message translates to:
  /// **'Only you can see this list'**
  String get onlyYouCanSee;

  /// No description provided for @othersCanAddRemove.
  ///
  /// In en, this message translates to:
  /// **'Others can add and remove items'**
  String get othersCanAddRemove;

  /// No description provided for @noItemsMatch.
  ///
  /// In en, this message translates to:
  /// **'No items match'**
  String get noItemsMatch;

  /// No description provided for @across.
  ///
  /// In en, this message translates to:
  /// **'Across'**
  String get across;

  /// No description provided for @deleteListConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String deleteListConfirm(Object title);

  /// No description provided for @deleteListWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove the list and all media entries it contains. This action cannot be undone.'**
  String get deleteListWarning;

  /// No description provided for @listDeleted.
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get listDeleted;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @failedToLoadFollowing.
  ///
  /// In en, this message translates to:
  /// **'Failed to load following'**
  String get failedToLoadFollowing;

  /// No description provided for @notFollowingAnyone.
  ///
  /// In en, this message translates to:
  /// **'Not following anyone'**
  String get notFollowingAnyone;

  /// No description provided for @findFriendsToFollow.
  ///
  /// In en, this message translates to:
  /// **'Find friends to follow and see their activity.'**
  String get findFriendsToFollow;

  /// No description provided for @failedToLoadFollowers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load followers'**
  String get failedToLoadFollowers;

  /// No description provided for @noFollowersYet.
  ///
  /// In en, this message translates to:
  /// **'No followers yet'**
  String get noFollowersYet;

  /// No description provided for @whenSomeoneFollowsYou.
  ///
  /// In en, this message translates to:
  /// **'When someone follows you, they will appear here.'**
  String get whenSomeoneFollowsYou;

  /// No description provided for @failedToLoadActivity.
  ///
  /// In en, this message translates to:
  /// **'Failed to load activity'**
  String get failedToLoadActivity;

  /// No description provided for @noFriendActivity.
  ///
  /// In en, this message translates to:
  /// **'No friend activity'**
  String get noFriendActivity;

  /// No description provided for @activityFromPeopleYouFollow.
  ///
  /// In en, this message translates to:
  /// **'Activity from people you follow will appear here.'**
  String get activityFromPeopleYouFollow;

  /// No description provided for @searchByUsername.
  ///
  /// In en, this message translates to:
  /// **'Search by username...'**
  String get searchByUsername;

  /// No description provided for @failedToLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedToLoadNotifications;

  /// No description provided for @youreAllCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up!'**
  String get youreAllCaughtUp;

  /// No description provided for @clearAllNotificationsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear all notifications?'**
  String get clearAllNotificationsConfirm;

  /// No description provided for @clearAllWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All notifications will be permanently deleted.'**
  String get clearAllWarning;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @noModeratorPermissions.
  ///
  /// In en, this message translates to:
  /// **'You do not have moderator permissions.'**
  String get noModeratorPermissions;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @failedToLoadReports.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reports'**
  String get failedToLoadReports;

  /// No description provided for @noPendingReports.
  ///
  /// In en, this message translates to:
  /// **'No pending reports'**
  String get noPendingReports;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'All clear!'**
  String get allClear;

  /// No description provided for @reportedUser.
  ///
  /// In en, this message translates to:
  /// **'Reported User'**
  String get reportedUser;

  /// No description provided for @mediaId.
  ///
  /// In en, this message translates to:
  /// **'Media ID'**
  String get mediaId;

  /// No description provided for @reporter.
  ///
  /// In en, this message translates to:
  /// **'Reporter'**
  String get reporter;

  /// No description provided for @takeAction.
  ///
  /// In en, this message translates to:
  /// **'Take Action'**
  String get takeAction;

  /// No description provided for @warnUser.
  ///
  /// In en, this message translates to:
  /// **'Warn User'**
  String get warnUser;

  /// No description provided for @sendWarningToUser.
  ///
  /// In en, this message translates to:
  /// **'Send a warning to the user'**
  String get sendWarningToUser;

  /// No description provided for @hideContent.
  ///
  /// In en, this message translates to:
  /// **'Hide Content'**
  String get hideContent;

  /// No description provided for @makeContentInvisible.
  ///
  /// In en, this message translates to:
  /// **'Make content invisible to users'**
  String get makeContentInvisible;

  /// No description provided for @deleteContent.
  ///
  /// In en, this message translates to:
  /// **'Delete Content'**
  String get deleteContent;

  /// No description provided for @permanentlyRemoveContent.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove this content'**
  String get permanentlyRemoveContent;

  /// No description provided for @confirmDeletion.
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get confirmDeletion;

  /// No description provided for @confirmDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this content?'**
  String get confirmDeleteContent;

  /// No description provided for @banUser.
  ///
  /// In en, this message translates to:
  /// **'Ban User'**
  String get banUser;

  /// No description provided for @permanentlyBanUser.
  ///
  /// In en, this message translates to:
  /// **'Permanently ban this user from the platform'**
  String get permanentlyBanUser;

  /// No description provided for @confirmBan.
  ///
  /// In en, this message translates to:
  /// **'Confirm Ban'**
  String get confirmBan;

  /// No description provided for @confirmBanUser.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently ban this user?'**
  String get confirmBanUser;

  /// No description provided for @ban.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get ban;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @failedToLoadUsers.
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get failedToLoadUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @roleUser.
  ///
  /// In en, this message translates to:
  /// **'USER'**
  String get roleUser;

  /// No description provided for @roleModerator.
  ///
  /// In en, this message translates to:
  /// **'MODERATOR'**
  String get roleModerator;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'ADMIN'**
  String get roleAdmin;

  /// No description provided for @failedToLoadStats.
  ///
  /// In en, this message translates to:
  /// **'Failed to load stats'**
  String get failedToLoadStats;

  /// No description provided for @yearlyActivity.
  ///
  /// In en, this message translates to:
  /// **'Yearly Activity'**
  String get yearlyActivity;

  /// No description provided for @countryDistribution.
  ///
  /// In en, this message translates to:
  /// **'Country Distribution'**
  String get countryDistribution;

  /// No description provided for @ratingDistribution.
  ///
  /// In en, this message translates to:
  /// **'Rating Distribution'**
  String get ratingDistribution;

  /// No description provided for @avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get avgRating;

  /// No description provided for @mostWatchedDecade.
  ///
  /// In en, this message translates to:
  /// **'Most Watched Decade'**
  String get mostWatchedDecade;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available yet'**
  String get noDataAvailable;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @totalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get totalItems;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your global watch list'**
  String get splashSubtitle;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @enterDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Enter your display name'**
  String get enterDisplayName;

  /// No description provided for @displayNameMax50.
  ///
  /// In en, this message translates to:
  /// **'Display name must be 50 characters or less'**
  String get displayNameMax50;

  /// No description provided for @tellOthersAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell others about yourself'**
  String get tellOthersAboutYourself;

  /// No description provided for @bioMax500.
  ///
  /// In en, this message translates to:
  /// **'Bio must be 500 characters or less'**
  String get bioMax500;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// No description provided for @noResultsForSearch.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResultsForSearch;

  /// No description provided for @tryDifferentSearchTerm.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearchTerm;

  /// No description provided for @watchingBadge.
  ///
  /// In en, this message translates to:
  /// **'WATCHING'**
  String get watchingBadge;

  /// No description provided for @completedBadge.
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get completedBadge;

  /// No description provided for @onHoldBadge.
  ///
  /// In en, this message translates to:
  /// **'HOLD'**
  String get onHoldBadge;

  /// No description provided for @droppedBadge.
  ///
  /// In en, this message translates to:
  /// **'DROP'**
  String get droppedBadge;

  /// No description provided for @planToWatchBadge.
  ///
  /// In en, this message translates to:
  /// **'PLAN'**
  String get planToWatchBadge;

  /// No description provided for @rewatchingBadge.
  ///
  /// In en, this message translates to:
  /// **'REWATCH'**
  String get rewatchingBadge;

  /// No description provided for @removeListTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{title}\"?'**
  String removeListTitle(String title);

  /// No description provided for @removeFromListWarning.
  ///
  /// In en, this message translates to:
  /// **'This will remove the item from this list.'**
  String get removeFromListWarning;

  /// No description provided for @clearActivityWarning.
  ///
  /// In en, this message translates to:
  /// **'This will remove all your activity data used for recommendations. Continue?'**
  String get clearActivityWarning;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @arabicLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabicLanguage;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action is permanent and cannot be undone. All your data will be deleted.'**
  String get deleteAccountWarning;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'A modern media tracking platform to discover, track, and share your favorite movies, TV shows, and more.'**
  String get aboutAppDescription;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @inYourList.
  ///
  /// In en, this message translates to:
  /// **'In Your List'**
  String get inYourList;

  /// No description provided for @inYourLibrary.
  ///
  /// In en, this message translates to:
  /// **'In Your Library'**
  String get inYourLibrary;

  /// No description provided for @addedLabel.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get addedLabel;

  /// No description provided for @updatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedLabel;

  /// No description provided for @notTracked.
  ///
  /// In en, this message translates to:
  /// **'Not tracked'**
  String get notTracked;

  /// No description provided for @detailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsLabel;

  /// No description provided for @recommendationReason.
  ///
  /// In en, this message translates to:
  /// **'Recommendation reason: {reason}'**
  String recommendationReason(String reason);

  /// No description provided for @likeLabel.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeLabel;

  /// No description provided for @previousSlide.
  ///
  /// In en, this message translates to:
  /// **'Previous slide'**
  String get previousSlide;

  /// No description provided for @nextSlide.
  ///
  /// In en, this message translates to:
  /// **'Next slide'**
  String get nextSlide;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetails(String error);

  /// No description provided for @reviewsScreen.
  ///
  /// In en, this message translates to:
  /// **'Reviews Screen'**
  String get reviewsScreen;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @movedToTitle.
  ///
  /// In en, this message translates to:
  /// **'Moved to \"{title}\"'**
  String movedToTitle(String title);

  /// No description provided for @copiedToTitle.
  ///
  /// In en, this message translates to:
  /// **'Copied to \"{title}\"'**
  String copiedToTitle(String title);

  /// No description provided for @ratedStars.
  ///
  /// In en, this message translates to:
  /// **'Rated: {stars} stars'**
  String ratedStars(double stars);

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @listDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{title}\"'**
  String listDeletedTitle(String title);

  /// No description provided for @episodeProgress.
  ///
  /// In en, this message translates to:
  /// **'{current}/{total}'**
  String episodeProgress(int current, int total);

  /// No description provided for @countryWithCode.
  ///
  /// In en, this message translates to:
  /// **'{name} ({code})'**
  String countryWithCode(String name, String code);

  /// No description provided for @mediaWithId.
  ///
  /// In en, this message translates to:
  /// **'Media #{id}'**
  String mediaWithId(String id);

  /// No description provided for @unknownList.
  ///
  /// In en, this message translates to:
  /// **'Unknown List'**
  String get unknownList;

  /// No description provided for @profileDatabaseError.
  ///
  /// In en, this message translates to:
  /// **'Make sure the database grants have been applied.\nRun supabase/grants.sql in your Supabase SQL editor.'**
  String get profileDatabaseError;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please check your email for a confirmation link before signing in.'**
  String get accountCreated;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications from WatchAtlas'**
  String get notificationChannelDescription;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @contentReport.
  ///
  /// In en, this message translates to:
  /// **'Content Report'**
  String get contentReport;

  /// No description provided for @userReport.
  ///
  /// In en, this message translates to:
  /// **'User Report'**
  String get userReport;

  /// No description provided for @reportPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reportPending;

  /// No description provided for @reportResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get reportResolved;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @popularTrending.
  ///
  /// In en, this message translates to:
  /// **'Popular trending'**
  String get popularTrending;

  /// No description provided for @recommendationBecauseYouSaved.
  ///
  /// In en, this message translates to:
  /// **'Because You Saved...'**
  String get recommendationBecauseYouSaved;

  /// No description provided for @recommendationBecauseYouViewed.
  ///
  /// In en, this message translates to:
  /// **'Because You Viewed...'**
  String get recommendationBecauseYouViewed;

  /// No description provided for @recommendationTrendingNearYou.
  ///
  /// In en, this message translates to:
  /// **'Trending Near You'**
  String get recommendationTrendingNearYou;

  /// No description provided for @recommendationPopularThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Popular This Week'**
  String get recommendationPopularThisWeek;

  /// No description provided for @recommendationContinueExploring.
  ///
  /// In en, this message translates to:
  /// **'Continue Exploring'**
  String get recommendationContinueExploring;

  /// No description provided for @recommendationNewReleases.
  ///
  /// In en, this message translates to:
  /// **'New Releases'**
  String get recommendationNewReleases;

  /// No description provided for @recommendationHiddenGems.
  ///
  /// In en, this message translates to:
  /// **'Hidden Gems'**
  String get recommendationHiddenGems;

  /// No description provided for @recommendationCriticallyAcclaimed.
  ///
  /// In en, this message translates to:
  /// **'Critically Acclaimed'**
  String get recommendationCriticallyAcclaimed;

  /// No description provided for @recommendationTopRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get recommendationTopRated;

  /// No description provided for @recommendationSimilarToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Similar to Your Favorites'**
  String get recommendationSimilarToFavorites;

  /// No description provided for @recommendationBecauseYouLikeGenre.
  ///
  /// In en, this message translates to:
  /// **'Because You Like...'**
  String get recommendationBecauseYouLikeGenre;

  /// No description provided for @recommendationFriendsAlsoSaved.
  ///
  /// In en, this message translates to:
  /// **'Friends Also Saved'**
  String get recommendationFriendsAlsoSaved;

  /// No description provided for @recommendationUsersLikeYou.
  ///
  /// In en, this message translates to:
  /// **'Users Like You Enjoyed'**
  String get recommendationUsersLikeYou;

  /// No description provided for @recommendationAwardWinners.
  ///
  /// In en, this message translates to:
  /// **'Award Winners'**
  String get recommendationAwardWinners;

  /// No description provided for @recommendationUnderratedClassics.
  ///
  /// In en, this message translates to:
  /// **'Underrated Classics'**
  String get recommendationUnderratedClassics;

  /// No description provided for @recommendationUpcomingReleases.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Releases'**
  String get recommendationUpcomingReleases;

  /// No description provided for @similarToSaved.
  ///
  /// In en, this message translates to:
  /// **'Similar to what you\'ve saved'**
  String get similarToSaved;

  /// No description provided for @forYou.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get forYou;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @allRecommendations.
  ///
  /// In en, this message translates to:
  /// **'All Recommendations'**
  String get allRecommendations;

  /// No description provided for @viewAllRecommendations.
  ///
  /// In en, this message translates to:
  /// **'View All Recommendations'**
  String get viewAllRecommendations;

  /// No description provided for @recommendationCategories.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Categories'**
  String get recommendationCategories;

  /// No description provided for @failedToLoadRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recommendations'**
  String get failedToLoadRecommendations;

  /// No description provided for @noRecommendationsYet.
  ///
  /// In en, this message translates to:
  /// **'No recommendations yet'**
  String get noRecommendationsYet;

  /// No description provided for @navRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get navRecommendations;

  /// No description provided for @similarToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Similar to your favorites'**
  String get similarToFavorites;

  /// No description provided for @usersLikeYouEnjoyed.
  ///
  /// In en, this message translates to:
  /// **'Users with similar taste enjoyed this'**
  String get usersLikeYouEnjoyed;

  /// No description provided for @becauseYouEnjoyGenre.
  ///
  /// In en, this message translates to:
  /// **'Because you enjoy {genre}'**
  String becauseYouEnjoyGenre(String genre);

  /// No description provided for @recentlyReleased.
  ///
  /// In en, this message translates to:
  /// **'Recently released'**
  String get recentlyReleased;

  /// No description provided for @hiddenGem.
  ///
  /// In en, this message translates to:
  /// **'Hidden gem — highly rated but undiscovered'**
  String get hiddenGem;

  /// No description provided for @criticallyAcclaimed.
  ///
  /// In en, this message translates to:
  /// **'Critically acclaimed'**
  String get criticallyAcclaimed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
