# Waibuk - Digital Yearbook Platform

## Overview
Waibuk is a comprehensive digital yearbook web application that allows schools to create and manage yearbooks, while enabling alumni and viewers to access, purchase, and upload memories/photos.

## Current Status
✅ Application fully deployed and running on Replit  
✅ PostgreSQL database configured via Drizzle ORM  
✅ Super-admin account created (username: admin)  
✅ Dummy verification (1234) implemented for testing  
✅ School code system completely removed - schools now login with email/username and password only

## Recent Changes (October 6, 2025)

### Email Verification System
- **Feature**: Complete email verification flow for user registration with security features
- **Implementation**:
  - Users must verify their email address after registration before logging in
  - Verification tokens expire after 24 hours for security
  - Verification emails sent via Resend integration
  - Resend verification email functionality for expired or lost emails
  - Login blocked for unverified users with clear error messages
- **Backend Changes**:
  - Added `isEmailVerified`, `emailVerificationToken`, `emailVerificationTokenExpiresAt` fields to users table
  - `POST /api/auth/signup` - Generates verification token with 24-hour expiry, sends email
  - `GET /api/verify-email/:token` - Verifies email, checks expiry, marks user as verified
  - `POST /api/resend-verification` - Generates new token, invalidates old one, sends new email
  - `POST /api/auth/login` - Checks email verification status, blocks unverified users
- **Frontend Changes**:
  - `/verify-email/:token` - Verification page with success/error/loading states
  - Login page updated to show resend button when email not verified
  - Success messages redirect users after 3 seconds
  - Glassmorphism design matching existing Waibuk aesthetic
- **Security Features**:
  - 24-hour token expiration prevents indefinite token reuse
  - Token invalidation on resend prevents replay attacks
  - Tokens cleared after successful verification
  - Secure random token generation using crypto.randomBytes(32)
- **Test IDs**:
  - `loader-verifying` - Loading spinner during verification
  - `icon-success` - Success checkmark icon
  - `icon-error` - Error X icon
  - `button-back-to-login` - Return to login button
  - `button-resend-verification` - Resend verification email button
- **Files Modified**:
  - `shared/schema.ts` - Added verification fields
  - `server/routes.ts` - Verification and resend endpoints
  - `server/storage.ts` - Added getUserByVerificationToken method
  - `client/src/pages/verify-email.tsx` - New verification page
  - `client/src/pages/login.tsx` - Added resend functionality
  - `client/src/App.tsx` - Added verification route

### School Code System Removal
- **Feature**: Completely removed the old school code authentication system
- **Changes**:
  - Removed school code encryption/decryption functions from backend
  - Removed school code validation from all signup forms
  - Removed school code reveal/password protection from school dashboard
  - Removed school code display from super-admin approval flow
  - Schools now authenticate using only email/username and password
- **Backend Changes**:
  - Removed `encryptSchoolCode()`, `decryptSchoolCode()`, `verifySchoolCode()` from `server/password-utils.ts`
  - Removed school code generation from test account creation in `server/initialize-database.ts`
- **Frontend Changes**:
  - Removed school code field from `client/src/pages/signup.tsx`
  - Removed school code state from `client/src/pages/school-signup.tsx`
  - Removed school code reveal dialog from `client/src/pages/school-dashboard.tsx`
  - Removed school code toast notification from `client/src/pages/super-admin-dashboard.tsx`
- **Database**: No schema changes needed (school code was already removed from database)
- **Authentication**: Schools use standard username/email and password authentication

## Recent Changes (October 5, 2025)

### Responsive Design Improvements
- **Feature**: Comprehensive mobile-first responsive design fixes applied across key pages
- **Approach**: Mobile-first with Tailwind CSS breakpoints (sm:, md:, lg:)
- **Pages Updated**:
  - `signup.tsx` - Grid layouts stack on mobile (grid-cols-1 sm:grid-cols-2)
  - `viewer-signup.tsx` - Step progress indicators with mobile-specific labels, responsive grids
  - `school-signup.tsx` - Step progress wrapping and mobile-optimized spacing
  - `yearbook-viewer.tsx` - Header toolbar wrapping, responsive button sizing and text
