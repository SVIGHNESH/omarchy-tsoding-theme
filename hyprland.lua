-- i3 defaults: client.focused child_border #285577, client.unfocused #222222.
local active_border_color = "rgb(285577)"
local inactive_border_color = "rgb(222222)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
      border_locked_active = active_border_color,
      border_locked_inactive = inactive_border_color,
    },
  },
})
