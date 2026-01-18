import { Gtk } from "ags/gtk4";
import { exec } from "ags/process";

export default function PowerMenu() {
	return (
		<menubutton class="power-menu-wrapper">
			<label class="power-menu-icon" label="⏻" />
			<popover hasArrow={false} class="power-menu">
				<box orientation={Gtk.Orientation.VERTICAL}>
					<button onClicked={() => exec("loginctl lock-session")}>
						<box class="option">
							<label widthChars={2} xalign={0.5} class="lock icon" label="󰌾" />
							<label label="Lock" />
						</box>
					</button>
					<button onClicked={() => exec("systemctl suspend")}>
						<box class="option">
							<label widthChars={2} xalign={0.5} class="sleep icon" label="󰤄" />
							<label label="Sleep" />
						</box>
					</button>
					<button onClicked={() => exec("systemctl reboot")}>
						<box class="option">
							<label widthChars={2} xalign={0.5} class="reboot icon" label="󰜉" />
							<label label="Reboot" />
						</box>
					</button>
					<button onClicked={() => exec("systemctl poweroff")}>
						<box class="option">
							<label widthChars={2} xalign={0.5} class="shutdown icon" label="󰐥" />
							<label label="Shutdown" />
						</box>
					</button>
				</box>
			</popover>
		</menubutton>
	);
}
