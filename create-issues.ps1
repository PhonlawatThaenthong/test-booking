# ============================================================
# Create Milestones + All Backlog Issues for RBMA project via GitHub CLI
#
# How to use:
#   1. Make sure you already ran create-labels.ps1 successfully
#   2. cd into your local repo folder (same as before)
#   3. Run: .\create-issues.ps1
#
#   If scripts are blocked, run once per session:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# ============================================================

# Set repo here if NOT running inside the local repo folder, e.g. "owner/repo-name"
# Leave as "" if you are already inside the local git repo folder
$REPO = ""

function Get-RepoArg {
    if ($REPO -ne "") { return @("-R", $REPO) } else { return @() }
}

# ---------- 1. Create Milestones ----------
$milestones = @(
    "Sprint 1 - Setup & Database",
    "Sprint 2 - Authentication",
    "Sprint 3 - Room & Search",
    "Sprint 4 - Booking",
    "Sprint 5 - Payment & Notification",
    "Sprint 6 - Admin Dashboard",
    "Sprint 7 - Map, Report & Deploy"
)

Write-Host "== Creating Milestones ==" -ForegroundColor Cyan
foreach ($m in $milestones) {
    $repoArg = Get-RepoArg
    if ($REPO -ne "") {
        gh api "repos/$REPO/milestones" -f title="$m" 2>$null | Out-Null
    } else {
        # Get current repo in owner/name format
        $currentRepo = gh repo view --json nameWithOwner -q ".nameWithOwner"
        gh api "repos/$currentRepo/milestones" -f title="$m" 2>$null | Out-Null
    }
    Write-Host "  Milestone ready: $m"
}

