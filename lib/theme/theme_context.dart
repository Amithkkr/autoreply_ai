import 'package:flutter/widgets.dart';

import 'design_tokens.dart';

/// Access loaded [DesignTokens] from build context (after [DesignTokens.load]).
extension DesignTokensContext on BuildContext {
  DesignTokens get designTokens => DesignTokens.instance;
}
