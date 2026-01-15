import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'To-Do App',
      'addTask': 'Add Task',
      'editTask': 'Edit Task',
      'title': 'Title',
      'description': 'Description',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'deleteConfirm': 'Delete this task?',
      'yes': 'Yes',
      'no': 'No',
      'noTasks': 'No tasks yet!\nTap + to add your first task',
      'completed': 'Completed',
      'pending': 'Pending',
      'titleRequired': 'Title is required',
      'clearCompleted': 'Clear Completed',
      'all': 'All',
      'active': 'Active',
    },
    'ar': {
      'appTitle': 'قائمة المهام',
      'addTask': 'إضافة مهمة',
      'editTask': 'تعديل مهمة',
      'title': 'العنوان',
      'description': 'الوصف',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'deleteConfirm': 'هل تريد حذف هذه المهمة؟',
      'yes': 'نعم',
      'no': 'لا',
      'noTasks': 'لا توجد مهام بعد!\nاضغط + لإضافة أول مهمة',
      'completed': 'مكتملة',
      'pending': 'قيد الانتظار',
      'titleRequired': 'العنوان مطلوب',
      'clearCompleted': 'مسح المكتملة',
      'all': 'الكل',
      'active': 'نشطة',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}