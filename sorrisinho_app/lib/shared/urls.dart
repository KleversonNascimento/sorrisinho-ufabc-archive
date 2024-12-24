class Urls {
  static String base = 'http://134.209.218.218';
  static String calendarAllDates = '$base/calendar/all';
  static String busAllTrips = '$base/bus/all';
  static String restaurantAllMenus = '$base/restaurant/menu/all';
  static String restaurantAllRatings = '$base/restaurant/comment/all';
  static String allMyClasses(int ra) => '$base/classroom/allByRa/$ra';
  static String allDisciplines = '$base/discipline/all';
  static String theNews = '$base/the-news';
  static String insertSigaaText(int ra) =>
      '$base/discipline/enrollment/sigaa/$ra';
  static String noisResolve(int ra) => '$base/classroom/noisresolve/$ra';
  static String deleteCustomEnrollments(int ra) =>
      '$base/discifdfdpline/enrollment/sigaa/delete/$ra';
  static String makeRestaurantReview(int rating) =>
      '$base/restaurant/comment/$rating';
}
