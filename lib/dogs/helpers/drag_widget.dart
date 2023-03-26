import 'package:flutter/material.dart';

import '../../main.dart';
import '../dog_model.dart';
import '../dog_profile.dart';
import 'tag_widget.dart';

class DragWidget extends StatefulWidget {
  const DragWidget(
      {Key? key,
      required this.profile,
      required this.index,
      required this.swipeNotifier})
      : super(key: key);
  final Dog profile;
  final int index;
  final ValueNotifier<Swipe> swipeNotifier;
  @override
  State<DragWidget> createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Draggable<int>(
        // Data is the value this Draggable stores.
        data: widget.index,
        feedback: Material(
          color: Colors.transparent,
          child: ValueListenableBuilder(
            valueListenable: swipeNotifier,
            builder: (context, swipe, _) {
              return RotationTransition(
                turns: swipe != Swipe.none
                    ? swipe == Swipe.left
                        ? const AlwaysStoppedAnimation(-15 / 360)
                        : const AlwaysStoppedAnimation(15 / 360)
                    : const AlwaysStoppedAnimation(0),
                child: Stack(
                  children: [
                    ProfileCard(profile: widget.profile),
                    swipe != Swipe.none
                        ? swipe == Swipe.right
                            ? Positioned(
                                top: 40,
                                left: 20,
                                child: Transform.rotate(
                                  angle: 12,
                                  child: TagWidget(
                                    text: 'LIKE',
                                    color: Colors.green[400]!,
                                  ),
                                ),
                              )
                            : Positioned(
                                top: 50,
                                right: 24,
                                child: Transform.rotate(
                                  angle: -12,
                                  child: TagWidget(
                                    text: 'DISLIKE',
                                    color: Colors.red[400]!,
                                  ),
                                ),
                              )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          ),
        ),
        onDragUpdate: (DragUpdateDetails dragUpdateDetails) {
          // When Draggable widget is dragged right
          if (dragUpdateDetails.delta.dx > 0 &&
              dragUpdateDetails.globalPosition.dx >
                  MediaQuery.of(context).size.width / 2) {
            swipeNotifier.value = Swipe.right;
          }
          // When Draggable widget is dragged left
          if (dragUpdateDetails.delta.dx < 0 &&
              dragUpdateDetails.globalPosition.dx <
                  MediaQuery.of(context).size.width / 2) {
            swipeNotifier.value = Swipe.left;
          }
        },
        onDragEnd: (drag) {
          swipeNotifier.value = Swipe.none;
        },

        childWhenDragging: Container(
          color: Colors.transparent,
        ),

        child: ProfileCard(profile: widget.profile),
      ),
    );
  }
}