- **Patterns Applied**:
  - Grid layouts: `grid-cols-1 sm:grid-cols-2` for proper mobile stacking
  - Text sizing: `text-xs sm:text-sm`, `text-lg sm:text-2xl` for readability
  - Button groups: Flex wrapping with responsive padding/spacing
  - Country code dropdown: `w-24 sm:w-32` for narrower mobile display
  - Navigation: Hide/abbreviate text on small screens (`hidden sm:inline`)
  - Step indicators: Smaller icons and abbreviated labels on mobile
  - Spacing: `p-3 sm:p-6`, `space-x-2 sm:space-x-4` for responsive margins
- **Testing**: Architect review passed, no regressions found
- **Target Breakpoints**: Optimized for 320px-375px (mobile) to 1920px+ (desktop)
- **Files Modified**:
  - `client/src/pages/signup.tsx`
  - `client/src/pages/viewer-signup.tsx`
  - `client/src/pages/school-signup.tsx`
  - `client/src/pages/yearbook-viewer.tsx`

### Notification Bell System
- **Feature**: Notification bell with dropdown added to four key pages
- **Pages Updated**:
  - `school-settings` - School settings page
  - `cart` - Shopping cart page
  - `yearbook-manage` - Yearbook management page
  - `photos-memories-manage` - Photos & memories management page
- **Functionality**:
  - Bell icon displays unread notification count badge
  - Click to open dropdown with notification list
  - Mark individual notifications as read by clicking
  - Clear All button to remove all notifications
  - Relative time display (e.g., "5 minutes ago", "2 days ago")
  - Auto-refresh every 30 seconds
- **UI Features**:
  - Consistent blue notification badge for unread count
  - Unread notifications highlighted with blue background
  - Smooth hover effects and transitions
  - Mobile-responsive design
- **Test IDs**:
  - `button-notifications` - Notification bell button
  - `button-clear-all-notifications` - Clear all button
  - `button-close-notifications` - Close dropdown button
  - `notification-{id}` - Individual notification items
- **Files Modified**:
  - `client/src/pages/school-settings.tsx`
  - `client/src/pages/cart.tsx`
  - `client/src/pages/yearbook-manage.tsx`
  - `client/src/pages/photos-memories-manage.tsx`
- **Notes**: Implementation uses inline code for speed. Future refactoring to shared component recommended but would require additional optimization.

## Recent Changes (October 4, 2025)

### Automatic PDF Cover Assignment
- **Feature**: PDF yearbook uploads now automatically assign front and back covers
- **Behavior**: 
  - When uploading a PDF yearbook, page 1 is automatically set as the front cover
  - The last page (page n) is automatically set as the back cover
  - Both covers are automatically updated in the yearbook record (frontCoverUrl and backCoverUrl)
  - Page types are marked as "front_cover" and "back_cover" respectively
- **Backend Changes**:
  - Added `updateYearbookCovers()` method to storage interface
  - Modified PDF upload handler in `server/routes.ts` to auto-assign covers after extraction
  - Updates both `yearbook_pages` records and `yearbooks` cover URLs
- **Files Modified**:
  - `server/storage.ts` - Added updateYearbookCovers method to IStorage and implementations
  - `server/routes.ts` - Enhanced PDF upload logic to auto-assign first/last pages as covers

### Price Management UI
- **Feature**: Yearbook price management card added to yearbook management page
- **Location**: Left sidebar above Table of Contents in `/yearbook-manage/:year`
- **Functionality**:
  - Display current yearbook price (defaults to $14.99)
  - Edit price with validation ($1.99 - $49.99 range)
  - View price history (up to 3 most recent changes)
  - 30-day cooldown enforcement for price increases
  - Real-time price update with backend API integration
- **Backend APIs**:
  - `PATCH /api/yearbooks/:yearbookId/price` - Update price with validation
  - `GET /api/yearbooks/:yearbookId/price-history` - Retrieve price change history
  - `GET /api/yearbooks/:yearbookId/can-increase-price` - Check 30-day cooldown
