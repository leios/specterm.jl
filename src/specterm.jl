using TextUserInterfaces
using TextUserInterfaces.NCurses

mutable struct Object
    y::Int
    x::Int
    height::Int
    width::Int
    content::Union{Any, Vector{Any}}
end

function render_object(obj)
    if typeof(obj.content)==String
        mvprintw(obj.y, obj.x, obj.content)
    elseif typeof(obj.content)==Vector{String}
        for i = 1:obj.height
            mvprintw(obj.y+i, obj.x, obj.content[i])
        end
    end
end

function render_objects(objects::Vector{Object})
    for obj in objects
        render_object(obj)
    end
end

function create_rectangle(init_y::Int, init_x::Int, height::Int, width::Int;
                          filltype = "border")
    rectangle_content = Vector{String}()
    left = []
    right = []
    center = []
    if filltype == "border"
        left = ["┌", "│",  "└"]
        right = ["┐", "│",  "┘"]
        center = ["─", " ",  "─"]
    end

    # index for character types in set of left, right, and center
    ci = 1
    for j = 1:height
        if (j == 2)
            ci = 2
        elseif (j == height)
            ci = 3
        end
        
        push!(rectangle_content,left[ci]*lpad("", width-2,center[ci])*right[ci])
    end

    return Object(init_y, init_x, height, width, rectangle_content)
end

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

    objects = Vector{Object}()

    border = create_rectangle(20,0,4,80)
    person = create_person(1,1)

    push!(objects, person)
    push!(objects, border)
    render_objects(objects)

    refresh()

    # Eventually, we need some sort of FPS counter, this will work for now.
    key = jlgetch()
    while key.value != "q"
        if key.value == "w"
            person.y -= 1
        elseif key.value == "a"
            person.x -= 1
        elseif key.value == "s"
            person.y += 1
        elseif key.value == "d"
            person.x += 1
        end

        erase()
        mvprintw(10,10,string(person.x))
        mvprintw(10,20,string(person.y))
        render_objects(objects)

        refresh()

        key = jlgetch()
        process_focus(key)
    end

    kill_curses(bg)
end
main()
