-- Stock i3 look, loaded after ~/.config/hypr/looknfeel.lua so it has the last word.

hl.config({
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 2,
  },

  decoration = {
    rounding = 0,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,
    dim_inactive = false,
    shadow = { enabled = false },
    blur = { enabled = false },
  },

  animations = {
    enabled = false,
  },

  -- i3 title bars: every window is its own group, and the groupbar is the title.
  group = {
    auto_group = false,

    groupbar = {
      enabled = true,
      render_titles = true,
      font_family = "Iosevka",
      font_size = 13,
      font_weight_active = "normal",
      font_weight_inactive = "normal",
      height = 19,
      indicator_height = 0,
      indicator_gap = 0,
      gaps_in = 0,
      gaps_out = 0,
      keep_upper_gap = false,
      rounding = 0,
      gradients = true,
      gradient_rounding = 0,
      text_color = "rgb(ffffff)",
      text_color_inactive = "rgb(888888)",
      text_color_locked_active = "rgb(ffffff)",
      text_color_locked_inactive = "rgb(888888)",
      col = {
        active = "rgb(285577)",
        inactive = "rgb(222222)",
        locked_active = "rgb(285577)",
        locked_inactive = "rgb(222222)",
      },
    },
  },
})

o.window(".*", { group = "set always" })
o.window(".*", { opacity = "1 1" })

-- hide_edge_borders both: a window alone on its workspace has no border.
o.window({ float = false, workspace = "w[tv1]" }, { border_size = 0 })
o.window({ float = false, workspace = "f[1]" }, { border_size = 0 })