# ---------- 2. Define Issues ----------
# Each issue: Title, Body, Labels (comma separated), Milestone
$issues = @(
    @{ T="[SETUP] Setup Repository and Branch Strategy"; M="Sprint 1 - Setup & Database"; L="epic,devops,P0-critical";
       B="Define project structure and team workflow.`n`n- [ ] Create branches: main, dev, feature/*`n- [ ] Add .gitignore matching the tech stack`n- [ ] Set branch protection rule on main`n- [ ] Write initial README" }

    @{ T="[SETUP] Choose and Install Tech Stack"; M="Sprint 1 - Setup & Database"; L="devops,P0-critical";
       B="Decide and install the tools used in the project.`n`n- [ ] Finalize Frontend / Backend / Database choice`n- [ ] Install initial dependencies`n- [ ] Run an empty project successfully (frontend + backend)`n- [ ] Document setup steps in README" }

    @{ T="[DB] Design ER Diagram"; M="Sprint 1 - Setup & Database"; L="database,docs,P0-critical";
       B="Design the data relationships for the whole system.`n`n- [ ] Identify entities: users, room_types, rooms, bookings, payments, restaurants`n- [ ] Define relationships and cardinality`n- [ ] Attach ERD image to this issue" }

    @{ T="[DB] Create Database Schema and Migrations"; M="Sprint 1 - Setup & Database"; L="database,backend,P0-critical";
       B="Create the real tables based on the ERD.`n`n- [ ] Write migrations for every table`n- [ ] Define primary key / foreign key / index`n- [ ] Add sample seed data for testing" }

    @{ T="[SETUP] Configure Environment Variables"; M="Sprint 1 - Setup & Database"; L="devops,security,P1-high";
       B="Separate config from source code.`n`n- [ ] Create .env.example`n- [ ] Move DB connection and API keys into .env`n- [ ] Confirm .env is in .gitignore" }

    @{ T="[AUTH] Customer Registration"; M="Sprint 2 - Authentication"; L="feature,module: auth,backend,frontend,P0-critical";
       B="Allow customers to create an account to make bookings.`n`n- [ ] Registration form: name, email, phone, password`n- [ ] Validate on frontend and backend`n- [ ] Check for duplicate email`n- [ ] Hash password before saving" }

    @{ T="[AUTH] Login and Logout"; M="Sprint 2 - Authentication"; L="feature,module: auth,backend,frontend,P0-critical";
       B="- [ ] Login API returns token / creates session`n- [ ] Login UI page`n- [ ] Handle errors: wrong password, account not found`n- [ ] Logout button clears session" }

    @{ T="[AUTH] Role-based Access Control"; M="Sprint 2 - Authentication"; L="feature,module: auth,backend,security,P0-critical";
       B="Separate permissions for Customer / Staff / Admin.`n`n- [ ] Add role field to users table`n- [ ] Middleware to check permission before accessing routes`n- [ ] Customers cannot access admin pages" }

    @{ T="[AUTH] Forgot Password / Reset Password"; M="Sprint 2 - Authentication"; L="feature,module: auth,backend,frontend,P1-high";
       B="- [ ] Email input form`n- [ ] Generate reset token with expiration`n- [ ] Send reset link via email`n- [ ] New password form" }

    @{ T="[AUTH] User Profile Page"; M="Sprint 2 - Authentication"; L="feature,module: auth,frontend,P1-high";
       B="- [ ] Show current user info`n- [ ] Edit name and phone number`n- [ ] Change password (requires current password)" }

    @{ T="[ROOM] API: Search Available Rooms by Date"; M="Sprint 3 - Room & Search"; L="feature,module: room,backend,P0-critical";
       B="Core search functionality. Must not return rooms that are already booked.`n`n- [ ] Accept check-in, check-out, number of guests`n- [ ] Query excludes rooms with overlapping bookings`n- [ ] Validate: check-out after check-in, no past dates" }

    @{ T="[ROOM] Search Results Page"; M="Sprint 3 - Room & Search"; L="feature,module: room,frontend,P0-critical";
       B="- [ ] Search form with date picker`n- [ ] Display results as card list`n- [ ] Empty state when no rooms found`n- [ ] Responsive on mobile" }

    @{ T="[ROOM] Search Filters (Type / Price / Guests)"; M="Sprint 3 - Room & Search"; L="feature,module: room,frontend,backend,P1-high";
       B="- [ ] Filter by room type`n- [ ] Filter by price range`n- [ ] Filter by number of guests`n- [ ] Support multiple filters at once" }

    @{ T="[ROOM] Room Detail Page"; M="Sprint 3 - Room & Search"; L="feature,module: room,frontend,P0-critical";
       B="- [ ] Image gallery`n- [ ] Price per night, room size, max guests`n- [ ] List of amenities`n- [ ] Book this room button" }

    @{ T="[UI] Landing Page"; M="Sprint 3 - Room & Search"; L="feature,frontend,P1-high";
       B="- [ ] Hero section with search form`n- [ ] Highlight resort and popular room types`n- [ ] Shared Navbar and Footer for all pages" }

    @{ T="[BOOKING] Prevent Overbooking Logic"; M="Sprint 4 - Booking"; L="feature,module: booking,backend,P0-critical";
       B="CRITICAL: This is the core problem this project must solve. Give this issue extra time and testing.`n`n- [ ] Check for overlapping dates before saving every booking`n- [ ] Use database transaction / row lock to prevent race conditions`n- [ ] Test cases: exact overlap, partial overlap, adjacent dates`n- [ ] Test concurrent requests booking the same room at the same time" }

    @{ T="[BOOKING] API: Create Booking"; M="Sprint 4 - Booking"; L="feature,module: booking,backend,P0-critical";
       B="- [ ] Save booking with pending status`n- [ ] Generate unique booking reference number`n- [ ] Link booking to the logged-in user" }

    @{ T="[BOOKING] Total Price Calculation"; M="Sprint 4 - Booking"; L="feature,module: booking,backend,P0-critical";
       B="- [ ] Calculate nights x price per night`n- [ ] Include tax / service fee if any`n- [ ] Show itemized breakdown before confirmation" }

    @{ T="[BOOKING] Booking Confirmation and Guest Info Page"; M="Sprint 4 - Booking"; L="feature,module: booking,frontend,P0-critical";
       B="- [ ] Summary of room, dates, price`n- [ ] Guest info form and special requests`n- [ ] Confirm button proceeds to payment" }

    @{ T="[BOOKING] Customer Booking History Page"; M="Sprint 4 - Booking"; L="feature,module: booking,frontend,P1-high";
       B="- [ ] List all bookings for the user`n- [ ] Split by status: awaiting payment / confirmed / cancelled / completed`n- [ ] View booking detail" }

    @{ T="[BOOKING] Customer Cancel Booking"; M="Sprint 4 - Booking"; L="feature,module: booking,backend,frontend,P1-high";
       B="- [ ] Cancel button with confirm dialog`n- [ ] Cancellation allowed only N days before check-in`n- [ ] Room becomes available immediately after cancel" }

    @{ T="[PAYMENT] Integrate Payment Gateway (Sandbox)"; M="Sprint 5 - Payment & Notification"; L="feature,module: payment,backend,P0-critical";
       B="- [ ] Choose gateway (Omise / Stripe / PromptPay)`n- [ ] Register and configure API key in .env`n- [ ] Test a successful payment in sandbox mode" }

    @{ T="[PAYMENT] Payment Page and Status Handling"; M="Sprint 5 - Payment & Notification"; L="feature,module: payment,frontend,backend,P0-critical";
       B="- [ ] Payment method selection page`n- [ ] Statuses: pending / paid / failed / refunded`n- [ ] Success and failure result pages" }

    @{ T="[PAYMENT] Webhook for Payment Status Update"; M="Sprint 5 - Payment & Notification"; L="feature,module: payment,backend,security,P0-critical";
       B="- [ ] Endpoint to receive gateway callback`n- [ ] Verify webhook signature for security`n- [ ] Automatically update booking status to confirmed" }

    @{ T="[PAYMENT] Handle Failed / Timed Out Payments"; M="Sprint 5 - Payment & Notification"; L="feature,module: payment,backend,P1-high";
       B="- [ ] Hold room for 15 minutes during payment`n- [ ] Auto-cancel booking after timeout`n- [ ] Release room back to available status" }

    @{ T="[NOTIFY] Setup Email Service"; M="Sprint 5 - Payment & Notification"; L="feature,module: notify,backend,P1-high";
       B="- [ ] Configure SMTP or SendGrid`n- [ ] Test sending a real email" }

    @{ T="[NOTIFY] Automatic Booking Confirmation Email"; M="Sprint 5 - Payment & Notification"; L="feature,module: notify,backend,P1-high";
       B="- [ ] Design email template`n- [ ] Include booking reference, dates, room, price`n- [ ] Send immediately after successful payment" }

    @{ T="[NOTIFY] SMS Booking Confirmation"; M="Sprint 5 - Payment & Notification"; L="feature,module: notify,backend,P2-normal";
       B="- [ ] Integrate SMS API`n- [ ] Send short message with booking reference" }

    @{ T="[ADMIN] Staff Login Page"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,frontend,backend,P0-critical";
       B="- [ ] Separate route from customer side`n- [ ] Verify role is staff or admin only" }

    @{ T="[ADMIN] Dashboard Layout and Overview Page"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,frontend,P0-critical";
       B="- [ ] Sidebar navigation menu`n- [ ] Summary cards: today's bookings, available rooms, revenue this month`n- [ ] Recent bookings list" }

    @{ T="[ADMIN] Bookings Management Table"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,frontend,backend,P0-critical";
       B="- [ ] List bookings with pagination`n- [ ] Search by customer name or booking reference`n- [ ] Filter by status and date range" }

    @{ T="[ADMIN] Approve / Edit / Cancel Bookings"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,backend,P0-critical";
       B="- [ ] Approve and cancel buttons with confirm`n- [ ] Edit dates or move room (must re-check availability)`n- [ ] Log who made the edit" }

    @{ T="[ADMIN] Check-in / Check-out System"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,backend,frontend,P1-high";
       B="- [ ] Button to mark as checked-in`n- [ ] Check-out button closes the booking" }

    @{ T="[ADMIN] Room Type Management (CRUD)"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,module: room,backend,frontend,P0-critical";
       B="- [ ] Add / edit / delete room types`n- [ ] Set base price and max guests" }

    @{ T="[ADMIN] Room Management (CRUD)"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,module: room,backend,frontend,P0-critical";
       B="- [ ] Add and remove rooms`n- [ ] Edit room number and type`n- [ ] Prevent deleting a room that has active bookings" }

    @{ T="[ADMIN] Room Image Upload and Management"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,module: room,backend,frontend,P1-high";
       B="- [ ] Upload multiple images`n- [ ] Limit file size and extensions`n- [ ] Delete images and select cover photo" }

    @{ T="[ADMIN] Room Maintenance Status"; M="Sprint 6 - Admin Dashboard"; L="feature,module: admin,module: room,backend,P1-high";
       B="- [ ] Statuses: available / maintenance / closed`n- [ ] Closed rooms must not appear in customer search results" }

    @{ T="[MAP] Setup Google Maps API and Show Resort Location"; M="Sprint 7 - Map, Report & Deploy"; L="feature,module: map,frontend,backend,P1-high";
       B="- [ ] Get API key and restrict by domain`n- [ ] Embed map on resort detail page`n- [ ] Pin resort location" }

    @{ T="[MAP] Nearby Restaurant Recommendations Page"; M="Sprint 7 - Map, Report & Deploy"; L="feature,module: map,frontend,backend,P2-normal";
       B="- [ ] Show restaurant list with photo and distance`n- [ ] Directions button from resort to restaurant`n- [ ] Admin can add/edit restaurant list" }

    @{ T="[REPORT] Total Revenue Report"; M="Sprint 7 - Map, Report & Deploy"; L="feature,module: report,backend,frontend,P1-high";
       B="- [ ] Summarize daily / monthly revenue`n- [ ] Selectable date range`n- [ ] Display as chart" }

    @{ T="[REPORT] Occupancy Rate Report"; M="Sprint 7 - Map, Report & Deploy"; L="feature,module: report,backend,frontend,P1-high";
       B="- [ ] Calculate (booked rooms / total rooms) x 100`n- [ ] Break down by room type" }

    @{ T="[SECURITY] System Security Review"; M="Sprint 7 - Map, Report & Deploy"; L="security,backend,P0-critical";
       B="- [ ] Prevent SQL Injection (use prepared statements)`n- [ ] Prevent XSS (escape output)`n- [ ] Enable CSRF token on all forms`n- [ ] Rate limit failed login attempts" }

    @{ T="[TEST] Unit Tests for Booking Logic"; M="Sprint 7 - Map, Report & Deploy"; L="test,module: booking,backend,P0-critical";
       B="- [ ] Test overlapping date validation`n- [ ] Test price calculation`n- [ ] Test cancellation and room release" }

    @{ T="[TEST] User Acceptance Testing (UAT)"; M="Sprint 7 - Map, Report & Deploy"; L="test,P1-high";
       B="- [ ] Write test scenarios covering all main flows`n- [ ] Have real users try the system`n- [ ] Collect feedback and open new issues" }

    @{ T="[DEPLOY] Deploy to Production"; M="Sprint 7 - Map, Report & Deploy"; L="devops,P0-critical";
       B="- [ ] Prepare server / hosting`n- [ ] Set up HTTPS`n- [ ] Configure production environment variables`n- [ ] Set up database backup" }

    @{ T="[DOCS] Project Documentation"; M="Sprint 7 - Map, Report & Deploy"; L="docs,P1-high";
       B="- [ ] SRS (Software Requirements Specification)`n- [ ] API Documentation`n- [ ] Admin user guide`n- [ ] Customer user guide" }
)

# ---------- 3. Create Issues ----------
Write-Host ""
Write-Host "== Creating Issues ($($issues.Count) total) ==" -ForegroundColor Cyan

$count = 0
foreach ($issue in $issues) {
    $count++
    Write-Host "[$count/$($issues.Count)] $($issue.T)"

    $args = @(
        "issue", "create",
        "--title", $issue.T,
        "--body", $issue.B,
        "--label", $issue.L,
        "--milestone", $issue.M
    )
    if ($REPO -ne "") {
        $args += @("-R", $REPO)
    }

    gh @args | Out-Null
}

Write-Host ""
Write-Host "Done! Created $($issues.Count) issues across 7 milestones." -ForegroundColor Green
Write-Host "Go check the Backlog tab in your GitHub Project to see them all." -ForegroundColor Green
