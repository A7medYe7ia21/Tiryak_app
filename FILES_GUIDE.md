# 📁 دليل الملفات الكامل

## 📚 ملفات التوثيق (في جذر المشروع)

```
c:\Users\1223\Desktop\tryiak\
├── QUICK_START.md (⭐ ابدأ من هنا)
│   └── خطوات البدء السريعة - 3 خطوات فقط
│
├── README_PHARMACY_AUTH.md
│   └── ملخص النهائي - ما تم إنجازه
│
├── PHARMACY_AUTH_COMPLETE_GUIDE.md
│   └── دليل شامل - 15+ قسم
│
├── PHARMACY_AUTH_DOCUMENTATION.md
│   └── توثيق تقني - شرح كل مكون
│
├── PHARMACY_AUTH_SUMMARY.md
│   └── ملخص سريع - نقاط رئيسية
│
├── PHARMACY_DATA_MODEL.md
│   └── نموذج البيانات - Request/Response
│
├── BUILD_RUNNER_REQUIRED.md
│   └── تحذير - لا تنسى البناء
│
└── CHECKLIST.md
    └── قائمة الفحص - تحقق من كل شيء
```

---

## ✅ الملفات المنشأة (جديدة)

### 📁 `lib/features/auth/data/model/`
```dart
pharmacy_register_request_body.dart
├── class PharmacyRegisterRequestBody
│   ├── username: string
│   ├── email: string
│   ├── phoneNumber: string
│   ├── password: string
│   ├── role: string ("pharmacy")
│   ├── pharmacyName: string
│   ├── address: string
│   ├── location: PharmacyLocation
│   ├── toJson()
│   └── generated: pharmacy_register_request_body.g.dart ⚙️
│
└── class PharmacyLocation
    ├── coordinates: List<double>
    ├── toJson()
    └── generated: pharmacy_register_request_body.g.dart ⚙️

pharmacy_register_response.dart
├── class PharmacyRegisterResponse
│   ├── message: string?
│   ├── user: AppUser?
│   ├── fromJson() factory
│   ├── toJson()
│   └── generated: pharmacy_register_response.g.dart ⚙️
```

### 📁 `lib/features/auth/ui/`
```dart
pharmacy_register_step_one_page.dart (165 سطر)
├── PharmacyRegisterStepOnePage class
├── Form validation
├── TextField widgets
├── IntlPhoneField
├── Navigation to Step Two
└── Error handling

pharmacy_register_step_two_page.dart (301 سطر)
├── PharmacyRegisterStepTwoPage class
├── Location input (Latitude/Longitude)
├── Password validation
├── PasswordValidations widget
├── API integration
├── Error handling
└── Loading state
```

---

## 🔄 الملفات المعدلة (تحديثات)

### 📁 `lib/core/networking/`
```dart
api_constants.dart
├── NEW: pharmacyRegister = "/auth/pharmacy/register"
└── هذا هو الـ endpoint الجديد

api_service.dart
├── NEW: pharmacyRegister() method
├── @POST(ApiConstants.pharmacyRegister)
├── Parameter: PharmacyRegisterRequestBody
└── Return: PharmacyRegisterResponse
```

### 📁 `lib/features/auth/data/repo/`
```dart
auth.repo.dart (Abstract)
├── NEW: Future<ApiResult<PharmacyRegisterResponse>> registerPharmacy()
└── Interface definition

auth.dart (Implementation)
├── NEW: registerPharmacy() implementation
├── Error handling
├── API call
└── Result mapping
```

### 📁 `lib/features/auth/data/model/`
```dart
user.model.dart
├── UPDATED: AppUser class
│   ├── NEW: pharmacyName: string?
│   ├── NEW: address: string?
│   ├── NEW: location: PharmacyLocation?
│   ├── UPDATED: fromJson()
│   └── UPDATED: toJson()
│
└── NEW: PharmacyLocation class
    ├── coordinates: List<double>
    ├── fromJson() factory
    └── toJson()
```

