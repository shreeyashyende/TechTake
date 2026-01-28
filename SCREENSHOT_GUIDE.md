# TechTake App Store Screenshots Guide

## Required Screenshot Sizes

### iPhone Screenshots (Required)
| Device | Size (pixels) | Required |
|--------|---------------|----------|
| 6.7" (iPhone 15 Pro Max) | 1290 × 2796 | ✅ Yes |
| 6.5" (iPhone 11 Pro Max) | 1242 × 2688 | ✅ Yes |
| 5.5" (iPhone 8 Plus) | 1242 × 2208 | Optional |

### iPad Screenshots (If supporting iPad)
| Device | Size (pixels) | Required |
|--------|---------------|----------|
| 12.9" iPad Pro | 2048 × 2732 | Optional |
| 11" iPad Pro | 1668 × 2388 | Optional |

---

## Screenshot Capture Methods

### Method 1: Using iOS Simulator (Easiest)
1. Open Terminal and run:
   ```bash
   open -a Simulator
   ```
2. Select device: File → Open Simulator → iOS 17 → iPhone 15 Pro Max
3. Install the app:
   ```bash
   flutter run
   ```
4. Navigate to each screen and take screenshots:
   - **Cmd + S** to save screenshot to Desktop

### Method 2: Using Physical Device
1. Connect iPhone via USB
2. Open the app
3. Press **Side Button + Volume Up** simultaneously
4. Find screenshots in Photos app
5. AirDrop to Mac

### Method 3: Using Xcode
1. Run app on Simulator
2. In Simulator: File → Screenshot (Cmd + S)

---

## Recommended Screenshots (6 total)

### Screenshot 1: Home Screen with Word Card
**What to show**: Main home screen with a word card displayed
**Text overlay**: "Learn Tech Terms Daily"
**Steps**:
- Open app → Home tab should show word card
- Make sure a good example word is showing

### Screenshot 2: Word Detail View
**What to show**: Expanded word card with definition
**Text overlay**: "Clear Definitions & Examples"
**Steps**:
- Tap on a word card to expand
- Or view from Phases → Chapter → Word

### Screenshot 3: Phases Overview
**What to show**: Phases screen with progress indicators
**Text overlay**: "Structured Learning Path"
**Steps**:
- Tap PHASES in bottom nav
- Shows all phases with progress

### Screenshot 4: Chapter Words List
**What to show**: List of words in a chapter
**Text overlay**: "400+ Technical Terms"
**Steps**:
- PHASES → Select a phase → Select a chapter
- Show word list with mastery indicators

### Screenshot 5: Settings/Stats Screen
**What to show**: Settings with stats (streak, XP, words learned)
**Text overlay**: "Track Your Progress"
**Steps**:
- Tap settings icon in header
- Shows streak, XP, mastered/revision counts

### Screenshot 6: Search Screen
**What to show**: Search with results
**Text overlay**: "Find Any Word Instantly"
**Steps**:
- Tap FIND in bottom nav
- Type a search term to show results

---

## Adding Text Overlays

### Option 1: Free Tools
- **Canva** (canva.com) - Free templates
- **Figma** (figma.com) - Free design tool
- **Screenshots.pro** - Automated mockups

### Option 2: Quick Method with Preview (Mac)
1. Open screenshot in Preview
2. Tools → Annotate → Text
3. Add headline text
4. Export as PNG

### Design Tips
- Use consistent fonts (San Francisco or similar)
- Emerald green (#50C8AA) for accent color
- Dark background (#0A0A0A) matches app theme
- Keep text minimal - let the UI speak
- Add subtle device frame mockup for polish

---

## Screenshot Checklist

Before uploading, verify:

- [ ] Status bar shows appropriate time (9:41 AM is Apple's standard)
- [ ] Battery at 100%
- [ ] No notifications showing
- [ ] Correct device size for each slot
- [ ] Text overlays are readable
- [ ] No personal data visible
- [ ] App content represents actual functionality
- [ ] High quality (no blur or compression artifacts)

---

## Quick Commands for Simulators

```bash
# List available simulators
xcrun simctl list devices

# Boot a specific simulator
xcrun simctl boot "iPhone 15 Pro Max"

# Take screenshot of booted simulator
xcrun simctl io booted screenshot ~/Desktop/screenshot.png

# Record video (useful for App Preview)
xcrun simctl io booted recordVideo ~/Desktop/appvideo.mp4
```

---

## App Preview Video (Optional but Recommended)

- Duration: 15-30 seconds
- Size: Same as screenshots for each device
- Shows app in action
- No hands/fingers in frame
- Can include background music
- Must use footage captured from the app

---

## Uploading Screenshots

1. Go to App Store Connect
2. Select your app → App Store tab
3. Scroll to "Screenshots" section
4. Drag and drop screenshots for each device size
5. Arrange in desired order (1st screenshot is most important)
6. Save changes

Good luck with your App Store submission! 🚀
