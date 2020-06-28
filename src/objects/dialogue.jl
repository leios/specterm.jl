using SpecTerm

struct DialogueBox
    container::Object
    text_speed::Float64
end

# TODO: called automatically when terminal is resized
function redraw_dialogue(box::DialogueBox)
end

# called with a string to write
function write_dialogue(box::DialogueBox, text::String)

    # gets vector of lines to write
    text_array = parse_dialogue(box, text)

    # prints characters 1-by-one
    for line in text_array
        for i in 1:length(line)
            interior_y = j%(box.container.height-2)

            # wait for keypress after N lines of printing to clear box
            if interior_y == 0
                key = jlgetch()
            end
            mvprintw(interior_y+box.container.y+2,
                     box.container.x+1+i,
                     line[i])
        end
    end

end

# clears dialogue box for more printing (after keypress)
function clear_dialogue(box::DialogueBox)
end

# this also parses the text so it fits in the box and prompts user to press
# buttons when necessary. 
function parse_dialogue(box::DialogueBox, text::String)
    allowed_width = box.container.width - 2
    if length(text) > allowed_width
        text_array = Vector{String}()
        element_num = 1
        last_val = 1

        # This searches for newline comments and tabs, but otherwise parses
        # the string every ~allowed_width
        for i = 1:length(text)
            if text[i] == "\n"
                push!(text_array,text[last_val:element_num])
                last_val = element_num

            # cast tabs to spaces because no one cares
            elseif text[i] == "\t"
                text[i] = " "

            elseif element_num-last_val > allowed_width

                # returns a 1-value range, so we need take the first number
                last_space = findprev(" ",text,element_num)
                push!(text_array[last_val:last_space[1]])
                element_num = last_space[1]
            else
                error("parsing of text has failed at element_num: ",
                      element_num)
            end
        end

        push!(text_array,text[last_val:end])
    
    else
        return [text]
    end
end
