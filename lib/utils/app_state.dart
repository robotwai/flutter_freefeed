import 'package:flutter/material.dart';

class AppState {
  ValueNotifier<bool> canListenLoading = ValueNotifier(false);
  bool isLoading;

  AppState({this.isLoading = true});

  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading}';
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final AppState data;

  //我们知道InheritedWidget总是包裹的一层，所以它必有child
  _InheritedStateContainer(
      {Key key, @required this.data, @required Widget child})
      : super(key: key, child: child);

  //参考MediaQuery,这个方法通常都是这样实现的。如果新的值和旧的值不相等，就需要notify
  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) =>
      data != oldWidget.data;
}

class AppStateContainer extends StatefulWidget {
  //这个state是我们需要的状态
  final AppState state;

  //这个child的是必须的，来显示我们正常的控件
  final Widget child;

  AppStateContainer({this.state, @required this.child});

  //4.模仿MediaQuery,提供一个of方法，来得到我们的State.
  static AppState of(BuildContext context) {
    //这个方法内，调用 context.inheritFromWidgetOfExactType
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    as _InheritedStateContainer)
        .data;
  }

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {

  //2. 在build方法内返回我们的InheritedWidget
  //这样App的层级就是 AppStateContainer->_InheritedStateContainer-> real app
  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
      data: widget.state,
      child: widget.child,
    );
  }
}