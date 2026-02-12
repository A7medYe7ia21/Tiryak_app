# نظام Authentication الصيدليات - وثائق شاملة

## المقدمة
تم تطوير نظام authentication كامل للصيدليات يتبع نفس معايير المشروع الموجودة. يتضمن التسجيل، التحقق من البريد الإلكتروني، وإدارة الحسابات.

## المكونات الرئيسية

### 1. Models (البيانات)
#### `pharmacy_register_request_body.dart`
```dart
PharmacyRegisterRequestBody({
  required String username,
  required String email,
  required String phoneNumber,
  required String password,
  required String role,           // "pharmacy"
  required String pharmacyName,
  required String address,
  required PharmacyLocation location,
})
```

**البيانات المطلوبة:**
- `username`: اسم المستخدم (فريد)
- `email`: البريد الإلكتروني
- `phoneNumber`: رقم الهاتف
- `password`: كلمة المرور (يجب أن تحتوي على أحرف كبيرة وصغيرة وأرقام ورموز خاصة)
- `role`: دائماً "pharmacy"
- `pharmacyName`: اسم الصيدلية
- `address`: عنوان الصيدلية
- `location`: إحداثيات GPS (latitude, longitude)

#### `pharmacy_register_response.dart`
```dart
PharmacyRegisterResponse({
  String? message,
  AppUser? user,
})
```

يحتوي على:
- `message`: رسالة من الخادم
- `user`: بيانات المستخدم (الصيدلية) المسجل

### 2. API Integration

#### تحديث `api_constants.dart`
تمت إضافة endpoint جديد:
```dart
static const String pharmacyRegister = "/auth/pharmacy/register";
```

#### تحديث `api_service.dart`
```dart
@POST(ApiConstants.pharmacyRegister)
Future<PharmacyRegisterResponse> pharmacyRegister(
  @Body() PharmacyRegisterRequestBody pharmacyRegisterRequestBody,
);
```

### 3. Repository Pattern

#### تحديث `auth.repo.dart`
```dart
Future<ApiResult<PharmacyRegisterResponse>> registerPharmacy(
    PharmacyRegisterRequestBody body);
```

#### تطبيق في `auth.dart`
```dart
@override
Future<ApiResult<PharmacyRegisterResponse>> registerPharmacy(
    PharmacyRegisterRequestBody body) async {
  try {
    final response = await _apiService.pharmacyRegister(body);
    return ApiResult.success(response);
  } catch (e) {
    return ApiResult.failure(ErrorHandler.handle(e));
  }
}
```

### 4. Business Logic (Cubit)

#### تحديث `auth_cubit.dart`

**إضافة Controllers:**
```dart
TextEditingController pharmacyNameController = TextEditingController();
TextEditingController pharmacyAddressController = TextEditingController();
TextEditingController pharmacyLatitudeController = TextEditingController();
TextEditingController pharmacyLongitudeController = TextEditingController();
```

**إضافة Method:**
```dart
Future<void> registerPharmacy(PharmacyRegisterRequestBody requestBody) async {
  try {
    emit(AuthState.loading());
    final result = await auth.registerPharmacy(requestBody);
    result.when(
      success: (pharmacyResponse) {
        if (pharmacyResponse.user != null) {
          _pendingVerificationEmail = requestBody.email;
          clearPharmacyFields();
          emit(AuthState.emailVerificationPending(requestBody.email));
        } else {
          emit(AuthState.unauthenticated());
        }
      },
      failure: (error) {
        final friendlyMessage = _getFriendlyErrorMessage(
            error.apiErrorModel.message, 'pharmacy_register');
        emit(AuthState.error(friendlyMessage));
        emit(AuthState.unauthenticated());
      },
    );
  } catch (e) {
    final friendlyMessage = _getFriendlyErrorMessage(e.toString(), 'pharmacy_register');
    emit(AuthState.error(friendlyMessage));
    emit(AuthState.unauthenticated());
  }
}
```

### 5. UI Screens

#### `pharmacy_register_step_one_page.dart`
**الخطوة الأولى من التسجيل:**
- جمع بيانات المستخدم الأساسية:
  - اسم المستخدم (username)
  - البريد الإلكتروني (email)
  - رقم الهاتف (phoneNumber)
  - اسم الصيدلية (pharmacyName)

#### `pharmacy_register_step_two_page.dart`
**الخطوة الثانية من التسجيل:**
- جمع بيانات الموقع:
  - العنوان (address)
  - خط العرض (latitude)
  - خط الطول (longitude)
- جمع بيانات الأمان:
  - كلمة المرور (password)
  - تأكيد كلمة المرور (confirmPassword)
- التحقق من قوة كلمة المرور
- إرسال البيانات للخادم

#### تحديث `user_type_selection_screen.dart`
```dart
void _navigateToPharmacyFlow(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PharmacyRegisterStepOnePage(onTap: () {}),
    ),
  );
}
```

## تدفق العملية (Flow)

### 1. اختيار نوع المستخدم
```
UserTypeSelectionScreen
        ↓
اختيار "I'm a Pharmacy"
        ↓
```

### 2. الخطوة الأولى
```
PharmacyRegisterStepOnePage
├── Input: username, email, phoneNumber, pharmacyName
├── Validation: Email format, Phone format
└── Next → Step Two
```

