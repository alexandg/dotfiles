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
	own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',
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
	gap_x = 15,
	alignment = 'top_right',
	gap_y = 4,
	no_buffers = true,
	cpu_avg_samples = 2,
	override_utf8_locale = true,
	text_buffer_size = 1024,
	uppercase = true,
	border_inner_margin = 10,
};

conky.text = [[
${font Inconsolata:size=10}TIME ${hr 1}

${font Inconsolata:size=18}${time %d/%m/%Y}${alignr}${time %H:%M}
${font Inconsolata:size=10}NETWORK ${hr 1}

Public IP: ${alignr}${execi 900 wget -q -o /dev/null -O - http://ipinfo.io/ip}
Local IP: ${if_up wlp3s0}${alignr}${addr wlp3s0}${else}${alignr}${addr enp0s25}${endif}

${if_up wlp3s0}Wireless: ${alignr}${wireless_essid wlp3s0}  ${wireless_link_qual wlp3s0}%${else}Wireless: ${alignr}N/A${endif}

Down ${if_up wlp3s0}${downspeed wlp3s0}${else}${downspeed enp0s25}${endif}/s${alignr}${if_up wlp3s0}${totaldown wlp3s0}${else}${totaldown enp0s25}${endif}
${if_up wlp3s0}${downspeedgraph wlp3s0 25,245}${else}${downspeedgraph enp0s25 25,245}${endif} ${alignr} 

Up ${if_up wlp3s0}${upspeed wlp3s0}${else}${upspeed enp0s25}${endif}/s${alignr}${if_up wlp3s0}${totalup wlp3s0}${else}${totalup enp0s25}${endif}
${if_up wlp3s0}${upspeedgraph wlp3s0 25,245}${else}${upspeedgraph enp0s25 25,245}${endif}

WEATHER ${hr 1}

${execi 1800 ~/bin/weather.py}

${font Inconsolata:size=10}CALENDAR ${hr 1}

${execpi 600 ncal -bh | sed s/^/'${alignc}'/}

PORTS ${hr 1}

${execi 60 netstat -tuln | awk 'NR > 2 { print $1, "\t", $4, "\t", $6 }' | head -n 15}
]];
