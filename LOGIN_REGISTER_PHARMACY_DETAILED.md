# 🔐 شرح تفصيلي لـ Logic اللوجن والريجستر

## 1️⃣ **كود اللوجن (من LoginPage)**

```dart
void login(BuildContext context) {
  final authCubit = context.read<AuthCubit>();

  final String email = authCubit.emailController.text;
  final String password = authCubit.passwordController.text;

  // تنشئ request بسيط فقط البريد وكلمة المرور
  final LoginRequestBody requestBody = LoginRequestBody(
    email: email,
    password: password,
  );

  if (email.isNotEmpty && password.isNotEmpty) {
    // تستدعي login method من cubit
    authCubit.login(requestBody);
  }
}
```

### الخطوات في `AuthCubit.login()`:

```dart
Future<void> login(LoginRequestBody body) async {
  try {
    // Step 1: تصدر loading state
    emit(AuthState.loading());
    
    // Step 2: تستدعي API
    final result = await auth.loginWithEmailPassword(body);
    
    // Step 3: تتعامل مع النتيجة
    result.when(
      success: (loginResponse) async {
        if (loginResponse.user != null) {
          // Step 4: تنشئ AppUser object
          final user = AppUser(
            id: loginResponse.user!.id ?? '',
            name: loginResponse.user!.username ?? '',
            email: loginResponse.user!.email ?? '',
            phoneNumber: loginResponse.user!.phoneNumber,
            role: loginResponse.user!.role,
            isEmailVerified: loginResponse.user!.isEmailVerified,
            token: loginResponse.token,  // ✅ التوكن مهم هنا!
          );
          
          // Step 5: تحفظ بيانات المستخدم محلياً
          _currentUser = user;

          // Step 6: تحفظ التوكن في SharedPreferences
          await saveUserToken(loginResponse.token ?? '');

          // Step 7: تمسح جميع الحقول
          clearAllFields();

          // Step 8: تصدر authenticated state
          emit(AuthState.authenticated(user));
          
          // => AuthGate يشوف هذا الـ state ويأخذك للـ Home Page 🏠
        } else {
          emit(AuthState.unauthenticated());
        }
      },
      failure: (error) {
        // معالجة الأخطاء مع رسائل friendly
        final friendlyMessage =
            _getFriendlyErrorMessage(error.apiErrorModel.message, 'login');
        emit(AuthState.error(friendlyMessage));
        emit(AuthState.unauthenticated());
      },
    );
  } catch (e) {
    final friendlyMessage = _getFriendlyErrorMessage(e.toString(), 'login');
    emit(AuthState.error(friendlyMessage));
    emit(AuthState.unauthenticated());
  }
}
```

---

## 2️⃣ **كود الريجستر العادي (من RegisterPage)**

```dart
// مشابه لـ Login لكن مع معلومات أكثر:
void register(BuildContext context) {
  final authCubit = context.read<AuthCubit>();

  final String username = authCubit.nameController.text;
  final String email = authCubit.emailController.text;
  final String phoneNumber = authCubit.phoneNumberController.text;
  final String password = authCubit.passwordController.text;

  // نفس النمط!
  final SignupRequestBody requestBody = SignupRequestBody(
    username: username,
    email: email,
    phoneNumber: phoneNumber,
    password: password,
  );

  if (validation passes) {
    authCubit.register(requestBody);  // ← نفس الطريقة!
  }
}
```

### الخطوات في `AuthCubit.register()`:

```dart
Future<void> register(SignupRequestBody requestBody) async {
  try {
    emit(AuthState.loading());
    final result = await auth.registerWithEmailPassword(requestBody);
    
    result.when(
      success: (signupResponse) {
        if (signupResponse.user != null) {
          // لا نستقبل توكن في Registration! ❌
          // لأن البريد يجب أن يتم التحقق منه أولاً
          
          _pendingVerificationEmail = requestBody.email;

          clearAllFields();

          // نصدر emailVerificationPending بدل authenticated ⚠️
          emit(AuthState.emailVerificationPending(requestBody.email));
          
          // => AuthGate يشوف هذا الـ state ويأخذك لصفحة تحقق من البريد 📧
        } else {
          emit(AuthState.unauthenticated());
        }
      },
      failure: (error) {
        final friendlyMessage =
            _getFriendlyErrorMessage(error.apiErrorModel.message, 'register');
        emit(AuthState.error(friendlyMessage));
        emit(AuthState.unauthenticated());
      },
    );
  } catch (e) {
    final friendlyMessage =
        _getFriendlyErrorMessage(e.toString(), 'register');
    emit(AuthState.error(friendlyMessage));
    emit(AuthState.unauthenticated());
  }
}
```

---

## 3️⃣ **كود ريجستر الصيدلية (من PharmacyRegisterStepTwoPage)**

