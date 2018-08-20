import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Signature for a function that creates a widget with the supplied [FocusNode].
typedef Widget EnsureVisibleBuilder(BuildContext context, FocusNode focusNode);

/// A widget that ensures it is always visible inside its ancestor scrollable
/// when focused.
class EnsureVisible extends StatefulWidget {
  /// Creates a containing widget around the result of the supplied builder that
  /// ensures the view is always visible in its containing [Scrollable].
  const EnsureVisible({
    Key key,
    @required this.builder,
    this.alignment,
    this.duration: const Duration(milliseconds: 200),
    this.curve: Curves.ease,
  }) : super(key: key);

  /// Builder that must be supplied. Use the callback supplied [FocusNode] with
  /// your own child widgets like [TextField]. Doing this will ensure that when
  /// they receive the input focus they are scrolled into view.
  final EnsureVisibleBuilder builder;

  /// The `alignment` argument describes where the target should be positioned
  /// after applying the returned offset.
  ///
  /// The widget only uses the vertical axis value.
  ///
  /// If `alignment` is null then the widget will determine how much to scroll
  /// the [Scrollable] by to get it itself into view.
  ///
  /// If `alignment` is 0.0, the child must
  /// be positioned as close to the leading edge of the viewport as possible.
  ///
  /// If `alignment` is 1.0, the child must be positioned as close to the trailing
  /// edge of the viewport as possible.
  ///
  /// If `alignment` is 0.5, the child must be positioned as close to the center
  /// of the viewport as possible.
  final Alignment alignment;

  /// Duration of the scroll animation.
  final Duration duration;

  /// The curve to apply to the scroll animation.
  final Curve curve;

  @override
  _EnsureVisibleState createState() => _EnsureVisibleState();
}

class _EnsureVisibleState extends State<EnsureVisible>
    with WidgetsBindingObserver {
  final FocusNode _focusNode = new FocusNode();
  bool _alreadyScrolling = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(didChangeMetrics);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.removeListener(didChangeMetrics);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _focusNode);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNode.hasFocus && !_alreadyScrolling) {
        final alignment = resolveAlignment();
        if (alignment != null) {
          _alreadyScrolling = true;
          Scrollable.ensureVisible(context,
            alignment: alignment,
            duration: widget.duration,
            curve: widget.curve,
          ).whenComplete(() => _alreadyScrolling = false);
        }
      }
    });
  }

  double resolveAlignment() {
    if (widget.alignment == null) {
      final RenderObject object = context.findRenderObject();
      final RenderAbstractViewport viewport = RenderAbstractViewport.of(object);
      if (viewport == null) {
        // If we have no viewport we don't attempt to scroll.
        return null;
      }
      ScrollableState scrollableState = Scrollable.of(context);
      if (scrollableState == null) {
        // If we can't find a ancestor Scrollable we don't attempt to scroll.
        return null;
      }
      ScrollPosition position = scrollableState.position;
      if (position.pixels > viewport
          .getOffsetToReveal(object, 0.0)
          .offset) {
        // Move down to the top of the viewport
        return 0.0;
      }
      else if (position.pixels < viewport
          .getOffsetToReveal(object, 1.0)
          .offset) {
        // Move up to the bottom of the viewport
        return 1.0;
      }
      else {
        // No scrolling is necessary to reveal the child
        return null;
      }
    }
    else {
      // Use supplied Alignment parameter.
      return 0.5 + (0.5 * widget.alignment.y);
    }
  }
}