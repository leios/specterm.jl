function init()
    init_tui()
    bg = initscr()
    nodelay(bg, true)
    start_color()
    #use_default_colors()

    COLORS = [COLOR_BLACK, COLOR_CYAN, COLOR_MAGENTA, COLOR_RED,
              COLOR_YELLOW, COLOR_BLUE, COLOR_GREEN, COLOR_WHITE]

    for i in COLORS
        init_pair(i,i,-1)
    end

    noecho()
    #bg.keypad(1)
    return bg
end

function kill_curses(bg)
    #nocbreak()
    #bg.keypad(0)
    #echo(0)
    destroy_tui()
end
