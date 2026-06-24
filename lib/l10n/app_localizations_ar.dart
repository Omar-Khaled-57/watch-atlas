// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'واتش أطلس';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get loadingMore => 'جارٍ تحميل المزيد...';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get search => 'بحث';

  @override
  String get edit => 'تعديل';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get ok => 'موافق';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get noInternet => 'لا يوجد اتصال بالإنترنت';

  @override
  String get pullToRefresh => 'اسحب للتحديث';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDiscover => 'اكتشف';

  @override
  String get navSearch => 'بحث';

  @override
  String get navLists => 'القوائم';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get signInWithGoogle => 'تسجيل الدخول عبر Google';

  @override
  String get signInWithApple => 'تسجيل الدخول عبر Apple';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get trendingNow => 'رائج الآن';

  @override
  String get popularThisWeek => 'الأكثر مشاهدة هذا الأسبوع';

  @override
  String get continueWatching => 'مشاهدة مستمرة';

  @override
  String get recentlyAdded => 'أُضيف مؤخرًا';

  @override
  String get upcomingReleases => 'الإصدارات القادمة';

  @override
  String get recommendedForYou => 'موصى به لك';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get movies => 'أفلام';

  @override
  String get tvShows => 'مسلسلات';

  @override
  String get anime => 'أنمي';

  @override
  String get kdrama => 'دراما كورية';

  @override
  String get ratings => 'التقييمات';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get cast => 'طاقم التمثيل';

  @override
  String get crew => 'طاقم العمل';

  @override
  String get trailers => 'المقاطع الدعائية';

  @override
  String get recommendations => 'التوصيات';

  @override
  String get reviews => 'المراجعات';

  @override
  String get similar => 'مشابهة';

  @override
  String get addToList => 'أضف إلى القائمة';

  @override
  String get share => 'مشاركة';

  @override
  String get mediaType => 'نوع الوسائط';

  @override
  String get releaseDate => 'تاريخ الإصدار';

  @override
  String get runtime => 'المدة';

  @override
  String get genres => 'التصنيفات';

  @override
  String get status => 'الحالة';

  @override
  String get language => 'اللغة';

  @override
  String get country => 'البلد';

  @override
  String get watching => 'يشاهد';

  @override
  String get completed => 'مكتمل';

  @override
  String get onHold => 'متوقف';

  @override
  String get dropped => 'تم الإلغاء';

  @override
  String get planToWatch => 'يخطط للمشاهدة';

  @override
  String get rewatching => 'يعيد المشاهدة';

  @override
  String get myTracking => 'تتبعي';

  @override
  String get totalWatched => 'إجمالي المشاهدات';

  @override
  String get totalEpisodes => 'إجمالي الحلقات';

  @override
  String get totalHours => 'إجمالي الساعات';

  @override
  String get progress => 'التقدم';

  @override
  String get updateStatus => 'تحديث الحالة';

  @override
  String get addToTracking => 'أضف إلى التتبع';

  @override
  String get removeFromTracking => 'إزالة من التتبع';

  @override
  String trackingCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناوين',
      one: 'عنوان واحد',
    );
    return '$_temp0';
  }

  @override
  String episodeCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حلقات',
      one: 'حلقة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get myLists => 'قوائمي';

  @override
  String get createList => 'إنشاء قائمة';

  @override
  String get listTitle => 'عنوان القائمة';

  @override
  String get listDescription => 'وصف القائمة';

  @override
  String get publicList => 'عام';

  @override
  String get privateList => 'خاص';

  @override
  String get collaborative => 'تعاوني';

  @override
  String addToListTitle(Object title) {
    return 'أضف $title إلى القائمة';
  }

  @override
  String get noListsYet => 'لا توجد قوائم بعد';

  @override
  String get createFirstList => 'أنشئ قائمتك الأولى';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get bio => 'السيرة الذاتية';

  @override
  String get followers => 'المتابعون';

  @override
  String get following => 'يتابع';

  @override
  String get activity => 'النشاط';

  @override
  String get stats => 'الإحصائيات';

  @override
  String joinedOn(Object date) {
    return 'انضم في $date';
  }

  @override
  String get findFriends => 'البحث عن أصدقاء';

  @override
  String get follow => 'متابعة';

  @override
  String get unfollow => 'إلغاء المتابعة';

  @override
  String get friendActivity => 'نشاط الأصدقاء';

  @override
  String get noFriendsYet => 'لا يوجد أصدقاء بعد';

  @override
  String get suggestedFriends => 'أصدقاء مقترحون';

  @override
  String get searchHint => 'ابحث عن أفلام، مسلسلات، أنمي...';

  @override
  String get searchHistory => 'سجل البحث';

  @override
  String get trendingSearches => 'عمليات البحث الرائجة';

  @override
  String get noResults => 'لم يتم العثور على نتائج';

  @override
  String get filters => 'عوامل التصفية';

  @override
  String get clearHistory => 'مسح السجل';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get clearAll => 'مسح الكل';

  @override
  String get noNotifications => 'لا توجد إشعارات بعد';

  @override
  String notificationFollow(Object name) {
    return 'بدأ $name بمتابعتك';
  }

  @override
  String notificationLike(Object name) {
    return 'أعجب $name بمراجعتك';
  }

  @override
  String notificationComment(Object name) {
    return 'علق $name على مراجعتك';
  }

  @override
  String notificationList(Object name) {
    return 'أضافك $name إلى قائمة';
  }

  @override
  String get settings => 'الإعدادات';

  @override
  String get theme => 'المظهر';

  @override
  String get contentLanguage => 'لغة المحتوى';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get lightMode => 'الوضع الفاتح';

  @override
  String get systemMode => 'وضع النظام';

  @override
  String get about => 'حول';

  @override
  String get appVersion => 'إصدار التطبيق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get licenses => 'التراخيص';

  @override
  String get rateApp => 'تقييم التطبيق';

  @override
  String get shareApp => 'مشاركة التطبيق';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get yourStats => 'إحصائياتك';

  @override
  String get totalWatchedCount => 'إجمالي المشاهدات';

  @override
  String get totalHoursCount => 'إجمالي الساعات';

  @override
  String get averageRating => 'متوسط التقييم';

  @override
  String get genreDistribution => 'توزيع التصنيفات';

  @override
  String get weeklyActivity => 'النشاط الأسبوعي';

  @override
  String get monthlyActivity => 'النشاط الشهري';

  @override
  String get favoriteGenre => 'التصنيف المفضل';

  @override
  String get favoriteCountry => 'البلد المفضل';

  @override
  String get mostWatchedGenre => 'التصنيف الأكثر مشاهدة';

  @override
  String get topRated => 'الأعلى تقييمًا';

  @override
  String get recentActivity => 'النشاط الأخير';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(Object minutes) {
    return 'منذ $minutes د';
  }

  @override
  String hoursAgo(Object hours) {
    return 'منذ $hours س';
  }

  @override
  String daysAgo(Object days) {
    return 'منذ $days ي';
  }

  @override
  String weeksAgo(Object weeks) {
    return 'منذ $weeks أ';
  }

  @override
  String monthsAgo(Object months) {
    return 'منذ $months ش';
  }

  @override
  String yearsAgo(Object years) {
    return 'منذ $years س';
  }
}
