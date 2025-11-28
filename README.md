# millitimer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Troubleshooting

### macOS "App is damaged" or "Malicious software" warning

If you see a warning that the app is damaged or malicious when trying to open it on macOS, this is because the app is not notarized by Apple. This is a standard security feature for apps distributed outside the App Store.

To fix this, run the included script in your terminal:

```bash
./fix_gatekeeper.sh
```

This script removes the "quarantine" attribute that triggers the warning.
