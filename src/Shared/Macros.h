#define kPackageBundleID "com.tapsharp.switcher.unicodefaces"
#define kPackageNamePreferenceChanged "com.tapsharp.switcher.unicodefaces/preferenceschanged"
#define kDefaultFaces @[@"¯\\_(ツ)_/¯", @"(⌐■_■)", @"๏̯͡๏﴿", @"q(●‿●)p", @"◎⃝ _◎⃝ ;", @"╭∩╮(-_-)╭∩╮", @"ಠ_ಠ", \
    @"ಠ‿ಠ", @"ಠ╭╮ಠ", @"(ง’̀-’́)ง", @"ꏱ𐐃.𐐃ꎍ", @"(ಥ﹏ಥ)", @"ᕕ( ᐛ )ᕗ", @"◉_◉", @"( ◕ ◡ ◕ )", @"(╯°□°）╯︵ ┻━┻", \
    @"┬─┬ノ( º _ ºノ)", @"(ு८ு_ .:)", @"ヽ(｀Д´)ﾉ", @"( ͡° ͜ʖ ͡°)", @"╿︡O͟-O︠╿", @"ʕ•ᴥ•ʔ", @"ʘ̃˻ʘ̃", @"༼ ༎ຶ ෴ ༎ຶ༽", \
    @"(☞ﾟヮﾟ)☞ ", @"(ᵔᴥᵔ)", @"[̲̅$̲̅(̲̅5̲̅)̲̅$̲̅]", @"ヽ༼ຈل͜ຈ༽ﾉ", @"(´･ω･`)", @"(・_・、)(_・、 )(・、 )", @"ლ,ᔑ•ﺪ͟͠•ᔐ.ლ", \
    @"⨀⦢⨀", @"º╲˚\\╭ᴖ_ᴖ╮/˚╱º", @"º(•♠•)º", @"✌ ⎦˚◡˚⎣ ✌"]

#define UFSettings [SUFSettings sharedInstance]

// ---------------------------------------------------------------------------------------------------------------------
// "FUNCTIONS!"
// ---------------------------------------------------------------------------------------------------------------------

#define TrimString(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
#define UIColorFromRGBA(r, g, b, a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:(float)a]
#define UIColorFromRGB(r, g, b) UIColorFromRGBA(r, g, b, 1.0f)
