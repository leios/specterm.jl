using TextUserInterfaces
using TextUserInterfaces.NCurses

function main()
    init_tui()
    noecho()
    curs_set(0)

    # set of all windows
    wins = Window[]

    t = 0
    l = 0

    # background window and container
    bg_win,bg_container = create_window_with_container(newopc(top = 0,
                                                              left = 0,
                                                              height = 24,
                                                              width = 80),
                                                       border = true,
                                                       title = "")

    # creating a person that moves around
    person = create_window(newopc(top = t, left = l, height = 1, width = 1),
                           border=true, title="S")

    push!(wins, bg_win)
    push!(wins, person)

    #refresh_all_windows()
    update_panels()
    doupdate()

    # while jlgetch is looking for a "q" keypress, we constantly refresh window
    key = jlgetch()
    while key.value != "q"
        process_focus(key)
        key = jlgetch()

        if key.value == "w"
            t -= 1
        elseif key.value == "a"
            l -= 1
        elseif key.value == "s"
            t += 1
        elseif key.value == "d"
            l += 1
        end

        move_window(person,t,l)

        #refresh_all_windows()
        update_panels()
        doupdate()
    end
    destroy_tui()

end

main()
