module Dialogue
    struct DialogueBox
        box::Object
        text_speed::Float
    end

    # called automatically when terminal is resized
    redraw_dialogue(box::DialogueBox)
    end

    # called with a string to write
    # this also parses the text so it fits in the box and prompts user to press
    # buttons when necessary
    write_dialogue(box::DialogueBox, text::String)
    end

    clear_dialogue(box::DialogueBox)
    end

end
