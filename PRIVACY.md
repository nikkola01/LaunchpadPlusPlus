# Launchpad++ Privacy

Launchpad++ is designed as a local macOS application launcher with minimal permissions. This document describes the current source tree; review the release notes if a later version changes these boundaries.

## Data collection

Launchpad++ does not include analytics, telemetry, advertising, user accounts, or a remote data service. The application does not send your app list, layout, categories, searches, or preferences to the Launchpad++ maintainer.

The **Buy Me a Coffee** item is a normal web link. Selecting it asks macOS to open `https://buymeacoffee.com/nnikolov01` in your default browser; the website and browser then operate under their own privacy policies. Launchpad++ does not contact that service in the background.

## Local data

The app stores the following locally through macOS preferences:

- app and folder order;
- hidden app paths;
- visual and behavior settings;
- optional custom application locations;
- category names and app-path memberships.

Layout and category import/export uses `LaunchpadLayout.json` and `LaunchpadCategories.json` in the user's Documents folder. Those files can reveal installed-app names and local filesystem paths. Review them before sharing and delete them when no longer needed.

Launchpad++ reads application metadata and icons from:

- `/Applications`;
- `/System/Applications`;
- additional folders explicitly configured by the user.

If the legacy-layout import action is used, the app attempts to read the local macOS Launchpad database to reconstruct the old arrangement. It does not upload that database.

## Permissions and system integration

The current app entitlement file is empty. Launchpad++ does not request entitlements for the camera, microphone, location, Contacts, Photos, Accessibility, or Full Disk Access.

Some user-selected functions interact with macOS:

- **Start at Login** registers or unregisters the main app using Apple's `SMAppService` API.
- **Custom background** opens a system file picker and stores the selected image path.
- **Custom app locations** scan the directories entered by the user.
- **Open app** asks `NSWorkspace` to launch the selected local application.
- **Wallpaper background** reads the current desktop-image location through `NSWorkspace`.

macOS controls whether any of these operations require confirmation in the user's environment. Launchpad++ should be usable as a launcher without Accessibility, Full Disk Access, camera, microphone, location, Contacts, or Photos permission.

## Network access

The current source does not contain an app networking client. Opening an external support link hands the URL to your browser.

## Retention and deletion

Launchpad++ has no maintainer-operated account or cloud store, so there is no remote profile to delete. Local exported JSON files can be removed in Finder. Application preferences can be removed by deleting Launchpad++'s preferences through macOS or by resetting the app's data, noting that this permanently removes the saved layout and categories.

## Changes

If a future release adds networking, diagnostics, or a permission-sensitive feature, this document and the release notes should be updated before publication.

## Questions

For a privacy concern, open a GitHub issue without including sensitive paths or files. For a security vulnerability, follow [SECURITY.md](SECURITY.md).