### 📁 `lib/features/auth/logic/`
```dart
auth_cubit.dart
├── NEW: 4 Pharmacy Controllers
│   ├── pharmacyNameController
│   ├── pharmacyAddressController
│   ├── pharmacyLatitudeController
│   └── pharmacyLongitudeController
│
├── NEW: registerPharmacy() method
│   ├── Validation
│   ├── API call
│   ├── Error handling
│   └── State emission
│
├── NEW: clearPharmacyFields() method
│   └── Clear all pharmacy controllers
│
└── UPDATED: _getFriendlyErrorMessage()
    └── Add pharmacy_register case
```

### 📁 `lib/features/onBoarding/`
```dart
user_type_selection_screen.dart
├── UPDATED: _navigateToPharmacyFlow()
│   ├── NEW: Navigator.push()
│   ├── Create PharmacyRegisterStepOnePage
│   └── Replace context.go()
│
└── Removed: context.go(AppPath.pharmacyHome)
```

### 📁 `assets/l10n/`
```json
en.json
├── NEW (22): register_pharmacy
├── NEW (23): enter_account_details
├── NEW (24): please_enter_valid_username
├── NEW (25): please_enter_valid_email
├── NEW (26): please_enter_valid_phone
├── NEW (27): pharmacy_name
├── NEW (28): please_enter_pharmacy_name
├── NEW (29): pharmacy_details
├── NEW (30): enter_location_details
├── NEW (31): address
├── NEW (32): please_enter_address
├── NEW (33): latitude
├── NEW (34): please_enter_latitude
├── NEW (35): longitude
├── NEW (36): please_enter_longitude
├── NEW (37): invalid_number
├── NEW (38): invalid_coordinates
├── NEW (39): username
├── NEW (40): passwords_dont_match
├── NEW (41): set_password
├── NEW (42): create_secure_password
└── NEW (43): register

ar.json
├── NEW (22 كلمة عربية مطابقة)
└── جميع الترجمات مكتملة
```

---

## 📊 ملخص الإحصائيات

```
Total Files Created: 4
├── pharmacy_register_request_body.dart
├── pharmacy_register_response.dart
├── pharmacy_register_step_one_page.dart
└── pharmacy_register_step_two_page.dart

Total Files Modified: 9
├── api_constants.dart
├── api_service.dart
├── auth.repo.dart
├── auth.dart
├── auth_cubit.dart
├── user.model.dart
├── user_type_selection_screen.dart
├── en.json
└── ar.json

Total Documentation Files: 8
├── QUICK_START.md
├── README_PHARMACY_AUTH.md
├── PHARMACY_AUTH_COMPLETE_GUIDE.md
├── PHARMACY_AUTH_DOCUMENTATION.md
├── PHARMACY_AUTH_SUMMARY.md
├── PHARMACY_DATA_MODEL.md
├── BUILD_RUNNER_REQUIRED.md
└── CHECKLIST.md

Total Lines of Code: 1000+
Total Translations: 22 (English + Arabic)
Generated Files (.g.dart): 2 (needs build_runner)
```

---

## 🔗 الروابط بين الملفات

```
user_type_selection_screen.dart
    ↓ (imports)
pharmacy_register_step_one_page.dart
    ↓ (imports)
pharmacy_register_step_two_page.dart
    ↓ (calls)
auth_cubit.registerPharmacy()
    ↓ (calls)
auth.registerPharmacy()
    ↓ (calls)
api_service.pharmacyRegister()
    ↓ (POST to)
/auth/pharmacy/register
    ↓ (returns)
PharmacyRegisterResponse
    ↓ (parses to)
AppUser
```

---

## 🎯 ترتيب القراءة الموصى به

