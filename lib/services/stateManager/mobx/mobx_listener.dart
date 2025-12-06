import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

typedef MobxCondition<T> = bool Function(T previous, T current);
typedef MobxListenCallback<T> = void Function(BuildContext context, T state);

class MobxStateListener<T> extends StatefulWidget {
  const MobxStateListener({
    super.key,
    required this.getState,
    required this.child,
    this.listenWhen,
    required this.onListen,
  });

  final T Function() getState;

  final MobxCondition<T>? listenWhen;

  final MobxListenCallback<T> onListen;

  final Widget child;

  @override
  State<MobxStateListener<T>> createState() => _MobxStateListenerState<T>();
}

class _MobxStateListenerState<T> extends State<MobxStateListener<T>> {
  T? _previous;

  @override
  void initState() {
    super.initState();
    _previous = widget.getState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final current = widget.getState();
        final shouldListen = widget.listenWhen?.call(_previous as T, current) ?? (_previous != current);
        if (shouldListen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onListen(context, current);
          });
          _previous = current;
        }
        return widget.child;
      },
    );
  }
}
