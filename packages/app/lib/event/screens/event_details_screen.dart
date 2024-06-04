import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hollybike/event/types/event_form_data.dart';
import 'package:hollybike/event/widgets/details/event_details_content.dart';
import 'package:hollybike/event/widgets/details/event_details_header.dart';
import 'package:hollybike/event/widgets/details/event_edit_floating_button.dart';
import 'package:hollybike/event/widgets/event_image.dart';
import 'package:hollybike/shared/utils/with_current_session.dart';
import 'package:hollybike/shared/widgets/bar/top_bar.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_prefix_button.dart';
import 'package:hollybike/shared/widgets/bar/top_bar_title.dart';
import 'package:hollybike/shared/widgets/hud/hud.dart';

import '../../shared/widgets/app_toast.dart';
import '../bloc/event_details_bloc/event_details_bloc.dart';
import '../bloc/event_details_bloc/event_details_event.dart';
import '../bloc/event_details_bloc/event_details_state.dart';

@RoutePage()
class EventDetailsScreen extends StatefulWidget {
  final int eventId;
  final EventImage eventImage;
  final String eventName;
  final bool animate;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.eventImage,
    required this.eventName,
    this.animate = true,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  var eventName = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      eventName = widget.eventName;
    });

    _loadEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventDetailsBloc, EventDetailsState>(
      listener: (context, state) {
        if (state is EventOperationFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is EventDetailsLoadFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        } else if (state is DeleteEventFailure) {
          Toast.showErrorToast(context, state.errorMessage);
        }

        if (state is EventOperationSuccess) {
          Toast.showSuccessToast(context, state.successMessage);
        }

        if (state is DeleteEventSuccess) {
          context.router.maybePop();
        }

        setState(() {
          eventName = state.eventDetails?.event.name ?? widget.eventName;
        });
      },
      child: Hud(
        appBar: TopBar(
          prefix: TopBarPrefixButton(
            onPressed: () => context.router.maybePop(),
            icon: Icons.arrow_back,
          ),
          title: const TopBarTitle("Détails"),
        ),
        floatingActionButton: BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailsLoadFailure ||
                state is EventDetailsLoadInProgress ||
                state.eventDetails == null) {
              return const SizedBox();
            }

            final eventDetails = state.eventDetails!;

            return EventEditFloatingButton(
              canEdit: eventDetails.isOrganizer,
              event: eventDetails.event,
              onEdit: _onEdit,
            );
          },
        ),
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              EventDetailsHeader(
                eventId: widget.eventId,
                eventName: eventName,
                eventImage: widget.eventImage,
                animate: widget.animate,
              ),
              BlocBuilder<EventDetailsBloc, EventDetailsState>(
                builder: (context, state) {
                  if (state is EventDetailsLoadInProgress) {
                    return const CircularProgressIndicator();
                  }

                  if (state is EventDetailsLoadFailure) {
                    return const Text("Error while loading event details");
                  }

                  if (state.eventDetails == null) {
                    return const Text("Event not found");
                  }

                  return EventDetailsContent(
                    eventDetails: state.eventDetails!,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _loadEventDetails() {
    withCurrentSession(
      context,
      (session) {
        context.read<EventDetailsBloc>().add(
              LoadEventDetails(
                eventId: widget.eventId,
                session: session,
              ),
            );
      },
    );
  }

  void _onEdit(EventFormData formData) {
    withCurrentSession(context, (session) {
      context.read<EventDetailsBloc>().add(
            EditEvent(
              session: session,
              eventId: widget.eventId,
              formData: formData,
            ),
          );
    });

    Navigator.of(context).pop();
  }
}
