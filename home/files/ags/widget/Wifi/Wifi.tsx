import Network from "gi://AstalNetwork";
import { Accessor, createBinding } from "gnim";

export default function Wifi() {
	const network = Network.get_default();

	const enabled = createBinding(network, "wifi", "enabled");
	const state = createBinding(network, "wifi", "state");

	function getWifiLogo(enabled: boolean, state: number): string {
		if (!enabled) return "󰖪"

		if (state !== Network.DeviceState.ACTIVATED) return "󰤮"

		return ""
	}

	function getWifiClass(enabled: boolean, state: number): string {
		if (!enabled) return "disabled"

		if (state !== Network.DeviceState.ACTIVATED) return "disactivated"

		return "activated"
	}

	return (
		<box>
			<label 
				class={`wifi-logo ${enabled.as(e => getWifiClass(e, state.get()))}`} 
				label={enabled.as(e => getWifiLogo(e, state.get()))}
			/>
		</box>

	);
}
