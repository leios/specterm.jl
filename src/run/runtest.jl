using TextUserInterfaces
using TextUserInterfaces.NCurses

using SpecTerm

function main()
    bg = init()
    curs_set(0)

    objects = Vector{Object}()

    border = create_rectangle(20,0,4,80)
    person = create_person(1,1)

    ball = Object(25,25,1,1,"o")

    push!(objects, person)
    push!(objects, border)
    push!(objects, ball)
    render_objects(objects)

    refresh()

    # Eventually, we need some sort of FPS counter, this will work for now.
    key = jlgetch()
    play = true
    step = 1
    while (play)
        if key.value == "w"
            person.y -= 1
        elseif key.value == "a"
            person.x -= 1
        elseif key.value == "s"
            person.y += 1
        elseif key.value == "d"
            person.x += 1
        elseif key.value == "q"
            play = false
        end

        sleep(0.01)

        if (step%2 == 0)
            ball.content = "o"
        else
            ball.content = "O"
        end

        erase()
        render_objects(objects)
        refresh()

        key = jlgetch()
        process_focus(key)
        step += 1
    end

    kill_curses(bg)
end
