import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";
import Network from "gi://AstalNetwork";
import { Accessor, For, With } from "gnim";

export default function Wifi() {
	const network = Network.get_default();

	const wifiState = createPoll({ enabled: false, state: 0 }, 500, () => ({
		enabled: network.wifi.enabled,
		state: network.wifi.state
	}));

	const accessPoints = createPoll([], 2000, () => network.wifi.accessPoints);


	function getWifiLogo(enabled: boolean, state: number): string {
		if (state !== Network.DeviceState.ACTIVATED) return "󰤮"

		if (!enabled) return "󰖪"

		return ""
	}

	function getWifiClass(enabled: boolean, state: number): string {
		if (state !== Network.DeviceState.ACTIVATED) return "disactivated"

		if (!enabled) return "disabled"

		return "activated"
	}

	function isSecured(ap: Network.AccessPoint): boolean {
		return ap.flags !== 0 || ap.wpaFlags !== 0 || ap.rsnFlags !== 0;
	}

	return (
		<menubutton class="wifi">
			<With value={wifiState}>
				{(w) => (
					<label
						class={`wifi-logo ${getWifiClass(w.enabled, w.state)}`}
						label={getWifiLogo(w.enabled, w.state)}
					/>
				)}
			</With>
			<popover class="popover" hasArrow={false}>
				<box orientation={Gtk.Orientation.VERTICAL} vexpand>
					<box class="toggle-wrapper" valign={Gtk.Align.START} vexpand hexpand>
						<label label="Wifi" hexpand halign={Gtk.Align.START} />
						<With value={wifiState}>
							{(w) => (
								<switch
									class="switch"
									hexpand
									halign={Gtk.Align.END}
									active={w.enabled}
									onNotifyActive={(self) => {
										network.wifi.enabled = self.active;
									}}
								/>
							)}
						</With>
					</box>

					<box class="list-wrapper" valign={Gtk.Align.END} hexpand orientation={Gtk.Orientation.VERTICAL}>
						<For each={accessPoints}>
							{(ap) => {
								return (
									<box class="network" hexpand>
										{ap.ssid === network.wifi.activeAccessPoint?.ssid ? (
											<label widthChars={2} xalign={0.5} class="icon active" label="󰄬" />
										) : (
											<label widthChars={2} xalign={0.5} class="icon" label=""
											/>
										)}
										<box hexpand>
											<label class="ssid" label={ap.ssid} />
										</box>
										{isSecured(ap) && (
											<label widthChars={2} xalign={0.5} class="icon" label="󰌾" />
										)}
									</box>
								)
							}}
						</For>
					</box>
				</box>
			</popover>
		</menubutton>
	);
}
