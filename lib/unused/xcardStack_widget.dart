import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'dog_model.dart';
import 'xdrag_widget.dart';

class CardsStackWidget extends StatefulWidget {
  final User user;
  const CardsStackWidget({super.key, required this.user});

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    _currentUser = widget.user;
    _myDogsStream = FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentUser.uid)
        .snapshots();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();

          swipeNotifier.value = Swipe.none;
        }
      },
    );
  }

  late User _currentUser;
  late Stream<QuerySnapshot> _myDogsStream;
  late final AnimationController _animationController;
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);

  Future loadDogs() async {
    return await FirebaseFirestore.instance
        .collection('dogs')
        .where('owner', isEqualTo: _currentUser.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadDogs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ValueListenableBuilder(
                  valueListenable: swipeNotifier,
                  builder: (context, swipe, _) => Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children:
                        List.generate(snapshot.data?.docs.length, (index) {
                      if (index == snapshot.data?.docs.length - 1) {
                        return PositionedTransition(
                          rect: RelativeRectTween(
                            begin: RelativeRect.fromSize(
                                const Rect.fromLTWH(0, 0, 580, 340),
                                const Size(580, 340)),
                            end: RelativeRect.fromSize(
                                Rect.fromLTWH(
                                    swipe != Swipe.none
                                        ? swipe == Swipe.left
                                            ? -300
                                            : 300
                                        : 0,
                                    0,
                                    580,
                                    340),
                                const Size(580, 340)),
                          ).animate(CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeInOut,
                          )),
                          child: RotationTransition(
                            turns: Tween<double>(
                                    begin: 0,
                                    end: swipe != Swipe.none
                                        ? swipe == Swipe.left
                                            ? -0.1 * 0.3
                                            : 0.1 * 0.3
                                        : 0.0)
                                .animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(0, 0.4,
                                    curve: Curves.easeInOut),
                              ),
                            ),
                            child: DragWidget(
                              profile: Dog.fromJson(snapshot.data?.docs[index]),
                              index: index,
                              swipeNotifier: swipeNotifier,
                              isLastCard: true,
                            ),
                          ),
                        );
                      } else {
                        return DragWidget(
                          profile: Dog.fromJson(snapshot.data?.docs[index]),
                          index: index,
                          swipeNotifier: swipeNotifier,
                        );
                      }
                    }),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 46.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ActionButtonWidget(
                      //   onPressed: () {
                      //     swipeNotifier.value = Swipe.left;
                      //     _animationController.forward();
                      //   },
                      //   icon: const Icon(
                      //     Icons.close,
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      // const SizedBox(width: 20),
                      // ActionButtonWidget(
                      //   onPressed: () {
                      //     swipeNotifier.value = Swipe.right;
                      //     _animationController.forward();
                      //   },
                      //   icon: const Icon(
                      //     Icons.favorite,
                      //     color: Colors.red,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                child: DragTarget<int>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return IgnorePointer(
                      child: Container(
                        height: 700.0,
                        width: 80.0,
                        color: Colors.transparent,
                      ),
                    );
                  },
                  onAccept: (int index) {
                    index--;
                  },
                ),
              ),
              Positioned(
                right: 0,
                child: DragTarget<int>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return IgnorePointer(
                      child: Container(
                        height: 700.0,
                        width: 80.0,
                        color: Colors.transparent,
                      ),
                    );
                  },
                  onAccept: (int index) {
                    index++;
                  },
                ),
              ),
            ],
          );
        });
  }
}
