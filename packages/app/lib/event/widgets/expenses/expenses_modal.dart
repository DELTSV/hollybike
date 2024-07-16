/*
  Hollybike Mobile Flutter application
  Made by enzoSoa (Enzo SOARES) and Loïc Vanden Bossche
*/
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_bloc.dart';
import 'package:hollybike/event/bloc/event_details_bloc/event_details_state.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_bloc.dart';
import 'package:hollybike/event/bloc/event_expenses_bloc/event_expenses_state.dart';
import 'package:hollybike/event/widgets/expenses/budget_progress.dart';
import 'package:hollybike/event/widgets/expenses/expense_card.dart';
import 'package:hollybike/event/widgets/expenses/expenses_modal_header.dart';
import 'package:hollybike/shared/utils/safe_set_state.dart';
import 'package:hollybike/shared/widgets/app_toast.dart';
import 'package:hollybike/shared/widgets/loaders/themed_refresh_indicator.dart';
import 'package:hollybike/shared/widgets/pinned_header_delegate.dart';

import '../../bloc/event_details_bloc/event_details_event.dart';

class InvertedRoundedRectanglePainter extends CustomPainter {
  InvertedRoundedRectanglePainter({
    required this.radius,
    required this.color,
  });

  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cornerSize = Size.square(radius * 2);
    canvas.drawPath(
      Path()
        ..addArc(
          // top-left arc
          Offset(0, -radius) & cornerSize,
          // 180 degree startAngle (left of circle)
          pi,
          // -90 degree sweepAngle (counter-clockwise to the bottom)
          -pi / 2,
        )
        ..arcTo(
          // top-right arc
          Offset(size.width - cornerSize.width, -radius) & cornerSize,
          // 90 degree startAngle (bottom of circle)
          pi / 2,
          // -90 degree sweepAngle (counter-clockwise to the right)
          -pi / 2,
          false,
        )
        // bottom right of painter
        ..lineTo(size.width, size.height)
        // bottom left of painter
        ..lineTo(0, size.height),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(InvertedRoundedRectanglePainter oldDelegate) =>
      oldDelegate.radius != radius || oldDelegate.color != color;
}

class ExpensesModal extends StatefulWidget {
  const ExpensesModal({
    super.key,
  });

  @override
  State<ExpensesModal> createState() => _ExpensesModalState();
}

class _ExpensesModalState extends State<ExpensesModal> {
  final ScrollController scrollController = ScrollController();
  bool _animating = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(16);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventExpensesBloc, EventExpensesState>(
      listener: (context, state) {
        if (state is EventExpensesOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }

        if (state is EventExpensesOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(31),
            topRight: Radius.circular(31),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
                builder: (context, state) {
                  final eventName = state.eventDetails?.event.name;
                  final expenses = state.eventDetails?.expenses;
                  final budget = state.eventDetails?.event.budget;
                  final totalExpenses = state.eventDetails?.totalExpense;

                  if (expenses == null ||
                      totalExpenses == null ||
                      eventName == null) {
                    return const SizedBox();
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpensesModalHeader(
                        budget: budget,
                        expenses: expenses,
                        eventName: eventName,
                      ),
                      const SizedBox(height: 16),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 400,
                          minHeight: 0,
                        ),
                        child: ThemedRefreshIndicator(
                          onRefresh: () => _refreshEventDetails(context),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: NotificationListener(
                              onNotification: (notificationInfo) {
                                if (notificationInfo is ScrollUpdateNotification) {
                                  if (notificationInfo.dragDetails == null && !_animating) {
                                    if (scrollController.offset < 16) {
                                      scrollController.jumpTo(16);
                                    }
                                  }
                                }
                                return false;
                              },
                              child: CustomScrollView(
                                controller: scrollController,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                slivers: [
                                  SliverPersistentHeader(
                                    pinned: true,
                                    delegate: PinnedHeaderDelegate(
                                      height: 132,
                                      animationDuration: 300,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(14),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                                  ),
                                                  child: BudgetProgress(
                                                    expenses: expenses,
                                                    budget: budget,
                                                    totalExpenses: totalExpenses,
                                                    animateStart: false,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                              ],
                                            ),
                                          ),
                                          Transform.flip(
                                            transformHitTests: false,
                                            flipY: true,
                                            child: SizedBox(
                                              height: 16,
                                              width: double.infinity,
                                              child: CustomPaint(
                                                painter:
                                                InvertedRoundedRectanglePainter(
                                                  radius: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SliverList.builder(
                                    itemBuilder: (context, index) {
                                      final expense = expenses[index];

                                      return TweenAnimationBuilder(
                                        tween: Tween<double>(begin: 0, end: 1),
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                        builder: (context, double value, child) {
                                          return Transform.translate(
                                            offset: Offset(30 * (1 - value), 0),
                                            child: Opacity(
                                              opacity: value,
                                              child: ExpenseCard(
                                                expense: expense,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    itemCount: expenses.length,
                                  ),
                                  const SliverToBoxAdapter(
                                    child: SizedBox(height: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshEventDetails(BuildContext context) {
    context.read<EventDetailsBloc>().add(
      LoadEventDetails(),
    );

    scrollController.animateTo(
      16,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    setState(() {
      _animating = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      safeSetState(() {
        _animating = false;
      });
    });

    return context.read<EventDetailsBloc>().firstWhenNotLoading;
  }
}
