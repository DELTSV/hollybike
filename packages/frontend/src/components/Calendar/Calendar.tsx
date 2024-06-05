import {
	Day, useLilius,
} from "use-lilius";
import {
	ChevronLeft, ChevronRight,
} from "@material-ui/icons";
import { clsx } from "clsx";
import {
	Dispatch, StateUpdater, useEffect,
} from "preact/hooks";

export interface CalendarProps {
	time?: boolean,
	seconds?: boolean
	value?: Date,
	setValue?: Dispatch<StateUpdater<Date | undefined>>
}

export function Calendar(props: CalendarProps) {
	const {
		calendar, viewPreviousMonth, viewNextMonth, viewing, setViewing,
	} = useLilius({
		weekStartsOn: Day.MONDAY,
		viewing: props.value,
	});

	useEffect(() => {
		if (props.value)
			setViewing(props.value);
	}, [props.value, setViewing]);

	const today = new Date();
	return (
		<div className={"w-68"}>
			{ calendar.map(m =>
				<div>
					<div className={"flex justify-between"}>
						<button onClick={() => viewPreviousMonth()}>
							<ChevronLeft/>
						</button>
						{ monthName[viewing.getMonth()] }
						<button onClick={() => viewNextMonth()}>
							<ChevronRight/>
						</button>
					</div>
					{ m.map(w =>
						<div className={"flex gap-2"}>
							{ w.map(d =>
								<p
									className={clsx(
										"w-8 h-8 flex justify-center items-center cursor-pointer",
										sameDay(d, today) && "border-2 border-blue rounded-full",
										sameDay(d, props.value) && "border-2 border-green rounded-full",
									)}
									onClick={() => {
										if (props.setValue !== undefined) {
											const time = props.value ?? new Date();
											const tmp = new Date(d);
											tmp.setHours(time.getHours());
											tmp.setMinutes(time.getMinutes());
											tmp.setSeconds(time.getSeconds());
											props.setValue(tmp);
										}
									}}
								>
									{ d.getDate() }
								</p>) }
						</div>) }
					{ props.time === true &&
						<div className={"flex justify-center"}>
							<input
								className={"bg-transparent text-center w-6 focus:outline-none"}
								value={props.value?.getHours()}
								onInput={(e) => {
									if (validHour(trim0Start(e.currentTarget.value)) && props.setValue !== undefined)
										props.setValue((prev) => {
											if (prev) {
												const tmp = new Date(prev);
												if (e.currentTarget.value === "")
													tmp.setHours(0);
												else
													tmp.setHours(parseInt(e.currentTarget.value));
												return tmp;
											} else
												return prev;
										});
								}}
							/>
							:
							<input
								className={"bg-transparent text-center w-6 focus:outline-none"}
								value={formatDateTimeComponent(props.value?.getMinutes())}
								onInput={(e) => {
									if (validMinSec(trim0Start(e.currentTarget.value)) && props.setValue)
										props.setValue((prev) => {
											if (prev === undefined)
												return undefined;

											const tmp = new Date(prev);
											if (e.currentTarget.value === "")
												tmp.setMinutes(0);
											 else
												tmp.setMinutes(parseInt(e.currentTarget.value));
											return tmp;
										});
								}}
							/>
							{ props.seconds === true &&
								<>
									:
									<input
										className={"bg-transparent text-center w-6 focus:outline-none"}
										value={formatDateTimeComponent(props.value?.getSeconds())}
										onInput={(e) => {
											if (validMinSec(trim0Start(e.currentTarget.value)) && props.setValue)
												props.setValue((prev) => {
													if (prev === undefined)
														return prev;
													const tmp = new Date(prev);
													if (e.currentTarget.value === "")
														tmp.setSeconds(0);
													else
														tmp.setSeconds(parseInt(e.currentTarget.value));
													return tmp;
												});
										}}
									/>
								</> }
						</div> }
				</div>) }
		</div>
	);
}

const monthName = [
	"Janvier",
	"Février",
	"Mars",
	"Avril",
	"Mai",
	"Juin",
	"Juillet",
	"Aout",
	"Septembre",
	"Octobre",
	"Novembre",
	"Décembre",
];

function sameDay(a: Date, b: Date | undefined) {
	return b !== undefined && a.getFullYear() === b.getFullYear() &&
		a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
}

export function formatDateTimeComponent(value: number | undefined): string {
	if (value === undefined)
		return "";
	if (value >= 10)
		return value.toString();
	else
		return `0${value}`;
}

function max2Digit(value: string): boolean {
	return value.length <= 2 && (!isNaN(parseInt(value)) || value === "");
}

function validHour(value: string): boolean {
	return max2Digit(value) && (parseInt(value) < 24 || value === "");
}

function validMinSec(value: string): boolean {
	return max2Digit(value) && (parseInt(value) < 60 || value === "");
}

function trim0Start(s: string) {
	while (s.charAt(0) === "0")
		s = s.substring(1);
	return s;
}
