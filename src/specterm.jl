using TextUserInterfaces
using TextUserInterfaces.NCurses

mutable struct Object
    x::Int
    y::Int
    width::Int
    height::Int
    content::String
end

function render_object(obj)
    mvprintw(obj.x, obj.y, obj.content)
end

#function create_border(init_y::Int, init_y::Int, height::Int, width::Int)
#end

function create_person(init_y::Int, init_x::Int)
    person = Object(init_y, init_x, 1, 1, "S")
    return person
end

function init()
    init_tui()
    bg = initscr()
    start_color()
    #use_default_colors()

    COLORS = [COLOR_BLACK, COLOR_CYAN, COLOR_MAGENTA, COLOR_RED, COLOR_YELLOW,
              COLOR_BLUE, COLOR_GREEN, COLOR_WHITE]

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

function main()
    bg = init()
    curs_set(0)

    person = create_person(1,1)
    render_object(person)

    mvwprintw(bg, 21, 20, "yo")
    refresh()

    # Eventually, we need some sort of FPS counter, this will work for now.
    key = jlgetch()
    while key.value != "q"
        if key.value == "w"
            person.x -= 1
        elseif key.value == "a"
            person.y -= 1
        elseif key.value == "s"
            person.x += 1
        elseif key.value == "d"
            person.y += 1
        end

        erase()
        mvprintw(10,10,string(person.x))
        mvprintw(10,20,string(person.y))
        render_object(person)

        refresh()

        key = jlgetch()
        process_focus(key)
    end

    kill_curses(bg)
end
main()