1. **QUICK_START.md** ⭐ (ابدأ هنا - 2 دقيقة)
2. **README_PHARMACY_AUTH.md** (ملخص شامل - 5 دقائق)
3. **PHARMACY_AUTH_COMPLETE_GUIDE.md** (دليل كامل - 15 دقيقة)
4. **PHARMACY_DATA_MODEL.md** (البيانات - 10 دقائق)
5. **CHECKLIST.md** (تحقق من كل شيء - 5 دقائق)
6. **PHARMACY_AUTH_DOCUMENTATION.md** (تفاصيل تقنية - 20 دقيقة)

**المجموع:** ~60 دقيقة لفهم كامل

---

## 📂 الهيكل الكامل للمشروع

```
tryiak/
├── 📄 QUICK_START.md ⭐
├── 📄 README_PHARMACY_AUTH.md
├── 📄 PHARMACY_AUTH_COMPLETE_GUIDE.md
├── 📄 PHARMACY_AUTH_DOCUMENTATION.md
├── 📄 PHARMACY_AUTH_SUMMARY.md
├── 📄 PHARMACY_DATA_MODEL.md
├── 📄 BUILD_RUNNER_REQUIRED.md
├── 📄 CHECKLIST.md
│
└── lib/
    ├── features/
    │   ├── auth/
    │   │   ├── data/
    │   │   │   ├── model/
    │   │   │   │   ├── ✨ pharmacy_register_request_body.dart
    │   │   │   │   ├── ✨ pharmacy_register_response.dart
    │   │   │   │   ├── ✅ user.model.dart (updated)
    │   │   │   │   └── ...
    │   │   │   └── repo/
    │   │   │       ├── ✅ auth.repo.dart (updated)
    │   │   │       ├── ✅ auth.dart (updated)
    │   │   │       └── ...
    │   │   ├── logic/
    │   │   │   ├── ✅ auth_cubit.dart (updated)
    │   │   │   └── ...
    │   │   └── ui/
    │   │       ├── ✨ pharmacy_register_step_one_page.dart
    │   │       ├── ✨ pharmacy_register_step_two_page.dart
    │   │       └── ...
    │   │
    │   └── onBoarding/
    │       ├── ✅ user_type_selection_screen.dart (updated)
    │       └── ...
    │
    ├── core/
    │   └── networking/
    │       ├── ✅ api_constants.dart (updated)
    │       ├── ✅ api_service.dart (updated)
    │       └── ...
    │
    └── ...
│
└── assets/
    └── l10n/
        ├── ✅ en.json (updated +22)
        ├── ✅ ar.json (updated +22)
        └── ...
```

---

## ⚙️ ملفات يجب إنشاؤها تلقائياً

بعد تشغيل `flutter pub run build_runner build`:

```
lib/features/auth/data/model/
├── pharmacy_register_request_body.g.dart ⚙️
└── pharmacy_register_response.g.dart ⚙️

lib/core/networking/
└── api_service.g.dart ⚙️ (تحديث - إضافة method جديد)
```

---

## ✨ الملفات الجديدة الرئيسية

| الملف | السطور | الوصف |
|--------|--------|--------|
| pharmacy_register_step_one_page.dart | 165 | الخطوة الأولى للتسجيل |
| pharmacy_register_step_two_page.dart | 301 | الخطوة الثانية للتسجيل |
| pharmacy_register_request_body.dart | 40 | نموذج الطلب |
| pharmacy_register_response.dart | 20 | نموذج الرد |

**المجموع:** ~526 سطر من الكود الجديد

---

## 🔄 الملفات المحدثة الرئيسية

| الملف | الإضافات |
|--------|----------|
| auth_cubit.dart | 4 controllers + 2 methods + error handling |
| auth.dart | 1 implementation |
| auth.repo.dart | 1 interface |
| user.model.dart | 3 fields + 1 class |
| api_service.dart | 1 method |
| api_constants.dart | 1 endpoint |
| user_type_selection_screen.dart | 1 method |
| en.json | 22 translations |
| ar.json | 22 translations |

---

**كل الملفات جاهزة للاستخدام! ✅**
