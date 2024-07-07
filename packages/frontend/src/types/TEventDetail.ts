import { TEvent } from "./TEvent.ts";
import { TEventCallerParticipation } from "./TEventCallerParticipation.ts";
import { TJourneyPartial } from "./TJourneyPartial.ts";
import { TEventParticipation } from "./TEventParticipation.ts";
import { TExpense } from "./TExpense.ts";

export interface TEventDetail {
	event: TEvent,
	callerParticipation: TEventCallerParticipation,
	journey: TJourneyPartial | null,
	previewParticipants: TEventParticipation,
	expenses: TExpense[]
}
