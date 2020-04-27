import 'package:flutter/material.dart';

/// The Candle class that sets the ghost away to be away, or not
class GhostResponse extends StatelessWidget {
  /// What the ghost is currently saying to the user
  final String _curResp;

  /// If the ghost is currently able to interact with the human
  final bool _canInteract;

  final GlobalKey _ghostResponseKey;

  GhostResponse(this._curResp, this._canInteract, this._ghostResponseKey);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          _canInteract ? _curResp : "The ghost doesn't like the candle",
          key: _ghostResponseKey,
          style: Theme.of(context).textTheme.body1.copyWith(
                fontSize: 20,
                fontStyle: _canInteract ? FontStyle.normal : FontStyle.italic,
              ),
          textAlign: TextAlign.center,
        ));
  }
}
