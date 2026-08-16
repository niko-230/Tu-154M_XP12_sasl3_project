-- draws texture independed of cockpit lighting system

-- no default texture
defineProperty("image")
--defineProperty("position")
defineProperty("alpha")
defineProperty("x")
defineProperty("y")
defineProperty("w")
defineProperty("h")



function draw(self) 
    drawTexture(get(image), get(x), get(y), get(w) , get(h), {1, 1, 1,get(alpha)}) 
end
