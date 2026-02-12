# 📞 Message for Backend Developer

## 🔴 Issue Found

**Error:** `Cannot POST /auth/pharmacy/register`

The Flutter app is trying to call an endpoint that doesn't exist in the Backend API.

---

## ✅ Solution Applied (Frontend)

We've updated the Flutter app to use the **existing** `/auth/register` endpoint for both regular users AND pharmacies.

### How it works:

The request now includes a `role` field:

```json
POST /auth/register
{
  "username": "pharmacy_user",
  "email": "pharmacy@example.com",
  "phoneNumber": "0123456789",
  "password": "SecurePassword123!",
  "role": "pharmacy",           ← This tells backend it's a pharmacy
  "pharmacyName": "My Pharmacy",
  "address": "123 Main St",
  "location": {
    "type": "Point",
    "coordinates": [31.2357, 30.0444]
  }
}
```

---

## ❓ What we need from Backend

### Option 1: Support existing endpoint (Recommended)
```javascript
// Backend logic
POST /auth/register
{
  if (body.role === "user") {
    // Register as regular user
  } else if (body.role === "pharmacy") {
    // Register as pharmacy
    // Store pharmacy-specific data (name, address, location)
  }
}
```

### Option 2: Create new endpoint (Alternative)
```javascript
POST /auth/pharmacy/register
{
  // Accept pharmacy registration
  // Store all pharmacy data
}
```

---

## 🔀 Request Mapping

### Regular User Registration
```
Frontend request:
POST /auth/register
{
  "username": "john",
  "email": "john@example.com",
  "phoneNumber": "0123456789",
  "password": "Password123!"
  // role field: not sent or empty
}

Backend: creates user with role="user"
```

### Pharmacy Registration
```
Frontend request:
POST /auth/register
{
  "username": "pharmacy",
  "email": "pharmacy@example.com",
  "phoneNumber": "0123456789",
  "password": "Password123!",
  "role": "pharmacy",              ← NEW
  "pharmacyName": "My Pharmacy",   ← NEW
  "address": "123 Main St",        ← NEW
  "location": {...}                ← NEW (GeoJSON)
}

Backend: creates user with role="pharmacy" and saves pharmacy data
```

---

## 📊 Database Schema (Suggested)

### Users Table
```sql
CREATE TABLE users (
  _id ObjectId,
  username String,
  email String,
  phoneNumber String,
  password String,
  role Enum("user", "pharmacy"),    ← Should support both
  isEmailVerified Boolean,
  createdAt Date,
  updatedAt Date,
  
  -- Pharmacy specific (nullable for regular users)
  pharmacyName String,              ← NEW
  address String,                   ← NEW
  location GeoJSON,                 ← NEW (for geospatial queries)
  
  ...other fields
}
```

OR

### Separate Pharmacy Table
```sql
-- Users table (as is)
CREATE TABLE users { ... }

-- Pharmacies table (new)
CREATE TABLE pharmacies {
  _id ObjectId,
  userId ObjectId (ref users),
  pharmacyName String,
  address String,
  location GeoJSON,
  ...
}
```

---

## 🔄 Expected Response

```json
{
  "message": "User registered successfully. Please verify your email.",
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "username": "pharmacy_user",
    "email": "pharmacy@example.com",
    "phoneNumber": "0123456789",
    "role": "pharmacy",              ← Should return role
    "isEmailVerified": false,
    "createdAt": "2026-01-28T14:26:50.560Z",
    "updatedAt": "2026-01-28T14:26:50.560Z"
  }
}
```

---

## 🧪 Test Cases

### Test 1: Regular User Registration
```bash
curl -X POST https://tiryak.vercel.app/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "phoneNumber": "0123456789",
    "password": "Test@Password123"
  }'

Expected Response:
✅ 201 Created
{
  "user": {
    "role": "user"
  }
}
```

### Test 2: Pharmacy Registration
```bash
curl -X POST https://tiryak.vercel.app/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testpharmacy",
    "email": "pharmacy@example.com",
    "phoneNumber": "0123456789",
    "password": "Test@Password123",
    "role": "pharmacy",
    "pharmacyName": "Test Pharmacy",
    "address": "123 Main St, Cairo",
    "location": {
      "type": "Point",
      "coordinates": [31.2357, 30.0444]
    }
  }'

Expected Response:
✅ 201 Created
{
  "user": {
    "role": "pharmacy",
    "pharmacyName": "Test Pharmacy"
  }
}
```

---

## 💡 Implementation Notes

1. **Role field:** Add support for `role` in request body
2. **Pharmacy fields:** Store `pharmacyName`, `address`, `location` if `role === "pharmacy"`
3. **Validation:** Validate pharmacy-specific fields when role is pharmacy
4. **GeoJSON:** Location should be stored in GeoJSON format for geospatial queries
5. **Backward compatibility:** Existing requests (without role field) should default to `role: "user"`

---

## 📋 Checklist for Backend

- [ ] Update `/auth/register` endpoint to accept `role` field
- [ ] Add logic to handle `role: "pharmacy"`
- [ ] Store pharmacy-specific fields (pharmacyName, address, location)
- [ ] Return `role` field in response
- [ ] Test with both regular user and pharmacy registrations
- [ ] Update API documentation

---

## 🎯 Frontend Changes (Already Done)

✅ Updated ApiConstants: using `/auth/register` for pharmacy registration  
✅ Updated request body: includes `role: "pharmacy"` and pharmacy data  
✅ Updated location format: GeoJSON format [longitude, latitude]

---

## 🚀 Timeline

**Awaiting Backend Implementation:**
1. Update `/auth/register` to handle pharmacy registrations
2. Test with Flutter app
3. Verify response includes role field
4. Done! 🎉

---

## 📞 Contact

If you have questions about the expected request/response format, refer to:
- `PHARMACY_ENDPOINT_SOLUTION.md` - Detailed technical explanation
- `PHARMACY_REGISTER_VISUAL_GUIDE.md` - Visual diagrams
- Test cases above

---

**Status:** ✅ Frontend Ready | ⏳ Backend Awaiting Implementation

**Thank you!** 🙏
