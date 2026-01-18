import { Gtk } from "ags/gtk4";
import Battery from "../Battery/Battery";
import { createPoll } from "ags/time";
import Wifi from "../Wifi/Wifi";
import PowerMenu from "../PowerMenu/PowerMenu";

export default function BarRight() {
	const time = createPoll("", 1000, () => {
    return new Date().toLocaleTimeString("en-US", {
      hour: "2-digit",
      minute: "2-digit",
      timeZone: "Europe/Paris"
    })
  })

	return (
		<box cssName="right" $type="end" hexpand halign={Gtk.Align.END}>
			<Wifi />
			<Battery />
			<menubutton cssName="btn-2">
				<label label={time} />
				<popover hasArrow={false}>
					<Gtk.Calendar />
				</popover>
			</menubutton>
			<PowerMenu />
		</box>
	);
}
