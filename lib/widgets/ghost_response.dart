import 'package:flutter/material.dart';

/// The Candle class that sets the ghost away to be away, or not
class GhostResponse extends StatelessWidget {
  /// What the ghost is currently saying to the user
  final String _curResp;

  /// If the ghost is currently able to interact with the human
  final bool _canInteract;

  GhostResponse(this._curResp, this._canInteract);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          _canInteract ? _curResp : "The ghost doesn't like the candle",
          style: Theme.of(context).textTheme.body1.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontStyle: _canInteract ? FontStyle.normal : FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        )
    );
  }
}