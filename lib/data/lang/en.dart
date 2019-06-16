class EnLang {
  Map<String, dynamic> _lang = {
    // fields
    "field-name": "Name",
    "field-email": "Email",
    "field-amount": "Amount",
    "field-date": "Date",
    "field-timestamp": "Timestamp",
    "field-notifications": "Notifications",
    "field-roles": "Roles",
    "field-language": "Language",
    "field-viewMode": "View Mode",
    "field-type": "Type",
    "field-receiptNumber": "Receipt Number",
    "field-status": "Status",
    "field-disabled": "Disabled",
    "field-money": "Money",
    "field-allowedCredit": "Allowed Credit",

    // buttons
    "button-yes": "YES",
    "button-no": "NO",
    "button-close": "CLOSE",
    "button-back": "BACK",
    "button-view": "VIEW",
    "button-save": "SAVE",
    "button-saving": "SAVING...",
    "button-saved": "SAVED",

    // core widgets
    "core-table:w-st": ["displaying items ", " - ", " of "],
    "core-refreshing": "Refreshing...",
    "core-loading": "Loading...",
    "core-emptySpace": "Hey! it looks like there is nothing to see here.",

    // status types
    "status-types": {"success": "Success", "in process": "In Process"},

    // action types
    "action-types": {
      "buy": "Buy",
      "discount": "Added Discount",
      "credit": "Credit Update",
      "money": "Money Transfer",
      "refund": "refund",
    },

    "roles-types": {
      "admin": "Admin",
      "customer": "Customer",
      "insider": "Insider",
    },

    // account page
    "acc:p-t": "account",
    "acc:p-balance:w-t": "Balance",
    "acc:p-balance:w-st": [
      "You have up to ",
      " NIS in credit, ask a admin to give you more."
    ],
    "acc:p-activity:w-t": "Activity",
    "acc:p-activity:w-st":
        "The list contains every successful activity that occurred in your account.",
    "acc:p-settings:w-t": "Settings",
    "acc:p-settings:w-notifications": "Change when you receive notifications",
    "acc:p-settings:w-viewMode": {"light": "Light", "dark": "Dark"},
    "acc:p-settings:w-signOut-b": "SIGN OUT",
    "acc:p-settings:w-deleteAccount-b": "DELETE ACCOUNT",
    "acc:p-newVersion":
        "There is a new version to download from the Play Store!",

    // activity detailes dialog
    "activityDetailes:d-t": "Activity Detailes",
    "activityDetailes:d-notProvided": "Not Provided",
    "activityDetailes:d-requestRefund": "Request Refund",

    // notification settings dialog
    "notificationSettings:d-t": "Notification Settings",
    "notificationSettings:d-1": "Receive important notifications",
    "notificationSettings:d-2": "Receive general notifications",
    "notificationSettings:d-3":
        "Receive special discounts and sales notifications",

    // store page
    "store:p-t": "store",
    "store:p-itemPrice": "NIS",

    // item page
    "item:p-inStock": "In Stock",
    "item:p-outOfStock": "Out Of Stock",
    "item:p-buyButton": ["BUY NOW FOR ", " NIS"],
    "item:p-hechesher": "Hechsher",
    "item:p-notKosher": "Not kosher...",

    //home page
    "home:p-newVersion-sb": "There is a new version to download from the Play Store!",
    "home:p-storeClosed-sb": "The store is closed!",

    // message dialog
    "mag:d-success-t": "Success message",
    "mag:d-error-t": "Error message",
    "mag:d-unknown-t": "Unknown Message",

    // messages [general]
    "mag:d-gs0": "The operation was successfull.",
    "mag:d-ge0":
        "Oops... Something unexpected happened, please try again later.",
    "mag:d-ge1":
        "Error connecting to network, please check your internet connection.",
    "mag:d-ge2":
        "We are sorry, we are unable to connect to our servers right now, please try again later.",
    "mag:d-ge3": "The request use-by date has expierd.",
    "mag:d-ge4":
        "Can not sign in with the current user id, please try restarting the app.",
    "mag:d-geUnknown":
        "An unknown error occured, we would be able to help me if you leave us some feadback.",

    // messages [buy]
    "mag:d-b-gs0": "Enjoy your soup!",
    "mag:d-b-e0":
        "We are sorry, currently this item is out of stock. We are trying are best to get it back to you!",
    "mag:d-b-e1":
        "Ouch. It seems like you don't have enough money to my this. You might want to add money to your account.",
    "mag:d-b-e2":
        "The requested item doesn't exist in the store, please try selecting a differant item.",

    // messages [money]
    "mag:d-m-gs0": "The money was successfully transfered to your account!",
    "mag:d-m-e0": "The scanned code doesn't exist anymore.",
    "mag:d-m-e1":
        "It looks like you have successfully used the code already. It can't be used twice.",
    "mag:d-m-e2": "The barcode has expired.",

    // messages [discount]
    "mag:d-d-gs0": "The discount was successfully applied to your account!",
    "mag:d-d-e0": "The scanned code doesn't exist anymore.",
    "mag:d-d-e1":
        "It looks like you have successfully used the code already. It can't be used twice.",
    "mag:d-d-e2": "The barcode has expired.",

    // messages [credit]
    "mag:d-c-gs0": "The credit update was successfully applied account!",
    "mag:d-c-e0": "The scanned code doesn't exist anymore.",
    "mag:d-c-e1": "The barcode has expired.",

    // messages [scanner]
    "msg:d-s-e0":
        "There is a problem recognising the barcode, please make your you are in a light place.",
    "msg:d-s-e1":
        "Please enable camera permissions so you can use the scanner.",
    "msg:d-s-e2": "Umm... It looks like this barcode dosn't exist.",
  };

  get lang => _lang;
}

final EnLang enLang = EnLang();
