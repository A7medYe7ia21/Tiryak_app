# شرح عملية اللوجن (Login) والريجستر (Register) 🔐

## 📊 الفرق بين Login و Register

### 1️⃣ **عملية اللوجن (Login Flow)**

#### المسار في الكود:
```
UI (LoginPage) → AuthCubit.login() → AuthRepo.loginWithEmailPassword() → ApiService.login()
```

#### Request Body:
```dart
LoginRequestBody {
  email: "user@email.com",
  password: "@Password123"
}
```

#### Response:
```json
{
  "message": "Login successful",
  "user": {
    "_id": "userId123",
    "username": "username",
    "email": "user@email.com",
    "phoneNumber": "0123456789",
    "role": "user",
    "isEmailVerified": true,
    "createdAt": "2026-01-28T14:26:50.560Z",
    "updatedAt": "2026-01-28T14:26:50.560Z"
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### ما يحدث بعد النجاح:
```dart
// 1. تحفظ التوكن في SharedPreferences
await saveUserToken(loginResponse.token ?? '');

// 2. تضع التوكن في header لكل الطلبات التالية
DioFactory.setTokenIntoHeaderAfterLogin(token);

// 3. تحفظ بيانات المستخدم
_currentUser = user;

// 4. تصدر state authenticated
emit(AuthState.authenticated(user));

// 5. تتجه تلقائياً للـ Home Page
// (عن طريق AuthGate في auth_gate.dart)
```

---

### 2️⃣ **عملية الريجستر (Register Flow)**

#### المسار في الكود:
```
UI (RegisterPage) → AuthCubit.register() → AuthRepo.registerWithEmailPassword() → ApiService.register()
```

#### Request Body:
```dart
SignupRequestBody {
  username: "username",
  email: "user@email.com",
  phoneNumber: "0123456789",
  password: "@Password123"
}
```

#### Response:
```json
{
  "message": "User registered successfully. Please verify your email.",
  "user": {
    "_id": "userId123",
    "username": "username",
    "email": "user@email.com",
    "phoneNumber": "0123456789",
    "role": "user",
    "isEmailVerified": false,
    "createdAt": "2026-01-28T14:26:50.560Z",
    "updatedAt": "2026-01-28T14:26:50.560Z"
  }
}
```

#### ما يحدث بعد النجاح:
```dart
// 1. لا تحفظ التوكن (لأنه غير موجود بعد)

// 2. تحفظ البريد المراد التحقق من صحته
_pendingVerificationEmail = requestBody.email;

// 3. تصدر state emailVerificationPending
emit(AuthState.emailVerificationPending(requestBody.email));

// 4. تتجه تلقائياً لصفحة التحقق من البريد
// (عن طريق AuthGate في auth_gate.dart)
```

---

### 3️⃣ **عملية ريجستر الصيدلية (Pharmacy Register Flow)** ⚕️

#### المسار في الكود:
```
UI (PharmacyRegisterStepTwoPage) → AuthCubit.registerPharmacy() → AuthRepo.registerPharmacy() → ApiService.pharmacyRegister()
```

#### Request Body:
```dart
PharmacyRegisterRequestBody {
  username: "pharmacyName",
  email: "pharmacy@email.com",
  phoneNumber: "0123456789",
  password: "@Password123",
  role: "pharmacy",
  pharmacyName: "أسم الصيدلية",
  address: "العنوان",
  location: {
    "type": "Point",
    "coordinates": [longitude, latitude]  // ⚠️ تنسيق GeoJSON
  }
}
```

#### Response:
```json
{
  "message": "User registered successfully. Please verify your email.",
  "user": {
    "_id": "pharmacyId123",
    "username": "pharmacyName",
    "email": "pharmacy@email.com",
    "phoneNumber": "0123456789",
    "role": "pharmacy",
    "isEmailVerified": false,
    "createdAt": "2026-01-28T14:26:50.560Z",
    "updatedAt": "2026-01-28T14:26:50.560Z"
  }
}
```

#### ما يحدث بعد النجاح:
```dart
// نفس خطوات Register العادي لأن البريد يجب أن يتم التحقق منه أيضاً

// 1. لا تحفظ التوكن
// 2. تحفظ البريد المراد التحقق من صحته
_pendingVerificationEmail = requestBody.email;

// 3. تصدر state emailVerificationPending
emit(AuthState.emailVerificationPending(requestBody.email));

// 4. تتجه تلقائياً لصفحة التحقق من البريد
```

---

## 🔑 النقاط الأساسية للاختلافات

| العملية | Login | Register | Pharmacy Register |
|---------|-------|----------|-------------------|
| **التوكن** | ✅ يتم استقباله | ❌ لا يوجد | ❌ لا يوجد |
| **حفظ التوكن** | ✅ نعم | ❌ لا | ❌ لا |
| **التحقق من البريد** | ✅ بالفعل تم | ❌ يجب تأكيده | ❌ يجب تأكيده |
| **الصفحة التالية** | Home | تحقق من البريد | تحقق من البريد |
| **State النهائي** | `Authenticated` | `EmailVerificationPending` | `EmailVerificationPending` |
| **معلومات إضافية** | - | - | Location (GeoJSON) |

---

## 🚀 ملف المعلومات (Payload) المرسل للـ API

### Login Payload:
```json
{
  "email": "user@email.com",
  "password": "@Password123"
}
```

### Register Payload:
```json
{
  "username": "username",
  "email": "user@email.com",
  "phoneNumber": "0123456789",
  "password": "@Password123"
}
```

### Pharmacy Register Payload (الصيغة الصحيحة):
```json
{
  "username": "alfa",
  "email": "ahmy@gmail.com",
  "phoneNumber": "01612345678",
  "password": "@Aa123456",
  "role": "pharmacy",
  "pharmacyName": "Pharmacy",
  "address": "ZagazigCity",
  "location": {
    "type": "Point",
    "coordinates": [31.5021, 30.5877]
  }
}
```

⚠️ **ملاحظة هامة:** إحداثيات GeoJSON يجب أن تكون بصيغة `[longitude, latitude]` وليس `[latitude, longitude]`

---

## 📍 معالجة الأخطاء (Error Handling)

كل عملية لها معالجة خاصة للأخطاء في دالة `_getFriendlyErrorMessage`:

```dart
if (operation == 'login') {
  // معالجة أخطاء اللوجن
} else if (operation == 'register' || operation == 'pharmacy_register') {
  // معالجة أخطاء الريجستر
  if (operation == 'pharmacy_register') {
    // معالجة أخطاء خاصة بالصيدلية (مثل الموقع غير صحيح)
  }
}
```

---

## ✅ الصيغة النهائية الصحيحة لـ Pharmacy Location

**القديم (غير صحيح):**
```dart
location: PharmacyLocation(
  coordinates: [selectedLatitude!, selectedLongitude!],
)
```

**الجديد (صحيح):**
```dart
location: {
  'type': 'Point',
  'coordinates': [selectedLongitude!, selectedLatitude!],
}
```

هذا يتوافق مع معايير GeoJSON الدولية! 🌍
