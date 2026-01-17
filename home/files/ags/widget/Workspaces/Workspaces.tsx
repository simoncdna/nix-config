import { exec, subprocess } from "ags/process"
import { Accessor, createState, For } from "gnim"

interface SwayWorkspace {
	num: number
	name: string
	focused: boolean
	visible: boolean
}

export default function Workspaces() {
	const [workspaces, setWorkspaces] = createState<SwayWorkspace[]>([])

	const refresh = () => {
		const result = exec("swaymsg -t get_workspaces")
		setWorkspaces(JSON.parse(result))
	}

	subprocess(
		["swaymsg", "-t", "subscribe", "-m", '["workspace"]'],
		() => refresh()
	)

	refresh()

	return (
		<box class="workspaces">
			<For each={workspaces}>
				{(ws) => (
					<label
						class={ws.focused ? "focus" : "unfocus"}
						label={ws.focused ? "" : ""}
					/>
				)}
			</For>
		</box>
	)
}
