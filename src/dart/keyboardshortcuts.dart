part of keyboard;

class KeyboardShortcuts{
  Map<int, Callback> _collection = new Map<int, Callback>();

  /**
   * Adds the callback with the [key]. Overwrites if allready present.
   */
  void add(int key, Callback callback){
    _collection[key] = callback;
  }

  /**
   * Removes key if present.
   */
  void remove (int key){
    _collection.remove(key);
  }

  /**
   * Calls the callback at the [key] if present.
   */
  bool callIfPresent(int key){
    if (_collection.containsKey(key)){
      _collection[key]();
      return true;
    }
    return false;
  }
}