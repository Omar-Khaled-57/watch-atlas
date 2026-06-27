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
  String get appearance => 'المظهر';

  @override
  String get account => 'الحساب';

  @override
  String get userProfile => 'الملف الشخصي للمستخدم';

  @override
  String get failedToLoadProfile => 'فشل تحميل الملف الشخصي';

  @override
  String get profileNotFound => 'الملف الشخصي غير موجود';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get moderation => 'الرقابة';

  @override
  String get recommendationsAndPrivacy => 'التوصيات والخصوصية';

  @override
  String get personalizedRecommendations => 'توصيات مخصصة';

  @override
  String get activityImprovesSuggestions => 'اجعل نشاطك يحسن التوصيات';

  @override
  String get clearRecommendationHistory => 'مسح سجل التوصيات';

  @override
  String get removeAllBehavioralData => 'إزالة جميع البيانات السلوكية';

  @override
  String get chooseTheme => 'اختر المظهر';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get followSystem => 'اتباع إعدادات النظام';

  @override
  String get displayName => 'الاسم المعروض';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get age => 'العمر';

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get ratherNotSay => 'أفضل عدم الإفصاح';

  @override
  String get viewTracking => 'عرض التتبع';

  @override
  String get viewAnalytics => 'عرض التحليلات';

  @override
  String get signOutConfirmation => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get sendResetLink => 'إرسال رابط إعادة التعيين';

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
  String minutesAgo(double count) {
    return '$count دقيقة مضت';
  }

  @override
  String hoursAgo(double count) {
    return '$count ساعة مضت';
  }

  @override
  String daysAgo(double count) {
    return '$count يوم مضت';
  }

  @override
  String weeksAgo(Object weeks) {
    return 'منذ $weeks أ';
  }

  @override
  String monthsAgo(double count) {
    return '$count شهر مضى';
  }

  @override
  String yearsAgo(Object years) {
    return 'منذ $years س';
  }

  @override
  String get termsOfServiceTitle => 'شروط الخدمة';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get termsOfServiceBody =>
      'باستخدامك لووتش أطلس، فإنك توافق على هذه الشروط. يرجى قراءتها بعناية.\n\n[توضع الشروط الكاملة هنا]';

  @override
  String get privacyPolicyBody =>
      'خصوصيتك تهمنا.\n\n[توضع سياسة الخصوصية الكاملة هنا]';

  @override
  String get lastUpdated => 'آخر تحديث: 26 يونيو 2026';

  @override
  String get acceptanceOfTerms => '1. قبول الشروط';

  @override
  String get acceptanceOfTermsBody =>
      'باستخدامك أو الوصول إلى واتش أطلس، فإنك توافق على الالتزام بشروط الخدمة هذه. إذا كنت لا توافق، فلا تستخدم الخدمة.';

  @override
  String get descriptionOfService => '2. وصف الخدمة';

  @override
  String get descriptionOfServiceBody =>
      'واتش أطلس هو تطبيق لتتبع الوسائط يسمح للمستخدمين باكتشاف وتتبع وتنظيم الأفلام والمسلسلات والأنمي. يمكن للمستخدمين التقييم والمراجعة والحفاظ على قوائم المشاهدة.';

  @override
  String get userAccounts => '3. حسابات المستخدمين';

  @override
  String get userAccountsBody =>
      'يجب تسجيل الدخول عبر Google OAuth لاستخدام الخدمة. أنت مسؤول عن الحفاظ على سرية حسابك. يجب أن يكون عمرك 13 عامًا على الأقل لاستخدام هذه الخدمة.';

  @override
  String get userResponsibilities => '4. مسؤوليات المستخدم';

  @override
  String get userResponsibilitiesBody =>
      'توافق على عدم نشر محتوى مسيء أو مضايق أو غير لائق؛ عدم انتحال شخصية الآخرين؛ عدم محاولة التحايل على إجراءات الأمان؛ وعدم استخدام الخدمة لأي غرض غير قانوني. أنت مسؤول عن جميع الأنشطة التي تحدث تحت حسابك.';

  @override
  String get acceptableUse => '5. الاستخدام المقبول';

  @override
  String get acceptableUseBody =>
      'يجوز لك استخدام الخدمة لأغراض قانونية فقط. توافق على عدم التداخل مع سلامة أو أداء الخدمة أو محاولة الوصول غير المصرح به إلى أي جزء من الخدمة أو الأنظمة ذات الصلة.';

  @override
  String get userGeneratedContent => '6. المحتوى الذي ينشئه المستخدم';

  @override
  String get userGeneratedContentBody =>
      'أنت تحتفظ بملكية المحتوى الذي تنشئه، بما في ذلك القوائم والتقييمات والمراجعات والملاحظات ومعلومات الملف الشخصي. باستخدامك الخدمة، فإنك تمنح واتش أطلس ترخيصًا عالميًا غير حصري لتخزين وعرض وتوزيع هذا المحتوى في connection with تقديم الخدمة. أنت المسول الوحيد عن المحتوى الذي ترسله.';

  @override
  String get intellectualProperty => '7. الملكية الفكرية';

  @override
  String get intellectualPropertyBody =>
      'يتم توفير بيانات الوسائط والصور بواسطة TMDB وAniList بموجب تراخيص كل منهما. تطبيق واتش أطلس والكود مملوك. المحتوى الذي ينشئه المستخدم (المراجعات، التقييمات، القوائم) يظل ملكًا لك، مع ترخيص لواتش أطلس لعرضه داخل الخدمة.';

  @override
  String get thirdPartyServicesTerms => '8. خدمات الطرف الثالث';

  @override
  String get thirdPartyServicesTermsBody =>
      'قد تحتوي الخدمة على روابط أو تدمج مع خدمات طرف ثالث، بما في ذلك TMDB وAniList وGoogle OAuth. يحكم استخدامك لخدمات الطرف الثالث شروطها وسياسات الخصوصية الخاصة بها. واتش أطلس غير مسؤول عن ممارسات أو محتوى خدمات الطرف الثالث.';

  @override
  String get externalLinks => '9. الروابط الخارجية';

  @override
  String get externalLinksBody =>
      'قد تحتوي الخدمة على روابط لمواقع أو موارد خارجية. واتش أطلس غير مسؤول عن توفر أو محتوى هذه المواقع الخارجية ولا ي Endorse أي محتوى أو منتجات أو خدمات متاحة منها.';

  @override
  String get availabilityOfService => '10. توفر الخدمة';

  @override
  String get availabilityOfServiceBody =>
      'نسعى للحفاظ على الخدمة متاحة وآمنة ومحدثة. ومع ذلك، لا نضمن وصولًا غير منقطع. قد تكون الخدمة غير متاحة مؤقتًا بسبب الصيانة أو التحديثات أو عوامل خارجة عن سيطرتنا.';

  @override
  String get changesToFeatures => '11. التغييرات على الميزات';

  @override
  String get changesToFeaturesBody =>
      'قد نقوم بتعديل أو تحديث أو إيقاف ميزات الخدمة في أي وقت، مع أو بدون إشعار. لسنا مسؤولين تجاهك أو أي طرف ثالث عن أي تعديل أو تعليق أو إيقاف للخدمة أو أي جزء منها.';

  @override
  String get accountSuspension => '12. تعليق أو إنهاء الحساب';

  @override
  String get accountSuspensionBody =>
      'نحتفظ بالحق في تعليق أو إنهاء الحسابات التي تنتهك هذه الشروط. يمكنك حذف حسابك والبيانات المرتبطة به في أي وقت من خلال إعدادات التطبيق أو عن طريق الاتصال بنا.';

  @override
  String get disclaimers => '13. إخلاء المسؤولية';

  @override
  String get disclaimersBody =>
      'يتم توفير الخدمة كما هي وكما هي متاحة. لا نقدم أي ضمانات، صريحة أو ضمنية، بشأن دقة أو موثوقية أو توفر الخدمة. لا نضمن أن بيانات الوسائط أو التوصيات أو نتائج البحث ستكون خالية من الأخطاء أو تلبي توقعاتك.';

  @override
  String get privacyReference => '14. الخصوصية';

  @override
  String get privacyReferenceBody =>
      'استخدامك للخدمة يحكمه أيضًا سياسة الخصوصية الخاصة بنا. يرجى مراجعة سياسة الخصوصية الخاصة بنا لفهم كيفية جمع واستخدام وحماية معلوماتك الشخصية.';

  @override
  String get changesToTerms => '15. التغييرات على الشروط';

  @override
  String get changesToTermsBody =>
      'قد نقوم بتحديث هذه الشروط في أي وقت. الاستمرار في الاستخدام بعد التغييرات يعتبر قبولًا. سيتم إخطار المستخدمين بالتغييرات الجوهرية عبر البريد الإلكتروني أو الإشعار داخل التطبيق.';

  @override
  String get contactSection => '16. الاتصال';

  @override
  String get contactLegal =>
      'للاستفسارات حول هذه الشروط، اتصل: legal@watchatlas.app';

  @override
  String get contactPrivacy =>
      'للاستفسارات المتعلقة بالخصوصية، اتصل: privacy@watchatlas.app';

  @override
  String get informationWeCollect => '1. المعلومات التي نجمعها';

  @override
  String get informationWeCollectBody =>
      'عند تسجيل الدخول عبر Google OAuth، نجمع عنوان بريدك الإلكتروني واسم العرض. نقوم أيضًا بتخزين الوسائط التي تتابعها (أفلام، مسلسلات، أنمي) مع حالة المشاهدة والتقييمات والمراجعات. الصور الرمزية وأسماء العرض مخزنة عبر Supabase storage.\n\nالمعلومات الاختيارية التي قد تقدمها تشمل تاريخ الميلاد والجنس، وتُستخدم فقط لتخصيص تجربتك.';

  @override
  String get automaticallyCollectedData => '2. البيانات المجمعة تلقائيًا';

  @override
  String get automaticallyCollectedDataBody =>
      'قد نجمع تلقائيًا معلومات معينة عند استخدامك للتطبيق، بما في ذلك نوع الجهاز وإصخدام التطبيق وتقارير الأعطال إن وجدت. تتم معالجة بيانات المصادقة بواسطة موفر المصادقة لدينا (Google OAuth) للحفاظ على جلستك بأمان.';

  @override
  String get howWeUseInfo => '3. كيف نستخدم معلوماتك';

  @override
  String get howWeUseInfoBody =>
      'تُستخدم معلوماتك لتقديم الخدمة وتحسينها: تخصيص تجربتك، والحفاظ على قوائم المشاهدة والمراجعات، وإنشاء توصيات بناءً على نشاطك، وإبلاغك بتحديثات الخدمة إذا لزم الأمر.';

  @override
  String get dataStorage => '4. تخزين البيانات والأمان';

  @override
  String get dataStorageBody =>
      'يتم تخزين بياناتك بشكل آمن على Supabase وGoogle Cloud. نستخدم أمان مستوى الصف لضمان وصولك إلى بياناتك فقط. لا يتم تخزين كلمات المرور مطلقًا — تتم المصادقة بالكامل عبر Google OAuth. جميع عمليات نقل البيانات تستخدم اتصالات HTTPS آمنة.';

  @override
  String get thirdPartyServicesPrivacy => '5. خدمات الطرف الثالث';

  @override
  String get thirdPartyServicesPrivacyBody =>
      'نستخدم TMDB لجلب بيانات الوسائط. يتم إرسال عمليات البحث ومعرفات الوسائط التي تعرضها إلى API الخاص بـ TMDB. نستخدم أيضًا AniList لبيانات الأنمي. Google OAuth يُستخدم للمصادقة. كل خدمة طرف ثالث تعالج البيانات وفقًا لسياسة الخصوصية الخاصة بها.';

  @override
  String get cookiesLocalStorage => '6. ملفات تعريف الارتباط والتخزين المحلي';

  @override
  String get cookiesLocalStorageBody =>
      'نستخدم التخزين المحلي للحفاظ على جلستك، وتذكر تفضيلاتك (مثل المظهر واللغة)، وتخزين البيانات مؤقتًا لتحسين الأداء. لا نستخدم ملفات تعريف الارتباط للتتبع أو تقنيات مماثلة لأغراض إعلانية.';

  @override
  String get dataRetention => '7. الاحتفاظ بالبيانات';

  @override
  String get dataRetentionBody =>
      'يتم الاحتفاظ ببياناتك طالما أن حسابك نشط. يمكنك حذف حسابك والبيانات المرتبطة به في أي وقت عن طريق الاتصال بنا أو استخدام ميزة حذف الحساب في التطبيق.';

  @override
  String get yourRights => '8. حقوقك';

  @override
  String get yourRightsBody =>
      'يحق لك طلب نسخة من بياناتك، أو تصحيح البيانات غير الدقيقة، أو حذف حسابك والبيانات المرتبطة به في أي وقت. يمكنك تحديث معلومات ملفك الشخصي، وإدارة تفضيلات التخصيص، وتغيير لغتك، أو تسجيل الخروج في أي وقت من خلال إعدادات التطبيق.';

  @override
  String get childrensPrivacy => '9. خصوصية الأطفال';

  @override
  String get childrensPrivacyBody =>
      'واتش أطلس مخصص للمستخدمين من عمر 13 عامًا فما فوق. لا نجمع عن علم معلومات شخصية من الأطفال دون سن 13. إذا كنت والدًا أو وصياً وتعتقد أن طفلك قدم لنا معلومات شخصية، فيرجى الاتصال بنا لنتخذ الإجراء المناسب.';

  @override
  String get policyUpdates => '10. تحديثات السياسة';

  @override
  String get policyUpdatesBody =>
      'قد نقوم بتحديث سياسة الخصوصية هذه من وقت لآخر. سنقوم بإعلامك بأي تغييرات جوهرية عن طريق نشر السياسة المحدثة في التطبيق وتحديث تاريخ آخر تحديث أعلاه. استمرارك في استخدام الخدمة بعد التغييرات يعتبر قبولًا للسياسة المحدثة.';

  @override
  String get openSourceNotice => 'إشعار المصدر المفتوح';

  @override
  String get openSourceNoticeBody =>
      'واتش أطلس يستخدم مكتبات وأطر عمل مفتوحة المصدر المختلفة. نعترم بامتنان بمساهمات مجتمع المصادر المفتوحة. تطبق التراخيص الخاصة بهذه المكتبات على استخدامها داخل هذا التطبيق.';

  @override
  String get thirdPartyLibraries => 'مكتبات الطرف الثالث';

  @override
  String get thirdPartyLibrariesBody =>
      'يتضمن هذا التطبيق مكونات برمجية مفتوحة المصدر. تتوفر تفاصيل الترخيص لهذه المكونات من خلال صفحة الترخيص أدناه.';

  @override
  String get mediaOwnership => 'ملكية الوسائط';

  @override
  String get mediaOwnershipBody =>
      'بيانات الوسائط والملصقات والصور الخلفية والشعارات والأعمال الفنية الترويجية الخاصة بالأفلام والمسلسلات والأنمي والوسائط الأخرى هي ملك لأصحابها وحاملي حقوق الطبع والنشر. واتش أطلس لا يدعي ملكية أي أصول وسائط طرف ثالث. يُستخدم هذا المحتوى لأغراض التعريف والتصنيف والمعلومات فقط.';

  @override
  String get aiGeneratedLogo => 'الشعار المُنشأ بالذكاء الاصطناعي';

  @override
  String get aiGeneratedLogoBody =>
      'تم إنشاء شعار تطبيق واتش أطلس باستخدام أدوات تصميم بمساعدة الذكاء الاصطناعي. الشعار يستخدم كهوية بصرية للتطبيق. واتش أطلس لا يدعي ملكية حصرية للنموذج الأساسي للذكاء الاصطناعي أو الأسلوب المُنشأ أو البيانات التدريبية المستخدمة في إنشائه. أي حقوق مرتبطة بالشعار المُنشأ تخضع لشروط خدمة الذكاء الاصطناعي المستخدمة في إنشائه. يجب عدم تفسير الشعار على أنه يدعي ملكية منهجيات الذكاء الاصطناعي المُنشأة أو الملكية الفكرية الطرف الثالث.';

  @override
  String get trademarks => 'العلامات التجارية';

  @override
  String get trademarksBody =>
      'عناوين الأفلام والمسلسلات والأنمي وأسماء الاستوديوهات ومنصات البث وأسماء الشركات والعلامات التجارية الظاهرة في التطبيق هي ملك لأصحابها. ظهورها داخل واتش أطلس لأغراض التعريف والتصنيف والمعلومات فقط.';

  @override
  String get metadataAttribution => 'البيانات الوصفية';

  @override
  String get metadataAttributionBody =>
      'معلومات الوسائط المعروضة في التطبيق — بما في ذلك العناوين والأوصاف والتقييمات والأنواع وتواريخ الإصدار وطاقم التمثيل والإنتاج والمدة — يتم الحصول عليها من موفرين طرف ثالث، chiefly TMDB و AniList. يتم توفير هذه البيانات لأغراض إعلامية وقد تحتوي أحيانًا على أخطاء أو تكون قديمة.';

  @override
  String get imagesAttribution => 'الصور';

  @override
  String get imagesAttributionBody =>
      'الملصقات والصور الخلفية والشعارات والأعمال الفنية الترويجية المعروضة في التطبيق هي ملك لأصحاب حقوق الطبع والنشرrespective وتُستخدم بموجب ترخيص أو لأغراق التعريف فقط. واتش أطلس لا يدعي ملكية أي أصول بصرية.';

  @override
  String get recommendationSystemInfo => 'نظام التوصيات';

  @override
  String get recommendationSystemInfoBody =>
      'يتم إنشاء التوصيات تلقائيًا بناءً على نشاطك وتفضيلاتك، مثل ما تشاهده وتقيّمه وتحفظه وتبحث عنه. الهدف هو تحسين اكتشاف المحتوى. التوصيات هي اقتراحات وليست ضمانات، ولا تعكس أي تأييد رسمي من منشئي المحتوى أو الموزعين.';

  @override
  String get userContentOwnership => 'محتوى المستخدم';

  @override
  String get userContentOwnershipBody =>
      'أنت تحتفظ بملكية المحتوى الذي تنشئه في واتش أطلس، بما في ذلك القوائم والتقييمات والملاحظات. باستخدامك الخدمة، فإنك تمنح واتش أطلس الحقوق اللازمة لتخزين وعرض ومعالجة هذا المحتوى داخل التطبيق. أنت مسؤول عن المحتوى الذي ترسله ويجب أن تحترم حقوق الآخرين.';

  @override
  String get accuracyDisclaimer => 'الدقة';

  @override
  String get accuracyDisclaimerBody =>
      'على الرغم من سعي واتش أطلس لتقديم معلومات دقيقة ومحدثة، قد تحتوي البيانات الوصفية أحيانًا على أخطاء أو معلومات قديمة بسبب اعتمادها على مصادر طرف ثالث. نشجع المستخدمين على التحقق من التفاصيل المهمة من خلال المصادر الرسمية.';

  @override
  String get contentAndAttribution => 'المحتوى والنسب';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get pleaseConfirmPassword => 'الرجاء تأكيد كلمة المرور';

  @override
  String get enterEmailForReset =>
      'أدخل بريدك الإلكتروني لتلقي رابط إعادة تعيين كلمة المرور';

  @override
  String get backToSignIn => 'العودة إلى تسجيل الدخول';

  @override
  String get orContinueWith => 'أو المتابعة عبر';

  @override
  String get setUpProfile => 'إعداد ملفك الشخصي';

  @override
  String get chooseAvatar => 'اختر صورة رمزية';

  @override
  String get uploadPhoto => 'رفع صورة';

  @override
  String get orPickDefault => 'أو اختر واحدة من الصور الافتراضية أدناه';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get selectDateOfBirth => 'اختر تاريخ الميلاد';

  @override
  String get completeSetup => 'إكمال الإعداد';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'معرض الصور';

  @override
  String get mustBe13 =>
      'يجب أن يكون عمرك 13 عامًا على الأقل لاستخدام هذا التطبيق';

  @override
  String get failedToSaveProfile => 'فشل حفظ الملف الشخصي';

  @override
  String get invalidEmailOrPassword => 'بريد إلكتروني أو كلمة مرور غير صحيحة';

  @override
  String get pleaseConfirmEmail => 'الرجاء تأكيد بريدك الإلكتروني';

  @override
  String get accountAlreadyExists => 'يوجد حساب بهذا البريد الإلكتروني بالفعل';

  @override
  String get chooseAccount => 'اختر حسابًا';

  @override
  String get continueWithGoogle => 'المتابعة عبر Google';

  @override
  String get signInToGoogle => 'تسجيل الدخول إلى حساب Google';

  @override
  String get previouslyUsed => 'مستخدم سابقًا';

  @override
  String get signInTo => 'تسجيل الدخول إلى';

  @override
  String get tryAnotherAccount => 'جرب حسابًا آخر';

  @override
  String get useDifferentGoogleAccount => 'استخدام حساب Google مختلف';

  @override
  String get couldNotLoadContinueWatching => 'تعذر تحميل متابعة المشاهدة';

  @override
  String get noContentInProgress => 'لا يوجد محتوى قيد المشاهدة';

  @override
  String get searchMoviesTv => 'ابحث عن أفلام، مسلسلات...';

  @override
  String get searchFailed => 'فشل البحث';

  @override
  String get discover => 'اكتشف';

  @override
  String get tryAdjustingFilters => 'حاول تعديل عوامل التصفية';

  @override
  String get searchMoviesTvAnime => 'ابحث عن أفلام، مسلسلات، أنمي...';

  @override
  String get advancedFilters => 'عوامل تصفية متقدمة';

  @override
  String get allCountries => 'جميع الدول';

  @override
  String get yearRange => 'نطاق السنة';

  @override
  String get ratingRange => 'نطاق التقييم';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get applyFilters => 'تطبيق عوامل التصفية';

  @override
  String get failedToLoadDetails => 'فشل تحميل التفاصيل';

  @override
  String get writeReview => 'كتابة مراجعة';

  @override
  String get noReviewsYet => 'لا توجد مراجعات بعد. كن أول من يراجع!';

  @override
  String get failedToLoadReviews => 'فشل تحميل المراجعات';

  @override
  String get noRecentActivity => 'لا نشاط حديث';

  @override
  String get createNewList => 'إنشاء قائمة جديدة';

  @override
  String get addedTo => 'تمت الإضافة إلى';

  @override
  String addedToTitle(String title) {
    return 'تمت الإضافة إلى \"$title\"';
  }

  @override
  String get listCreated => 'تم إنشاء القائمة';

  @override
  String get removeFromTrackingList => 'إزالة من هذه القائمة';

  @override
  String get tracking => 'التتبع';

  @override
  String get recentlyUpdated => 'تم التحديث مؤخرًا';

  @override
  String get noMediaInList => 'لا توجد وسائط في هذه القائمة';

  @override
  String get failedToLoadTracking => 'فشل تحميل بيانات التتبع';

  @override
  String get myCollections => 'مجموعاتي';

  @override
  String get allCollections => 'جميع المجموعات';

  @override
  String get selectList => 'اختر قائمة';

  @override
  String get chooseListFromSidebar =>
      'اختر قائمة من الشريط الجانبي لعرض محتوياتها';

  @override
  String get yourCollections => 'مجموعاتك';

  @override
  String get allItems => 'جميع العناصر';

  @override
  String get noItemsInList => 'لا توجد عناصر في هذه القائمة';

  @override
  String get addMediaFromDetails => 'أضف وسائط من صفحة التفاصيل';

  @override
  String get noOtherListsToMoveTo => 'لا توجد قوائم أخرى للنقل إليها';

  @override
  String get noOtherListsToCopyTo => 'لا توجد قوائم أخرى للنسخ إليها';

  @override
  String get moveTo => 'نقل إلى...';

  @override
  String get copyTo => 'نسخ إلى...';

  @override
  String get movedTo => 'تم النقل إلى';

  @override
  String get copiedTo => 'تم النسخ إلى';

  @override
  String get removedFromList => 'تمت الإزالة من القائمة';

  @override
  String get toggleView => 'تبديل العرض';

  @override
  String get searchItems => 'ابحث عن عناصر...';

  @override
  String get failedToLoadList => 'فشل تحميل القائمة';

  @override
  String get listNotFound => 'القائمة غير موجودة';

  @override
  String get listCouldNotBeFound => 'لم يتم العثور على هذه القائمة';

  @override
  String checkOutMyList(Object title) {
    return 'تحقق من قائمتي: $title على WatchAtlas';
  }

  @override
  String get failedToLoadItems => 'فشل تحميل العناصر';

  @override
  String get enterListName => 'أدخل اسم القائمة';

  @override
  String get titleRequired => 'العنوان مطلوب';

  @override
  String get descriptionOptional => 'الوصف (اختياري)';

  @override
  String get describeList => 'صف هذه القائمة';

  @override
  String get anyoneCanSee => 'يمكن لأي شخص رؤية هذه القائمة';

  @override
  String get onlyYouCanSee => 'أنت فقط من يمكنه رؤية هذه القائمة';

  @override
  String get othersCanAddRemove => 'يمكن للآخرين إضافة وإزالة العناصر';

  @override
  String get noItemsMatch => 'لا توجد عناصر مطابقة';

  @override
  String get across => 'عبر';

  @override
  String deleteListConfirm(Object title) {
    return 'حذف \"$title\"?';
  }

  @override
  String get deleteListWarning =>
      'سيؤدي هذا إلى إزالة القائمة وجميع إدخالات الوسائط بشكل دائم. لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get listDeleted => 'تم الحذف';

  @override
  String get community => 'المجتمع';

  @override
  String get failedToLoadFollowing => 'فشل تحميل المتابَعين';

  @override
  String get notFollowingAnyone => 'لا تتابع أحدًا';

  @override
  String get findFriendsToFollow => 'ابحث عن أصدقاء لمتابعتهم ورؤية نشاطهم.';

  @override
  String get failedToLoadFollowers => 'فشل تحميل المتابعين';

  @override
  String get noFollowersYet => 'لا يوجد متابعون بعد';

  @override
  String get whenSomeoneFollowsYou => 'عندما يتابعك شخص ما، سيظهر هنا.';

  @override
  String get failedToLoadActivity => 'فشل تحميل النشاط';

  @override
  String get noFriendActivity => 'لا يوجد نشاط للأصدقاء';

  @override
  String get activityFromPeopleYouFollow =>
      'سيظهر نشاط الأشخاص الذين تتابعهم هنا.';

  @override
  String get searchByUsername => 'ابحث باسم المستخدم...';

  @override
  String get failedToLoadNotifications => 'فشل تحميل الإشعارات';

  @override
  String get youreAllCaughtUp => 'كل شيء محدث!';

  @override
  String get clearAllNotificationsConfirm => 'مسح جميع الإشعارات؟';

  @override
  String get clearAllWarning =>
      'لا يمكن التراجع عن هذا الإجراء. سيتم حذف جميع الإشعارات بشكل دائم.';

  @override
  String get unknown => 'غير معروف';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get accessDenied => 'تم رفض الوصول';

  @override
  String get noModeratorPermissions => 'ليس لديك صلاحيات المشرف.';

  @override
  String get reports => 'التقارير';

  @override
  String get failedToLoadReports => 'فشل تحميل التقارير';

  @override
  String get noPendingReports => 'لا توجد تقارير معلقة';

  @override
  String get allClear => 'كل شيء على ما يرام!';

  @override
  String get reportedUser => 'المستخدم المُبلغ عنه';

  @override
  String get mediaId => 'معرف الوسائط';

  @override
  String get reporter => 'المُبلغ';

  @override
  String get takeAction => 'اتخاذ إجراء';

  @override
  String get warnUser => 'تحذير المستخدم';

  @override
  String get sendWarningToUser => 'إرسال تحذير إلى المستخدم';

  @override
  String get hideContent => 'إخفاء المحتوى';

  @override
  String get makeContentInvisible => 'جعل المحتوى غير مرئي للمستخدمين';

  @override
  String get deleteContent => 'حذف المحتوى';

  @override
  String get permanentlyRemoveContent => 'إزالة هذا المحتوى بشكل دائم';

  @override
  String get confirmDeletion => 'تأكيد الحذف';

  @override
  String get confirmDeleteContent =>
      'هل أنت متأكد أنك تريد حذف هذا المحتوى بشكل دائم؟';

  @override
  String get banUser => 'حظر المستخدم';

  @override
  String get permanentlyBanUser => 'حظر هذا المستخدم بشكل دائم من المنصة';

  @override
  String get confirmBan => 'تأكيد الحظر';

  @override
  String get confirmBanUser =>
      'هل أنت متأكد أنك تريد حظر هذا المستخدم نهائيًا؟';

  @override
  String get ban => 'حظر';

  @override
  String get users => 'المستخدمون';

  @override
  String get failedToLoadUsers => 'فشل تحميل المستخدمين';

  @override
  String get noUsersFound => 'لم يتم العثور على مستخدمين';

  @override
  String get staff => 'الموظفون';

  @override
  String get roleUser => 'مستخدم';

  @override
  String get roleModerator => 'مشرف';

  @override
  String get roleAdmin => 'مدير';

  @override
  String get failedToLoadStats => 'فشل تحميل الإحصائيات';

  @override
  String get yearlyActivity => 'النشاط السنوي';

  @override
  String get countryDistribution => 'توزيع الدول';

  @override
  String get ratingDistribution => 'توزيع التقييمات';

  @override
  String get avgRating => 'متوسط التقييم';

  @override
  String get mostWatchedDecade => 'العقد الأكثر مشاهدة';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة بعد';

  @override
  String get other => 'أخرى';

  @override
  String get totalItems => 'إجمالي العناصر';

  @override
  String get splashSubtitle => 'قائمة مشاهدتك العالمية';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي بنجاح';

  @override
  String get enterDisplayName => 'أدخل اسم العرض';

  @override
  String get displayNameMax50 => 'يجب ألا يتجاوز اسم العرض 50 حرفًا';

  @override
  String get tellOthersAboutYourself => 'أخبر الآخرين عن نفسك';

  @override
  String get bioMax500 => 'يجب ألا تتجاوز السيرة الذاتية 500 حرف';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get confirm => 'تأكيد';

  @override
  String get continueAction => 'متابعة';

  @override
  String get remove => 'إزالة';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get move => 'نقل';

  @override
  String get copy => 'نسخ';

  @override
  String get create => 'إنشاء';

  @override
  String get name => 'الاسم';

  @override
  String get title => 'العنوان';

  @override
  String get description => 'الوصف';

  @override
  String get visibility => 'الرؤية';

  @override
  String get type => 'النوع';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get items => 'عناصر';

  @override
  String get item => 'عنصر';

  @override
  String get noResultsForSearch => 'لا توجد نتائج';

  @override
  String get tryDifferentSearchTerm => 'جرب مصطلح بحث مختلف';

  @override
  String get watchingBadge => 'مشاهدة';

  @override
  String get completedBadge => 'مكتمل';

  @override
  String get onHoldBadge => 'معلق';

  @override
  String get droppedBadge => 'ملغي';

  @override
  String get planToWatchBadge => 'مخطط';

  @override
  String get rewatchingBadge => 'إعادة مشاهدة';

  @override
  String removeListTitle(String title) {
    return 'إزالة \"$title\"؟';
  }

  @override
  String get removeFromListWarning =>
      'سيؤدي هذا إلى إزالة العنصر من هذه القائمة.';

  @override
  String get clearActivityWarning =>
      'سيؤدي هذا إلى إزالة جميع بيانات نشاطك المستخدمة للتوصيات. هل ترغب في المتابعة؟';

  @override
  String get englishLanguage => 'English';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String get deleteAccountWarning =>
      'هذا الإجراء دائم ولا يمكن التراجع عنه. سيتم حذف جميع بياناتك.';

  @override
  String get aboutAppDescription =>
      'منصة حديثة لتتبع الوسائط لاكتشاف وتتبع ومشاركة أفلامك، مسلسلاتك المفضلة، والمزيد.';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get inYourList => 'في قائمتك';

  @override
  String get inYourLibrary => 'في مكتبتك';

  @override
  String get addedLabel => 'أُضيف';

  @override
  String get updatedLabel => 'مُحدث';

  @override
  String get notTracked => 'غير متتبع';

  @override
  String get detailsLabel => 'التفاصيل';

  @override
  String recommendationReason(String reason) {
    return 'سبب التوصية: $reason';
  }

  @override
  String get likeLabel => 'إعجاب';

  @override
  String get previousSlide => 'الشريحة السابقة';

  @override
  String get nextSlide => 'الشريحة التالية';

  @override
  String errorWithDetails(String error) {
    return 'خطأ: $error';
  }

  @override
  String get reviewsScreen => 'شاشة المراجعات';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عنصر',
      many: '$count عنصرًا',
      few: '$count عناصر',
      two: 'عنصران',
      one: 'عنصر واحد',
      zero: '0 عناصر',
    );
    return '$_temp0';
  }

  @override
  String movedToTitle(String title) {
    return 'تم النقل إلى \"$title\"';
  }

  @override
  String copiedToTitle(String title) {
    return 'تم النسخ إلى \"$title\"';
  }

  @override
  String ratedStars(double stars) {
    return 'مُقيم بـ $stars نجوم';
  }

  @override
  String get allFilter => 'الكل';

  @override
  String listDeletedTitle(String title) {
    return 'تم حذف \"$title\"';
  }

  @override
  String episodeProgress(int current, int total) {
    return '$current‏/‏$total';
  }

  @override
  String countryWithCode(String name, String code) {
    return '$name ($code)';
  }

  @override
  String mediaWithId(String id) {
    return 'وسائط #$id';
  }

  @override
  String get unknownList => 'قائمة غير معروفة';

  @override
  String get profileDatabaseError =>
      'تأكد من تطبيق منح قاعدة البيانات.\nقم بتشغيل supabase/grants.sql في محرر SQL الخاص بـ Supabase.';

  @override
  String get accountCreated =>
      'تم إنشاء الحساب! تحقق من بريدك الإلكتروني للحصول على رابط التأكيد قبل تسجيل الدخول.';

  @override
  String get notificationChannelDescription => 'إشعارات من واتش أطلس';

  @override
  String get anonymous => 'مجهول';

  @override
  String get contentReport => 'تقرير محتوى';

  @override
  String get userReport => 'تقرير مستخدم';

  @override
  String get reportPending => 'معلق';

  @override
  String get reportResolved => 'تم الحل';

  @override
  String get continueWithApple => 'المتابعة عبر Apple';

  @override
  String get popularTrending => 'رائج';

  @override
  String get recommendationBecauseYouSaved => 'لأنك حفظت...';

  @override
  String get recommendationBecauseYouViewed => 'لأنك شاهدت...';

  @override
  String get recommendationTrendingNearYou => 'رائع بالقرب منك';

  @override
  String get recommendationPopularThisWeek => 'الأكثر شعبية هذا الأسبوع';

  @override
  String get recommendationContinueExploring => 'متابعة الاستكشاف';

  @override
  String get recommendationNewReleases => 'إصدارات حديثة';

  @override
  String get recommendationHiddenGems => 'جوهرة مخفية';

  @override
  String get recommendationCriticallyAcclaimed => 'مشهور نقديًا';

  @override
  String get recommendationTopRated => 'الأعلى تقييمًا';

  @override
  String get recommendationSimilarToFavorites => 'مشابه لتفضيلاتك';

  @override
  String get recommendationBecauseYouLikeGenre => 'لأنك تحب...';

  @override
  String get recommendationFriendsAlsoSaved => 'أصدقاؤك حفظوها أيضًا';

  @override
  String get recommendationUsersLikeYou => 'مستخدمون مثلك استمتعوا بهذا';

  @override
  String get recommendationAwardWinners => 'فائزون بجوائز';

  @override
  String get recommendationUnderratedClassics => 'كلاسيكيات غير معترف بها';

  @override
  String get recommendationUpcomingReleases => 'إصدارات قادمة';

  @override
  String get similarToSaved => 'مشابه لما حفظته';

  @override
  String get forYou => 'لك';

  @override
  String get seeMore => 'عرض المزيد';

  @override
  String get allRecommendations => 'جميع التوصيات';

  @override
  String get viewAllRecommendations => 'عرض جميع التوصيات';

  @override
  String get recommendationCategories => 'فئات التوصيات';

  @override
  String get failedToLoadRecommendations => 'فشل تحميل التوصيات';

  @override
  String get noRecommendationsYet => 'لا توجد توصيات بعد';

  @override
  String get navRecommendations => 'التوصيات';

  @override
  String get similarToFavorites => 'مشابه لتفضيلاتك';

  @override
  String get usersLikeYouEnjoyed => 'مستخدمون بذوق مشابه استمتعوا بهذا';

  @override
  String becauseYouEnjoyGenre(String genre) {
    return 'لأنك تحب $genre';
  }

  @override
  String get recentlyReleased => 'أُصدِر مؤخرًا';

  @override
  String get hiddenGem => 'جوهرة مخفية — تقييم عالي وغير معروف';

  @override
  String get criticallyAcclaimed => 'مشهور نقديًا';
}
