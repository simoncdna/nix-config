import { Gtk } from "ags/gtk4";
import Battery from "../Battery/Battery";
import { createPoll } from "ags/time";

export default function BarRight() {
	const time = createPoll("", 1000, () => {
    return new Date().toLocaleTimeString("en-US", {
			weekday: "long",
			day: "numeric",
			month: "short",
      hour: "2-digit",
      minute: "2-digit",
      timeZone: "Europe/Paris"
    })
  })

	return (
		<box cssName="right" $type="end" hexpand halign={Gtk.Align.END}>
			<Battery />
			<menubutton cssName="btn-2" $type="end" hexpand halign={Gtk.Align.END}>
				<label label={time} />
				<popover>
					<Gtk.Calendar />
				</popover>
			</menubutton>
		</box>
	);
}
