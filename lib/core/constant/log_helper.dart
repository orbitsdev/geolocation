class Log {

  static void print(dynamic data, {String title = 'Log'}){
    print('|-----------------------------${title}---------------------------------|');
    print(data);
    print('|----------------------------------------------------------------------| ');
  }
}