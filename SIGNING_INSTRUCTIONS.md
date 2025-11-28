# How to Sign Your App in Xcode

1.  **Xcode is now open** (or opening).
2.  In the left sidebar (Project Navigator), click on the top-level blue icon named **Runner**.
3.  In the main view, select the **Runner** target (under "Targets" in the sidebar of the main view).
4.  Click on the **Signing & Capabilities** tab at the top.
5.  In the **Signing** section:
    *   Ensure **Automatically manage signing** is checked.
    *   Click the **Team** dropdown.
    *   Select your **Apple ID** / **Development Team**.
6.  Wait a moment for Xcode to create the provisioning profiles.
7.  Once the red errors disappear, you are done!

You can now build the app with `flutter build macos` and it will be signed with your identity.
