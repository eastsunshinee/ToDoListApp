if which swiftlint > /dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed. Install it using Homebrew: brew install swiftlint"
fi
