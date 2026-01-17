import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"
import BarRight from "./BarRight/BarRight"
import BarLeft from "./BarLeft/BarLeft"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

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
				<BarLeft />
        <box $type="center" />
				<BarRight />
      </centerbox>
    </window>
  )
}
