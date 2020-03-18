#define kPackageBundleID "com.tapsharp.switcher.unicodefaces"
#define kPackageNamePreferenceChanged "com.tapsharp.switcher.unicodefaces/preferenceschanged"

#define UFSettings [SUFSettings sharedInstance]

// ---------------------------------------------------------------------------------------------------------------------
// Colors
// ---------------------------------------------------------------------------------------------------------------------

#define UIColorFromRGBA(r, g, b, a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:(float)a]
#define UIColorFromRGB(r, g, b) UIColorFromRGBA(r, g, b, 1.0f)
