extension NumberFormatting on String {
  String formatWithCommas() {
    
    final number = int.tryParse(this);
    if (number == null) return this;

    if (number < 1000) {
      return this;
    }

    final numberString = number.toString();
    final buffer = StringBuffer();
    int count = 0;

    
    for (int i = numberString.length - 1; i >= 0; i--) {
      buffer.write(numberString[i]);
      count++;

      if ((count == 3 && i > 0) || (count > 3 && (count - 3) % 3 == 0 && i > 0)) {
        buffer.write(',');
      }
    }

    return buffer.toString().split('').reversed.join('');
  }
}
