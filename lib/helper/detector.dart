var debugMode = false;

isDebugMode() {
  assert(() {
    debugMode = true;

    return true;
  }());
  return debugMode;
}
