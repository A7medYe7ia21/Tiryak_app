# 📞 Backend: Allow Same Email for Different Roles

## 🔴 Current Issue

When a user tries to register as pharmacy with an email that's already registered as a regular user, Backend returns:

```json
{
  "message": "User with this email already exists"
}
```

## ✅ Expected Behavior

The system should allow the same email to be used for different roles:
- Same email as user role: ✅ allowed
- Same email as pharmacy role: ✅ should be allowed too

## 🔄 Solution

Update the Backend registration logic:

### Current Logic (❌ Wrong)
```javascript
// Backend pseudo-code
POST /auth/register
{
  // Check: does this email exist in users table?
  if (emailExists) {
    return 409 "User with this email already exists"
  }
  // Create user
}
```

### New Logic (✅ Correct)
```javascript
// Backend pseudo-code
POST /auth/register
{
  const existingUser = findUserByEmail(email);
  
  // If email exists and trying to register with same role
  if (existingUser && existingUser.role === body.role) {
    return 409 "User with this email already exists"
  }
  
  // If email exists but different role - ALLOW IT
  if (existingUser && existingUser.role !== body.role) {
    // Save as new user with different role
    // OR update existing user with new role
  }
  
  // If email doesn't exist - create new
  if (!existingUser) {
    // Create user
  }
}
```

## 📊 Database Options

### Option 1: Single Users Table (Recommended)
```sql
CREATE TABLE users {
  _id ObjectId,
  email String,
  role Enum("user", "pharmacy"),
  ...
  
  // Unique index on (email, role) - not just email
  UNIQUE INDEX idx_email_role ON (email, role)
}
```

This allows:
- ✅ user@email.com with role="user"
- ✅ user@email.com with role="pharmacy" (same email, different role!)

### Option 2: Separate Tables
```sql
CREATE TABLE users {
  _id ObjectId,
  email String UNIQUE,  // unique on email
  ...
}

CREATE TABLE pharmacies {
  _id ObjectId,
  email String,  // NOT unique - different constraint
  userId ObjectId (ref users),
  ...
}
```

## 📝 Implementation Checklist

- [ ] Update email uniqueness constraint to be (email, role) composite
- [ ] Update registration logic to allow different roles with same email
- [ ] Test: Register user with email@example.com as user role
- [ ] Test: Register email@example.com as pharmacy role (should succeed)
- [ ] Update error handling

## 🧪 Test Cases

### Test 1: Different Roles, Same Email
```bash
# Step 1: Register as user
POST /auth/register
{
  "email": "test@example.com",
  "role": "user"
}
✅ Response: 201 Created

# Step 2: Register same email as pharmacy
POST /auth/register
{
  "email": "test@example.com",
  "role": "pharmacy",
  "pharmacyName": "...",
  "address": "..."
}
✅ Response: 201 Created (should succeed now!)
```

### Test 2: Same Role, Same Email
```bash
# Step 1: Register as user
POST /auth/register
{
  "email": "test@example.com",
  "role": "user"
}
✅ Response: 201 Created

# Step 2: Try to register same email with same role
POST /auth/register
{
  "email": "test@example.com",
  "role": "user"
}
❌ Response: 409 Conflict "User with this email already exists"
```

## 📊 Request from Frontend

Frontend will send requests like:

```json
POST /auth/register
{
  "username": "pharmacy_name",
  "email": "test@example.com",
  "phoneNumber": "0123456789",
  "password": "Password@123",
  "role": "pharmacy",           ← This field indicates the role
  "pharmacyName": "My Pharmacy",
  "address": "Cairo, Egypt",
  "location": {
    "coordinates": [31.2357, 30.0444]
  }
}
```

---

**Frontend Status:** ✅ Ready to send requests  
**Backend Status:** ⏳ Awaiting implementation  

Once this is fixed, pharmacy registration with existing emails will work! 🚀