```dart
void registerPharmacy(BuildContext context) async {
  final authCubit = context.read<AuthCubit>();
  
  final String username = authCubit.nameController.text;
  final String email = authCubit.emailController.text;
  final String phoneNumber = authCubit.phoneNumberController.text;
  final String password = authCubit.passwordController.text;
  final String pharmacyName = authCubit.pharmacyNameController.text;
  final String address = selectedAddress;
  
  // ✅ الفرق الأساسي: نضيف location بصيغة GeoJSON
  final requestBody = PharmacyRegisterRequestBody(
    username: username,
    email: email,
    phoneNumber: phoneNumber,
    password: password,
    role: 'pharmacy',  // ← دور الصيدلي
    pharmacyName: pharmacyName,
    address: address,
    location: {  // ← معلومة إضافية
      'type': 'Point',  // ← GeoJSON format
      'coordinates': [selectedLongitude!, selectedLatitude!],  // ← [lng, lat]
    },
  );

  // نفس النمط تماماً!
  await authCubit.registerPharmacy(requestBody);
}
```

### الخطوات في `AuthCubit.registerPharmacy()`:

```dart
Future<void> registerPharmacy(PharmacyRegisterRequestBody requestBody) async {
  try {
    emit(AuthState.loading());
    final result = await auth.registerPharmacy(requestBody);
    
    result.when(
      success: (pharmacyResponse) {
        if (pharmacyResponse.user != null) {
          // نفس الخطوات مثل Register عادي!
          _pendingVerificationEmail = requestBody.email;

          clearPharmacyFields();  // ← clear الحقول الخاصة بالصيدلية

          emit(AuthState.emailVerificationPending(requestBody.email));
          
          // => ننتظر تحقق من البريد 📧
        } else {
          emit(AuthState.unauthenticated());
        }
      },
      failure: (error) {
        final friendlyMessage =
            _getFriendlyErrorMessage(
              error.apiErrorModel.message, 
              'pharmacy_register'  // ← special handling للصيدلية
            );
        emit(AuthState.error(friendlyMessage));
        emit(AuthState.unauthenticated());
      },
    );
  } catch (e) {
    final friendlyMessage =
        _getFriendlyErrorMessage(e.toString(), 'pharmacy_register');
    emit(AuthState.error(friendlyMessage));
    emit(AuthState.unauthenticated());
  }
}
```

---

## 🎯 تلخيص النمط (Pattern):

```
┌─────────────────────────────────────────────┐
│         UI Page (Login/Register)             │
│  - جمع البيانات من الـ TextFields           │
│  - بناء Request Body                        │
│  - استدعاء Cubit Method                    │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│         AuthCubit (Logic Layer)             │
│  - emit(loading)                            │
│  - استدعاء Repository                      │
│  - معالجة النتيجة (success/failure)       │
│  - emit state جديد                          │
│  - حفظ البيانات في SharedPrefs              │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│    AuthRepository (Data Access)            │
│  - استدعاء API Service                     │
│  - معالجة الأخطاء                          │
│  - إرجاع ApiResult<Response>               │
└────────────────┬────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────┐
│      ApiService (Networking)               │
│  - استدعاء الـ Endpoint                    │
│  - تحويل Request بـ toJson()               │
│  - استقبال Response                       │
└─────────────────────────────────────────────┘
```

---

## 🚨 الأخطاء الشائعة وحلولها:

### ❌ الخطأ: `type 'String' is not a subtype of type 'Map<String, dynamic>'`

**السبب:** الـ location يُرسل كـ String بدل Map

**الحل:**
```dart
// ❌ خطأ:
location: PharmacyLocation(
  coordinates: [latitude, longitude],
).toJson()  // ← هذا يرسل كـ String في بعض الحالات

// ✅ صحيح:
location: {
  'type': 'Point',
  'coordinates': [longitude, latitude],
}
```

### ❌ الخطأ: لا يوجد توكن بعد الريجستر

**السبب:** عملية الريجستر لا تعيد توكن مباشرة

**الحل:** انتظر التحقق من البريد أولاً، بعدها ستستقبل التوكن

### ❌ الخطأ: البريد والكلمة المرور غير صحيحة

**السبب:** معالجة خاطئة للأخطاء

**الحل:** استخدم `_getFriendlyErrorMessage()` للحصول على رسائل خطأ واضحة

---

## ✅ Checklist لـ Implementation صحيح:

- [ ] Request Body له `toJson()` صحيح
- [ ] Response له `fromJson()` صحيح
- [ ] API Endpoint يقبل الـ Content-Type: application/json
- [ ] Location بصيغة GeoJSON: `{type: "Point", coordinates: [lng, lat]}`
- [ ] التوكن يُحفظ بعد اللوجن فقط، لا بعد الريجستر
- [ ] البريد يُتحقق منه في خطوة منفصلة
- [ ] الأخطاء لها رسائل friendly للمستخدم
- [ ] State transitions صحيحة (loading → success → next page)
