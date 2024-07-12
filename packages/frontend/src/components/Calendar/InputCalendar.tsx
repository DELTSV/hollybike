import {
	Calendar, CalendarProps, formatDateTimeComponent,
} from "./Calendar.tsx";
import { Input } from "../Input/Input.tsx";
import {
	useCallback,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { CalendarTodayRounded } from "@material-ui/icons";
import { Card } from "../Card/Card.tsx";
import {
	decInputCount, inputCount,
} from "../InputCount.ts";
import { useRef } from "react";

export function InputCalendar(props: CalendarProps) {
	const [textValue, setTextValue] = useState(dateToFrenchString(props.value));

	const [view, setView] = useState(false);

	useEffect(() => {
		if (props.time) {
			const str = `${dateToFrenchString(props.value)} ${timeToFrenchString(props.value, props.seconds === true)}`;
			if (str === " ") {
				setTextValue("");
			} else {
				setTextValue(str);
			}
		} else {
			setTextValue(dateToFrenchString(props.value));
		}
	}, [
		props.value,
		props.time,
		props.seconds,
		setTextValue,
	]);

	useEffect(() => {
		const date = frenchStringToDate(textValue, props.time === true, props.seconds === true);
		if (date !== null && props.setValue) {
			props.setValue(date);
		}
	}, [
		textValue,
		props.time,
		props.seconds,
	]);

	const id = useMemo(() => {
		const id = inputCount;
		decInputCount();
		return id;
	}, []);

	const container = useRef<HTMLDivElement>(null);

	const handleOut = useCallback((e: MouseEvent) => {
		if (
			container.current &&
			!container.current.contains(e.target as Node)
		) {
			setView(false);
		}
	}, [container, setView]);

	useEffect(() => {
		document.addEventListener("mousedown", handleOut);
		return () => {
			document.removeEventListener("mousedown", handleOut);
		};
	}, [handleOut]);

	return (
		<div className={"relative"} style={`z-index: ${id}`} ref={container}>
			<Input
				value={textValue}
				onInput={e => setTextValue(e.currentTarget.value)}
				rightIcon={<CalendarTodayRounded onClick={() => setView(prev => !prev)} />}
			/>
			{ view &&
                <Card className={"absolute"}>
                	<Calendar {...props} />
                </Card> }
		</div>
	);
}

export function dateTimeToFrenchString(date: Date | undefined, seconds: boolean) {
	return `${dateToFrenchString(date)} ${timeToFrenchString(date, seconds)}`;
}

export function dateToFrenchString(date: Date | undefined): string {
	if (date === undefined) {
		return "";
	}
	return `${formatDateTimeComponent(date.getDate())}/${formatDateTimeComponent(date.getMonth() + 1)}` +
		`/${date.getFullYear()}`;
}

export function timeToFrenchString(date: Date | undefined, seconds: boolean): string {
	if (date === undefined) {
		return "";
	}
	if (seconds) {
		return `${formatDateTimeComponent(date.getHours())}:${formatDateTimeComponent(date.getMinutes())}:` +
			`${formatDateTimeComponent(date.getSeconds())}`;
	} else {
		return `${formatDateTimeComponent(date.getHours())}:${formatDateTimeComponent(date.getMinutes())}`;
	}
}

function frenchStringToDate(s: string, time: boolean, seconds: boolean): Date | null {
	const dateAndTime = s.split(" ");
	if (time && dateAndTime.length !== 2) {
		return null;
	} else if (!time && dateAndTime.length !== 1) {
		return null;
	}
	const els = dateAndTime[0].split("/");
	if (els.length !== 3) {
		return null;
	}
	if (els.find(el => el.length < 2 || isNaN(parseInt(el))) !== undefined) {
		return null;
	}
	const d = new Date();
	d.setDate(parseInt(els[0]));
	d.setMonth(parseInt(els[1]) - 1);
	d.setFullYear(parseInt(els[2]));
	if (time) {
		const tEls = dateAndTime[1].split(":");
		if (seconds && tEls.length !== 3) {
			return null;
		} else if (!seconds && tEls.length !== 2) {
			return null;
		}
		if (tEls.find(el => isNaN(parseInt(el))) !== undefined) {
			return null;
		}
		d.setHours(parseInt(tEls[0]));
		d.setMinutes(parseInt(tEls[1]));
		if (seconds) {
			d.setSeconds(parseInt(tEls[2]));
		} else {
			d.setSeconds(0);
		}
	}
	return d;
}

