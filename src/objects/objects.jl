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
