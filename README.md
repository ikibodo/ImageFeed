[Читать на русском](./README.ru.md)

# Image Feed — Technical Specification

## Links

- [Design in Figma](https://www.figma.com/design/MujlanK7BDoQRrGci5G6pi/Image-Feed)
- [Unsplash API](https://unsplash.com/documentation)

## Purpose and Goals

A multi-page iOS application for browsing images provided by the Unsplash API.

Goals:

- Display an infinite feed of photos from Unsplash Editorial  
- Show brief information from the user profile  

## App Overview

- Unsplash OAuth authorization is required.
- The main screen is an image feed. Users can scroll the feed, like or unlike photos (the favorites list is available in the extended build).
- Each photo can be opened full-screen and shared outside the app.
- The profile screen shows basic user information and a list of favorite photos.
- Two builds are provided: **basic** and **extended**.  
  The extended build adds a favorites mechanism and the ability to like photos on the full-screen view.

---

## Non-Functional Requirements

### Technical requirements

1. Authorization uses Unsplash OAuth and a POST request to obtain the Auth Token.  
2. The feed is implemented with `UITableView`.  
3. UIKit components used: `UIImageView`, `UIButton`, `UILabel`, `UITabBarController`, `UINavigationController`, `UINavigationBar`, `UITableView`, `UITableViewCell`.  
4. Devices: iPhone running **iOS 13 or later**, portrait orientation only.  
5. All fonts are system fonts (currently `SF Pro` on iOS 13–16). In Interface Builder choose “System”; in code use `UIFont.systemFont(ofSize:weight:)`.

---

## Functional Requirements

### Authorization (OAuth)

The user must sign in with Unsplash OAuth.

**Authorization screen**

1. App logo  
2. **Sign In** button  

**Flow**

1. The app shows a splash screen on launch.  
2. After loading, the authorization screen appears.  
3. Tapping **Sign In** opens an in-app browser with the Unsplash login page.  
   - After pressing **Login** the browser closes and a loading view appears.  
   - If OAuth is misconfigured, nothing happens or an error alert appears.  
   - On failure the alert has an **OK** button that returns to the sign-in screen.  
   - On success the browser closes and the feed screen opens.

---

### Feed Viewing

The user browses images, opens photos, and likes / unlikes them.

**Feed screen**

- Image card:  
  - Like button  
  - Photo upload date  
- Tab bar for navigating between **Feed** and **Profile**

**Behavior**

1. The feed opens by default after authorization.  
2. Images come from Unsplash Editorial.  
3. Scrolling loads additional photos.  
   - While a photo is loading, a system loader is shown.  
   - If a photo cannot be loaded, a placeholder appears.  
4. Like button:  
   - A grey heart — tap to like; a loader appears.  
   - Success: icon turns red.  
   - Failure: modal error “Try again”.  
5. Unlike: red heart — tap; loader appears → success turns the icon grey or shows an error.  
6. Tapping a card opens the **Full-Screen Photo** view.  
7. The tab bar switches between **Feed** and **Profile**.

---

### Full-Screen Photo

From the feed a user opens a photo full-screen and can share it.

**Screen elements**

1. Photo scaled to device bounds  
2. Back button  
3. Share button  

**Behavior**

1. The photo fills the screen and is centered.  
   - If it cannot load: placeholder or alert.  
2. **Back** returns to the feed.  
3. Gestures allow pan, zoom, and rotate (if configured).  
4. Tapping **Share** opens the iOS share sheet.  
   - After the action, the sheet dismisses.  
   - The sheet can be closed by swipe or tapping the cross.

---

### User Profile

**Profile screen**

1. Profile data  
   - Avatar  
   - Name and username  
   - Bio  
2. **Sign Out** button  
3. Tab bar  

**Behavior**

1. Profile data is loaded from Unsplash and cannot be edited in-app.  
   - If data fails to load: avatar placeholder; name and username hidden.  
2. **Sign Out** shows a confirmation alert.  
   - **Yes**: logs the user out and returns to the authorization screen.  
   - **No**: dismisses the alert.  
3. The tab bar switches between **Feed** and **Profile**.

---

## Extended Version

### Favorites

In the extended build, liking a photo adds it to Favorites, which appears on the profile screen.  
Unlike the basic build, the like / unlike request is sent silently (no loader).

1. Like (grey heart) sends a request to add the photo to favorites.  
   - Success: icon turns red and the photo is saved.  
   - Failure: icon stays grey.  
2. Unlike (red heart) removes the photo from favorites.  
   - Failure: icon stays red.  
3. The full-screen view includes a like icon.  
4. Profile screen shows a **Favorites** section:  
   - Counter near the title.  
   - A feed of favorite photos with lazy loading, placeholders, and loaders.  
   - If empty: placeholder message.  
   - Likes can be removed here; the state updates in the main feed.  
   - Photos can be opened full-screen.
