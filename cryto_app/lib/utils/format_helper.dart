

// Format large numbers like market cap: 1200000000 -> $1.2B
String formatLargeNumber(double value) {
  if (value >= 1e12) {
    return '\$${(value / 1e12).toStringAsFixed(2)}T';
  } else if (value >= 1e9) {
    return '\$${(value / 1e9).toStringAsFixed(2)}B';
  } else if (value >= 1e6) {
    return '\$${(value / 1e6).toStringAsFixed(2)}M';
  } else {
    return '\$${value.toStringAsFixed(2)}';
  }
}


String formatPrice(double price) {
  if (price >= 1) {
    return '\$${price.toStringAsFixed(2)}';
  } else if (price >= 0.01) {
    return '\$${price.toStringAsFixed(4)}';
  } else {
    return '\$${price.toStringAsFixed(8)}';
  }
}


String formatPercent(double percent) {
  final sign = percent >= 0 ? '+' : '';
  return '$sign${percent.toStringAsFixed(2)}%';
}
