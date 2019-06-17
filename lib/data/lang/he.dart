class HeLang {
  Map<String, dynamic> _lang = {
    // fields
    "field-name": "שם",
    "field-email": "דואל",
    "field-amount": "סכום",
    "field-date": "תאריך",
    "field-timestamp": "תאריך",
    "field-notifications": "התראות",
    "field-roles": "תפקידים",
    "field-language": "שפה",
    "field-viewMode": "תצוגה",
    "field-type": "סוג",
    "field-receiptNumber": "מספר חשבונית",
    "field-status": "סטטוס",
    "field-disabled": "מושבת",
    "field-money": "כסף",
    "field-allowedCredit": "מכסת אשראי",

    // buttons
    "button-yes": "כן",
    "button-no": "לא",
    "button-close": "סגור",
    "button-back": "חזור",
    "button-view": "הצג",
    "button-save": "שמור",
    "button-saving": "שומר...",
    "button-saved": "נשמר",

    // core widgets
    "core-table:w-st": ["מציג פריטים ", " - ", " מתוך "],
    "core-refreshing": "מרענן...",
    "core-loading": "טוען...",
    "core-emptySpace": "הי, זה נראה שאין מה לראות כאן...",

    // status types
    "status-types": {"success": "בוצע בהצלחה", "in process": "בתהליך"},

    // action types
    "action-types": {
      "buy": "קניה",
      "discount": "הוספת הנחה",
      "credit": "עדכון מכסת אשראי",
      "money": "העברה כספית",
      "refund": "החזר כספי",
    },

    // roles types
    "roles-types": {
      "admin": "מנהל",
      "customer": "לקוח",
      "insider": "פנימאי",
    },

    // account page
    "acc:p-t": "חשבון שלי",
    "acc:p-balance:w-t": "יתרה",
    "acc:p-balance:w-st": [
      "מכסת האשראי שלך הוא ",
      " שח, הינך יכול לבקש ממנהל להגדיל את המכסה."
    ],
    "acc:p-activity:w-t": "פעולות בחשבון",
    "acc:p-activity:w-st": "רשימה זו מכילה את כל הפעולות שנעשו בחשבונך.",
    "acc:p-settings:w-t": "הגדרות",
    "acc:p-settings:w-notifications": "שנה את הגדרות ההתראות שלך",
    "acc:p-settings:w-viewMode": {"light": "יום", "dark": "לילה"},
    "acc:p-settings:w-signOut-b": "צא מהחשבון",
    "acc:p-settings:w-deleteAccount-b": "מחק חשבון",
    "acc:p-newVersion": "קיימת גרסה חדשה להורדה בחנות!",

    // activity detailes dialog
    "activityDetailes:d-t": "פרטי פעולה",
    "activityDetailes:d-notProvided": "לא קיים",
    "activityDetailes:d-requestRefund": "בקש החזר",

    // notification settings dialog
    "notificationSettings:d-t": "הגדרות התראות",
    "notificationSettings:d-1": "קבל התראות חשובות",
    "notificationSettings:d-2": "קבל התראות כלליות",
    "notificationSettings:d-3": "קבל התראות לגבי מבצעים והנחות",

    // store page
    "store:p-t": "חנות",
    "store:p-itemPrice": "שח",

    // item page
    "item:p-inStock": "קיים במלאי",
    "item:p-outOfStock": "חסר במלאי",
    "item:p-buyButton": ["קנה עכשיו ב ", " שח"],
    "item:p-hechesher": "הכשר",
    "item:p-notKosher": "לא כשר...",

    //home page
    "home:p-newVersion-sb": "יש גרסה חדשה של האפליקציה בחנות!",
    "home:p-storeClosed-sb": "החנות סגורה.",

    // message dialog
    "mag:d-success-t": "הודעת הצלחה",
    "mag:d-error-t": "הודעת שגיעה",
    "mag:d-unknown-t": "הודעה",

    // messages [general]
    "mag:d-gs0": "הפעולה בוצעה בהצלחה.",
    "mag:d-ge0": "אופס... משהו לא מתוכנן קרה, אנא נסה שוב.",
    "mag:d-ge1": "שינה בעיה בחיבור לרשת, אנא בדוק את חיבור האינטרנט שלך.",
    "mag:d-ge2":
        "אנו מצטערים, לא ניתן להתחבר לרשת שלנו כעת, אנא נסה שוב מאוחר יותר.",
    "mag:d-ge3": "פג תוקף של הבקשה.",
    "mag:d-ge4": "אנו לא מצליחים לכנס לחשבון שלך. אנא נסה לאתחל את האפליקציה.",
    "mag:d-geUnknown": "אופס... משהו לא מתוכנן קרה, אנא נסה שוב.",

    // messages [buy]
    "mag:d-b-gs0": "תהנה מהמרק!",
    "mag:d-b-e0":
        "אנו מצטערים, המוצר הנבחר אינו קיים במלאי כרגע. אנו עושים ככל שביכולתינו להחזיר לכם אותו בהקדם.",
    "mag:d-b-e1": "אויש. נראה כי אין לך מספיק כסף בחשבון לקנות מוצר זה.",
    "mag:d-b-e2": "המוצר הנבחר אינו קיים בחנות. אנא  בחר מוצר אחר.",

    // messages [money]
    "mag:d-m-gs0": "ההעברה הכספית הושלמה בהצלחה!",
    "mag:d-m-e0": "הקוד הנסרק אינו קיים יותר.",
    "mag:d-m-e1":
        "נראה כי סרקת כבר את הברקוד בהצלחה. לא ניתן לסרוק אותו פעמיים.",
    "mag:d-m-e2": "פג תוקפו של הברקוד.",

    // messages [discount]
    "mag:d-d-gs0": "ההנחה הועברה לחשבונך בהצלחה!",
    "mag:d-d-e0": "הקוד הנסרק אינו קיים יותר.",
    "mag:d-d-e1":
        "נראה כי סרקת כבר את הברקוד בהצלחה. לא ניתן לסרוק אותו פעמיים.",
    "mag:d-d-e2": "פג תוקפו של הברקוד.",

    // messages [note]
    "mag:d-n-e0": "הקוד הנסרק אינו קיים יותר.",
    "mag:d-n-e1":
        "נראה כי סרקת כבר את הברקוד בהצלחה. לא ניתן לסרוק אותו פעמיים.",
    "mag:d-n-e2": "פג תוקפו של הברקוד.",

    // messages [credit]
    "mag:d-c-gs0": "עדכון מסגרת אשראי שלך עודכנה בהצלחה!",
    "mag:d-c-e0": "הקוד הנסרק אינו קיים יותר.",
    "mag:d-c-e1": "פג תוקפו של הברקוד.",

    // messages [scanner]
    "msg:d-s-e0": "אנו מתקשים לזהות את הברקוד, אנא וודא כי הוא נראה בברור.",
    "msg:d-s-e1": "אנא אפשר לאפליקציה להשתמש עם המצלמה כדי שתוכל לסרוק ברקודים.",
    "msg:d-s-e2": "אופס. נראה כי הברקוד הנסרק אינו קיים",
  };

  get lang => _lang;
}

final HeLang heLang = HeLang();
