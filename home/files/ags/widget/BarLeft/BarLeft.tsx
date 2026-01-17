import { Gtk } from "ags/gtk4";
import DesktopIcon from "../DesktopIcon/DesktopIcon";
import Workspaces from "../Workspaces/Workspaces";

export default function BarLeft() {
	return (
		<box cssName="left" $type="start" hexpand halign={Gtk.Align.START}>
			<DesktopIcon />
			<Workspaces />
		</box>
	);
}
