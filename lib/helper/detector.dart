var debugMode = false;

bool isDebugMode() {
  assert(() {
    debugMode = true;

    return true;
  }());
  return debugMode;
}

bool isProductionMode = !isDebugMode();