import { exec } from "ags/process";
import { createPoll } from "ags/time";
import { Accessor, With } from "gnim";

export default function Battery() {
	const battery = createPoll({ capacity: 0, isCharging: false }, 500, () => {
		const capacity = parseInt(exec("cat /sys/class/power_supply/macsmc-battery/capacity"));
		const isCharging = exec("cat /sys/class/power_supply/macsmc-battery/status") === "Charging";

		return { capacity, isCharging }
	});

	function getBatteryLogo(level: number, isCharging: boolean): string {
		if (isCharging) return "󰂄"
		if (level > 80) return "󱊣"
		if (level > 50) return "󱊢"
		if (level > 20) return "󱊡"
		return "󰂎"
	}

	function getBatteryClass(level: number, isCharging: boolean): string {
		if (isCharging) return "charging"
		if (level > 80) return "high"
		if (level > 50) return "medium"
		if (level > 20) return "low"
		return "critical"
	}

	return (
		<box>
			<With value={battery}>
				{(b) => {
					return (
						<box class="battery">
							<label class={`battery-logo ${getBatteryClass(b.capacity, b.isCharging)}`} label={getBatteryLogo(b.capacity, b.isCharging)} />
							<label label={`${b.capacity}%`} />
						</box>
					)
				}}
			</With>
		</box>
	);
}
