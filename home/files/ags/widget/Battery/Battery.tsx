import { createPoll } from "ags/time";
import { Accessor } from "gnim";

export default function Battery() {
	const battery = createPoll("", 5000, "cat /sys/class/power_supply/macsmc-battery/capacity")

	 function getBatteryLogo(battery: string): string {
      const level = parseInt(battery)

      if (level > 80) return "󱊣"
      if (level > 50) return "󱊢"
			if (level > 20) return "󱊡"
      return "󰂎"
		}

	return (
		<box class="battery">
			<label class="battery-logo" label={battery.as(b => getBatteryLogo(b))} />
			<label label={battery.as(b => `${b.trim()}%`)} />
		</box>
	);
}
