import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { execAsync } from "ags/process"
import { createPoll } from "ags/time"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

	const battery = createPoll("", 5000, "cat /sys/class/power_supply/macsmc-battery/capacity")
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
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox cssName="centerbox">
        <button
					cssName="btn-1"
          $type="start"
          onClicked={() => execAsync("echo hello").then(console.log)}
          hexpand
          halign={Gtk.Align.START}
        >
          <label label="Hello" />
        </button>

        <box $type="center" />

				<box cssName="left" $type="end" hexpand halign={Gtk.Align.END}>
				<label label={battery.as(b => `${b.trim()}%`)} />
        <menubutton cssName="btn-2" $type="end" hexpand halign={Gtk.Align.END}>
          <label label={time} />
          <popover>
            <Gtk.Calendar />
          </popover>
        </menubutton>
				</box>
      </centerbox>
    </window>
  )
}
