-- vim: ts=4 sw=4 noet ai cindent syntax=lua
--theme_color = '#DCDCCC' -- 'is the color for zenburn when using a dark background'
--theme_color = '#FDF6E3' -- 'is color for solarized dark'
theme_color = '#BCBCBC' -- 'for Apprentice

conky.config = {
	background = true,
	use_xft = true,
	xftalpha = 0.9,
	update_interval = 3.0,
	total_run_times = 0,
    own_window = true,
	own_window_type = 'override',
	own_window_transparent = true,
	own_window_hints = 'below,undecorated,sticky,skip_taskbar,skip_pager',
	double_buffer = true,
	minimum_width = 250, minimum_height = 850,
	maximum_width = 250,
	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = true,
	default_color = theme_color,
	default_shade_color = 'black',
	default_outline_color = 'green',
	gap_x = 40,
	alignment = 'top_left',
	gap_y = 4,
	no_buffers = true,
	cpu_avg_samples = 2,
	override_utf8_locale = false,
	uppercase = true,
	border_inner_margin = 10,
};

conky.text = [[
${font Inconsolata:size=10}SYSTEM ${hr}

Hostname: ${alignr}${nodename}
Kernel: ${alignr}${kernel}
Uptime: ${alignr}${uptime}
Battery Front: ${alignr}${battery_short BAT0} ${battery_time BAT0}
Battery Rear: ${alignr}${if_existing /sys/class/power_supply/BAT1/status}${battery_short BAT1} ${battery_time BAT1}${else}Unplugged${endif}

PROCESSORS ${hr 1}

CPU1: ${alignr}${hwmon temp 1}C  ${freq 1} MHz   ${cpu cpu1}%
${cpugraph cpu1 25,245}
CPU2: ${alignr}${hwmon temp 1}C  ${freq 2} MHz   ${cpu cpu2}%
${cpugraph cpu2 25,245}
CPU3: ${alignr}${hwmon temp 1}C  ${freq 1} MHz   ${cpu cpu3}%
${cpugraph cpu3 25,245}
CPU4: ${alignr}${hwmon temp 1}C  ${freq 2} MHz   ${cpu cpu4}%
${cpugraph cpu4 25,245}

MEMORY ${hr 1}

Ram ${alignr}$mem / $memmax ($memperc%)
${memgraph 25,245}
swap ${alignr}$swap / $swapmax ($swapperc%)
${swapbar 4}

Processes ${hr 1}

Highest CPU $alignr CPU%  MEM-RES
${top name 1}$alignr${top cpu 1}  ${top mem_res 1}
${top name 2}$alignr${top cpu 2}  ${top mem_res 2}
${top name 3}$alignr${top cpu 3}  ${top mem_res 3}
${top name 4}$alignr${top cpu 4}  ${top mem_res 4}
${top name 5}$alignr${top cpu 5}  ${top mem_res 5}

Highest MEM $alignr CPU%  MEM-RES
${top_mem name 1}$alignr${top_mem cpu 1}  ${top_mem mem_res 1}
${top_mem name 2}$alignr${top_mem cpu 2}  ${top_mem mem_res 2}
${top_mem name 3}$alignr${top_mem cpu 3}  ${top_mem mem_res 3}
${top_mem name 4}$alignr${top_mem cpu 4}  ${top_mem mem_res 4}
${top_mem name 5}$alignr${top_mem cpu 5}  ${top_mem mem_res 5}

Filesystems ${hr 1}

Root: ${alignr}${fs_free /} / ${fs_size /}
${fs_bar 4 /}
Var: ${alignr}${fs_free /var} / ${fs_size /var}
${fs_bar 4 /var}
Home: ${alignr}${fs_free /home} / ${fs_size /home}
${fs_bar 4 /home}
]];