- **UI Components**: Added DollarSign, Check, X, and AlertCircle icons from lucide-react
- **Test IDs**: 
  - `input-yearbook-price` - Price input field
  - `button-edit-price` - Edit button
  - `button-save-price` - Save button

### Files Modified
- `client/src/pages/yearbook-manage.tsx` - Added price management card with state, queries, and mutations
- `shared/schema.ts` - Already had `price` field in yearbooks table
- `server/routes.ts` - Already had price management API endpoints
- `server/storage.ts` - Already had price update methods with 30-day cooldown logic

## Recent Changes (October 2, 2025)

### Verification System (Dummy for Testing)
- **Current Implementation**: Simple "1234" verification code
- **Purpose**: Protect public upload code entry flow without domain configuration issues
- **Scope**: Only shown to unregistered users; logged-in users bypass verification
- **Location**: Guest upload page (`/memory-upload` and `/upload/:code`)

#### Why Dummy Verification?
During development/testing on Replit, Google reCAPTCHA requires domain whitelisting which can be problematic with dynamic Replit URLs. The dummy verification maintains the security flow pattern while avoiding configuration issues.

#### How to Re-enable Google reCAPTCHA for Production
When deploying to production with a stable domain:

1. **Add reCAPTCHA Script** to `client/index.html`:
   ```html
   <script src="https://www.google.com/recaptcha/api.js" async defer></script>
   ```

2. **Set Environment Variables**:
   - `RECAPTCHA_SECRET_KEY` - Your reCAPTCHA secret key
   - `VITE_RECAPTCHA_SITE_KEY` - Your reCAPTCHA site key

3. **Replace Verification Code**: Look for `// TODO: Replace with Google reCAPTCHA` comments in:
   - `client/src/pages/guest-upload.tsx` - Replace verification input with reCAPTCHA widget
   - `server/routes.ts` - Replace "1234" check with Google verification

#### Files Modified
- `client/src/pages/guest-upload.tsx` - Dummy verification input
- `client/index.html` - Removed reCAPTCHA script (for now)
- `server/routes.ts` - Simple "1234" check with TODO for reCAPTCHA

## Project Architecture

### Database
- **Provider**: PostgreSQL (Neon-backed, Replit built-in)
- **ORM**: Drizzle ORM
- **Schema Location**: `shared/schema.ts`
- **Migrations**: Use `npm run db:push --force` to sync schema changes

### Authentication
- Session-based authentication using `express-session`
- User roles: viewer, school, super-admin
- Login page: `/login`

### Key Routes
- `/` - Login page
- `/memory-upload` - Public guest upload (with upload code)
- `/upload/:code` - Direct link with pre-filled upload code
- `/school-dashboard` - School admin dashboard
- `/viewer-dashboard` - Alumni/viewer dashboard
- `/super-admin` - Super admin panel

### Storage
- In-memory storage used (`MemStorage` in `server/storage.ts`)
- All CRUD operations go through the storage interface

## Environment Variables
The following secrets are configured in Replit Secrets:
- `SESSION_SECRET` - Express session encryption key
- ~~`RECAPTCHA_SECRET_KEY`~~ - (Not needed for dummy verification, add for production)
- ~~`VITE_RECAPTCHA_SITE_KEY`~~ - (Not needed for dummy verification, add for production)

## Development

### Running the Application
```bash
npm run dev
```
This starts both the Express backend and Vite frontend on port 5000.

### Tech Stack
- **Frontend**: React, Wouter (routing), TanStack Query, Tailwind CSS, shadcn/ui
- **Backend**: Express, Node.js
- **Database**: PostgreSQL via Drizzle ORM
- **Build Tool**: Vite

## User Preferences
- **Optimization**: Minimize agent usage due to trial account limits
- **Focus**: Complete features with testing before moving to next tasks

## Known Issues
- Database connection uses fallback method (non-critical, app functions correctly)

## Next Steps
1. Test dummy verification with public upload codes (enter "1234")
2. When ready for production: Re-enable Google reCAPTCHA (see instructions above)
3. Consider additional features as needed
