/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	CheckBoxOutlineBlank,
	CheckBoxOutlined,
} from "@material-ui/icons";

interface CheckBoxProps {
	checked?: boolean
	toggle?: () => void
}

export function CheckBox(props: CheckBoxProps) {
	return (
		<div className={"cursor-pointer"} onClick={props.toggle}>
			{ props.checked === true ?
				<CheckBoxOutlined/>:
				<CheckBoxOutlineBlank/> }
			<input type={"checkbox"} className={"hidden"} checked={props.checked}/>
		</div>
	);
}
