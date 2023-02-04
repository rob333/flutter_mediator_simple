import 'package:flutter/widgets.dart';

typedef SubscriberTag = int;
typedef SubscriberTagSet = Set<SubscriberTag>;
typedef SubscriberFn = Widget Function(Widget Function() builder, {Key? key});

/// Static Methods/Top Level functions
final Map<Object, SubscriberTagSet> _subscriberMap = {};
final SubscriberTagSet _rebuildSet = {};
final SubscriberTagSet _capturingSet = {};

bool _isCapturing = false;
bool _isSetRebuild = false;

void _register(BuildContext context, SubscriberTagSet aspects) {
  var set = _subscriberMap[context];
  if (set == null) {
    set = {};
    _subscriberMap[context] = set;
  }
  set.addAll(aspects);
}

void _futureQueue() {
  assert(_isSetRebuild == true);
  Future(
    () {
      if (_rebuildSet.isNotEmpty) {
        _shouldRebuild();

        _rebuildSet.clear();
        _isSetRebuild = false;
      }
    },
  );
}

void _shouldRebuild() {
  final List<BuildContext> toRemove = [];

  _subscriberMap.forEach((context, aspects) {
    final elem = context as Element;
    if (elem.mounted) {
      if (_rebuildSet.intersection(aspects).isNotEmpty) {
        elem.markNeedsBuild();
      }
    } else {
      toRemove.add(context);
    }
  });

  if (toRemove.isNotEmpty) {
    for (int i = 0, n = toRemove.length; i < n; i++) {
      final elem = toRemove[i];
      _subscriberMap.remove(elem);
    }
  }
}

/// Subscriber widget class: to register Mediator Variables for automatic rebuild.
///
class Subscriber extends StatefulWidget {
  /// Method for rx getter: register the widget with aspects.
  static void addRxAspects(SubscriberTagSet aspects) {
    if (_isCapturing) {
      _capturingSet.addAll(aspects);
    }
  }

  /// Method for rx setter: notify to rebuild widget with aspects.
  static void setToRebuild(SubscriberTagSet aspects) {
    _rebuildSet.addAll(aspects);
    if (!_isSetRebuild) {
      _isSetRebuild = true;
      _futureQueue();
    }
  }

  /// class members:
  final Widget Function() builder;

  /// Contrustor:
  const Subscriber({
    super.key,
    required this.builder,
  });

  @override
  State<Subscriber> createState() => _SubscriberState();
}

class _SubscriberState extends State<Subscriber> {
  @override
  void dispose() {
    _subscriberMap.remove(context);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _isCapturing = true;
    final child = widget.builder();
    _register(context, _capturingSet);
    _isCapturing = false;

    _capturingSet.clear();

    return child;
  }
}

/// `StatelessWidget` version of `Subscriber` class:
// class Subscriber extends StatelessWidget {
//   /// Method for rx getter: register the widget with aspects.
//   static void addRxAspects(SubscriberTagSet aspects) {
//     if (_isCapturing) {
//       
//       _capturingSet.addAll(aspects);
//     }
//   }

//   /// Method for rx setter: notify to rebuild widget with aspects.
//   static void setToRebuild(SubscriberTagSet aspects) {
//     
//     _rebuildSet.addAll(aspects);
//     if (!_isSetRebuild) {
//       _isSetRebuild = true;
//       _futureQueue();
//     }
//   }

//   /// class members:
//   final Widget Function() builder;

//   /// Contrustor:
//   const Subscriber({
//     super.key,
//     required this.builder,
//   });

//   @override
//   Widget build(BuildContext context) {
//     _isCapturing = true;
//     final child = builder();
//     _register(context, _capturingSet);
//     _isCapturing = false;

//     _capturingSet.clear();

//     return child;
//   }
// }
