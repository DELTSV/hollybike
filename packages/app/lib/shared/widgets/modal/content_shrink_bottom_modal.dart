import 'package:flutter/material.dart';

class ContentShrinkBottomModal extends StatefulWidget {
  final Widget modalContent;
  final Widget child;
  final bool enableDrag;
  final int maxModalHeight;
  final void Function(bool opened)? onStatusChanged;

  const ContentShrinkBottomModal({
    super.key,
    required this.modalContent,
    required this.child,
    this.onStatusChanged,
    this.enableDrag = true,
    this.maxModalHeight = 300,
  });

  @override
  State<ContentShrinkBottomModal> createState() =>
      _ContentShrinkBottomModalState();
}

class _ContentShrinkBottomModalState extends State<ContentShrinkBottomModal> {
  late final double _bottomContainerMaxHeight =
      widget.maxModalHeight.toDouble();
  double _bottomContainerHeight = 0;

  bool _animate = false;
  bool _modalOpened = false;

  get modalOpened => _bottomContainerHeight == _bottomContainerMaxHeight;

  get modalOpening => _bottomContainerHeight > 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: _buildActions(),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: widget.enableDrag ? _onVerticalDragUpdate : null,
        onVerticalDragEnd: widget.enableDrag ? _onVerticalDragEnd : null,
        onVerticalDragStart: widget.enableDrag ? _onVerticalDragStart : null,
        child: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
                child: GestureDetector(
                  onTap: modalOpened ? _onTapImage : null,
                  child: widget.child,
                ),
              ),
              AnimatedContainer(
                duration: _animate
                    ? const Duration(milliseconds: 150)
                    : Duration.zero,
                curve: Curves.fastOutSlowIn,
                height: _bottomContainerHeight,
                onEnd: _onAnimateEnd,
                width: double.infinity,
                child: PopScope(
                  canPop: !modalOpened,
                  onPopInvoked: _onPopInvoked,
                  child: modalOpening
                      ? widget.modalContent
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget>? _buildActions() {
    if (_modalOpened || !widget.enableDrag) {
      return null;
    }

    return [
      IconButton(
        onPressed: () {
          _onOpened();
        },
        icon: const Icon(Icons.more_vert_rounded),
      ),
    ];
  }

  void _onOpened() {
    _onChangeHeight(_bottomContainerMaxHeight);
  }

  void _onClosed() {
    _onChangeHeight(1);
  }

  void _onChangeHeight(double height) {
    setState(() {
      _bottomContainerHeight = height;
    });

    if (widget.onStatusChanged != null) {
      if (_modalOpened != modalOpened) {
        widget.onStatusChanged!(modalOpened);

        setState(() {
          _modalOpened = modalOpened;
        });
      }
    }
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final delta = _bottomContainerHeight - details.delta.dy;
    _onChangeHeight(delta.clamp(0, _bottomContainerMaxHeight));
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! > 10) {
      _onClosed();
    } else if (details.primaryVelocity! < -10) {
      _onOpened();
    } else if (_bottomContainerHeight > _bottomContainerMaxHeight / 2) {
      _onOpened();
    } else {
      _onClosed();
    }

    setState(() {
      _animate = true;
    });
  }

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _animate = false;
    });
  }

  void _onTapImage() {
    _onClosed();
  }

  void _onPopInvoked(bool canPop) {
    if (!canPop) {
      _onClosed();
    }
  }

  void _onAnimateEnd() {
    if (_bottomContainerHeight == 1.0) {
      _onChangeHeight(0);
    }
  }
}
