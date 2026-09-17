# ============================================================
# Create all GitHub Labels for RBMA project via GitHub CLI (PowerShell)
#
# How to use:
#   1. Install GitHub CLI: https://cli.github.com (or: winget install GitHub.cli)
#   2. Open PowerShell, login first: gh auth login
#   3. cd into your local repo folder
#   4. Run: .\create-labels.ps1
#
#   If you get "running scripts is disabled" error, run this first (once per session):
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# ============================================================

# Set repo here if NOT running inside the local repo folder, e.g. "owner/repo-name"
# Leave as "" if you are already inside the local git repo folder
$REPO = ""

function New-Label($name, $description, $color) {
    if ($REPO -ne "") {
        gh label create "$name" -R $REPO --description "$description" --color $color --force
    } else {
        gh label create "$name" --description "$description" --color $color --force
    }
}

Write-Host "== Group 1: Type ==" -ForegroundColor Cyan
New-Label "epic"        "Large body of work made of several sub-issues" "7057ff"
New-Label "feature"     "New feature to be developed" "0e8a16"
New-Label "bug"         "Something is broken and needs fixing" "d73a4a"
New-Label "enhancement" "Improvement to an existing feature" "a2eeef"
New-Label "docs"        "Documentation work" "0075ca"
New-Label "test"        "Writing tests / QA work" "fbca04"
New-Label "refactor"    "Restructure code without changing behavior" "c5def5"

Write-Host "== Group 2: Priority ==" -ForegroundColor Cyan
New-Label "P0-critical" "Must have - system is broken without this" "b60205"
New-Label "P1-high"     "Should have - important but not a blocker" "d93f0b"
New-Label "P2-normal"   "Nice to have if time allows" "fef2c0"

Write-Host "== Group 3: Module ==" -ForegroundColor Cyan
New-Label "module: auth"    "Authentication and account management" "1d76db"
New-Label "module: booking" "Room booking system" "5319e7"
New-Label "module: payment" "Payment processing" "006b75"
New-Label "module: admin"   "Admin dashboard and back office" "bfd4f2"
New-Label "module: room"    "Room management and search" "0052cc"
New-Label "module: notify"  "Email and SMS notifications" "f9d0c4"
New-Label "module: map"     "Google Maps and nearby restaurant recommendations" "c2e0c6"
New-Label "module: report"  "Reports and statistics" "e99695"

Write-Host "== Group 4: Layer ==" -ForegroundColor Cyan
New-Label "frontend" "Frontend / UI work" "f78ca0"
New-Label "backend"  "Backend API and business logic" "5b6b8c"
New-Label "database" "Database and migration work" "8b4513"
New-Label "security" "Security related work" "e11d48"
New-Label "devops"   "Deployment, CI/CD, server work" "374151"

Write-Host "== Group 5: Status ==" -ForegroundColor Cyan
New-Label "blocked"          "Blocked, waiting on another issue" "000000"
New-Label "needs-discussion" "Needs team discussion before starting" "d4c5f9"
New-Label "good first issue" "Simple task, good for beginners" "7057ff"

Write-Host ""
Write-Host "Done! All labels created." -ForegroundColor Green
