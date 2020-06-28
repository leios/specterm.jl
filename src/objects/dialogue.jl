using SpecTerm

mutable struct DialogueBox <: Object
    y::Int
    x::Int
    height::Int
    width::Int
    content::Union{Any, Vector{Any}}
end

# This depends on each Shape having a similar constructor
# Generalizing this to *any* object, made it so any time we pushed onto an 
# array of Objects, it would try to type convert subtypes into Object (which
# has no constructor)
function Base.convert(::Type{DialogueBox}, Src::Shape)
    DialogueBox(Src.y, Src.x, Src.height, Src.width, Src.content)
end

function create_dialogue(win; fullscreen = false)

    if fullscreen
        max_x = Int(getmaxx(win))
        max_y = Int(getmaxy(win))

        mvprintw(10,10,string(max_x))
        mvprintw(10,20,string(max_y))

        container = create_rectangle(max_y-4, 0, 4, max_x)
        return convert(DialogueBox, container)
    else
        container = convert(DialogueBox, create_rectangle(20, 0, 4, 80))
    end
end

# TODO: called automatically when terminal is resized
function redraw_dialogue(box::DialogueBox)
end

# called with a string to write
function write_dialogue(box::DialogueBox, text::String)

    # gets vector of lines to write
    text_array = parse_dialogue(box, text)

    # prints characters 1-by-one
    for j = 1:length(text_array)
        interior_y = (j-1)%(box.height-2)+1
        # wait for keypress after N lines of printing to clear box
        if interior_y == 1
            clear_dialogue(box)
            #key = jlgetch()
        end
        for i = 1:length(text_array[j])
            character_array = collect(box.content[interior_y+1])
            character_array[i+1] = text_array[j][i]
            box.content[interior_y+1] = join(character_array)
        end
    end

end

# clears dialogue box for more printing (after keypress)
function clear_dialogue(box::DialogueBox)
    for j = 1:box.height-2
        character_array = collect(box.content[j+1])
        for i = 1:box.width-2
            character_array[i+1] = ' ' 
        end
        box.content[j+1] = join(character_array)
    end
end

# this also parses the text so it fits in the box and prompts user to press
# buttons when necessary. 
function parse_dialogue(box::DialogueBox, text::String)
    allowed_width = box.width - 4
    if length(text) > allowed_width
        text_array = Vector{String}()
        element_num = 1
        last_val = 1

        # This searches for newline comments and tabs, but otherwise parses
        # the string every ~allowed_width
        element_num
        while element_num < length(text)
            if text[element_num] == "\n"
                push!(text_array,text[last_val:element_num])
                last_val = element_num

            # cast tabs to spaces because no one cares
            elseif text[element_num] == "\t"
                text[element_num] = " "

            elseif element_num-last_val > allowed_width

                # returns a 1-value range, so we need take the first number
                last_space = findprev(" ",text,element_num)
                push!(text_array,text[last_val:last_space[1]])
                last_val = last_space[1]+1
                element_num = last_space[1]+1
            end
            element_num += 1
        end

        push!(text_array,text[last_val:end])
    
    else
        return [text]
    end
end