### 3. الخطوة الثانية
```
PharmacyRegisterStepTwoPage
├── Input: address, latitude, longitude, password
├── Input: confirm password
├── Validation:
│   ├── Password strength (Upper, Lower, Number, Special, Min length)
│   ├── Coordinates validation (double parsing)
│   └── Password matching
├── Call: registerPharmacy()
└── Result:
    ├── Success → Email Verification Pending
    └── Error → Show error message
```

### 4. API Request
```json
{
  "username": "pharmacyA",
  "email": "tahanyemad30@gmail.com",
  "phoneNumber": "+201012345678",
  "password": "SecurePass123!",
  "role": "pharmacy",
  "pharmacyName": "Al-Shifa Pharmacy",
  "address": "Zagazig City",
  "location": {
    "coordinates": [31.5021, 30.5877]
  }
}
```

### 5. API Response
```json
{
  "message": "User registered successfully. Please check your email to verify your account.",
  "user": {
    "_id": "68f513cf900810baea96335f",
    "username": "pharmacyA",
    "email": "tahanyemad30@gmail.com",
    "phoneNumber": "01012345678",
    "role": "pharmacy",
    "isEmailVerified": false,
    "createdAt": "2025-10-19T16:37:35.767Z",
    "updatedAt": "2025-10-19T16:37:35.767Z"
  }
}
```

## معالجة الأخطاء

يتم التعامل مع الأخطاء التالية تلقائياً:

```dart
if (operation == 'pharmacy_register') {
  // Email already exists
  'An account with this email already exists.'
  
  // Phone already exists
  'This phone number is already registered.'
  
  // Invalid email format
  'Please enter a valid email address.'
  
  // Weak password
  'Password does not meet security requirements.'
  
  // Invalid coordinates
  'Invalid pharmacy location.'
  
  // Missing pharmacy name
  'Please enter a pharmacy name.'
  
  // Missing address
  'Please enter the pharmacy address.'
}
```

## تحديث AppUser Model

تم تحديث `user.model.dart` لتشمل حقول الصيدلية:

```dart
class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? role;
  final bool? isEmailVerified;
  final String? token;
  final String? pharmacyName;      // ✅ جديد
  final String? address;            // ✅ جديد
  final PharmacyLocation? location; // ✅ جديد
  // ...
}

class PharmacyLocation {
  final List<double> coordinates;
  // ...
}
```

## مميزات النظام

✅ **نفس معايير المشروع:**
- استخدام BLoC/Cubit
- معالجة أخطاء شاملة
- Localization دعم كامل
- Validation قوي

✅ **خصائص الصيدليات:**
- تخزين بيانات الموقع (Coordinates)
- تخزين اسم الصيدلية والعنوان
- دعم التحقق من البريد الإلكتروني
- إدارة آمنة للبيانات

✅ **واجهة مستخدم:**
- خطوتان واضحتان للتسجيل
- تحقق من البيانات على كل خطوة
- رسائل خطأ صديقة للمستخدم
- دعم اللغة العربية والإنجليزية

## الخطوات التالية المقترحة

1. **تشغيل البناء:**
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **إضافة stringات الترجمة إلى `ar.json` و `en.json`:**
   ```json
   {
     "register_pharmacy": "تسجيل صيدلية",
     "pharmacy_name": "اسم الصيدلية",
     "pharmacy_details": "تفاصيل الصيدلية",
     "enter_location_details": "أدخل تفاصيل الموقع",
     "address": "العنوان",
     "latitude": "خط العرض",
     "longitude": "خط الطول",
     "invalid_coordinates": "إحداثيات غير صحيحة"
   }
   ```

3. **اختبار الواجهة:**
   - اختبار التحقق من البيانات
   - اختبار الأخطاء
   - اختبار الملاحة

4. **تطبيق تسجيل الدخول للصيدليات:**
   - استخدام نفس `loginWithEmailPassword` مع `role: pharmacy`
   - تحديث الـ routing بناءً على الـ role

## ملفات تم تعديلها

- ✅ `lib/features/auth/data/model/user.model.dart` - تحديث AppUser
- ✅ `lib/features/auth/data/model/pharmacy_register_request_body.dart` - نموذج Request جديد
- ✅ `lib/features/auth/data/model/pharmacy_register_response.dart` - نموذج Response جديد
- ✅ `lib/core/networking/api_constants.dart` - إضافة endpoint جديد
- ✅ `lib/core/networking/api_service.dart` - إضافة method جديد
- ✅ `lib/features/auth/data/repo/auth.repo.dart` - تحديث abstract class
- ✅ `lib/features/auth/data/repo/auth.dart` - تطبيق method جديد
- ✅ `lib/features/auth/logic/auth_cubit.dart` - إضافة method وcontrollers للصيدلية
- ✅ `lib/features/auth/ui/pharmacy_register_step_one_page.dart` - جديد
- ✅ `lib/features/auth/ui/pharmacy_register_step_two_page.dart` - جديد
- ✅ `lib/features/onBoarding/user_type_selection_screen.dart` - تحديث navigation

## ملاحظات مهمة

⚠️ **يجب تشغيل:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

لإنشاء ملفات `.g.dart` الضرورية للـ serialization.

⚠️ **تذكر إضافة الترجمات** للنصوص الجديدة في ملفات `en.json` و `ar.json`.
