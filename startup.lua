local files = {
  mine = {
    file = "mine.lua",
    url = "https://raw.githubusercontent.com/cquinones100/minecraft-turtle/main/mine.lua",
  },

  stairs = {
    file = "stairs.lua",
    url = "https://raw.githubusercontent.com/cquinones100/minecraft-turtle/main/stairs.lua",
  },

  coordinatedTurtle = {
    file = "coordinated_turtle.lua",
    url = "https://raw.githubusercontent.com/cquinones100/minecraft-turtle/main/coordinated_turtle.lua",
  },

  fueledTurtle = {
    file = "fueled_turtle.lua",
    url = "https://raw.githubusercontent.com/cquinones100/minecraft-turtle/main/fueled_turtle.lua",
  },

  inventoriedTurtle = {
    file = "inventoried_turtle.lua",
    url = "https://raw.githubusercontent.com/cquinones100/minecraft-turtle/main/inventoried_turtle.lua",
  },

  miningTurtle = {
    file = "mining_turtle.lua",
    url = "https://raw.githubusercontent.com/cquinones100/minecraft-turtle/main/mining_turtle.lua",
  },
}

for _, file in pairs(files) do
  local timestamp = os.time()

  print("Downloading " .. file.file .. "...")

  local request = http.get(file.url .. "?t=" .. timestamp)

  local contents = request.readAll()
  request.close()

  local file = fs.open(file.file, "w")

  file.write(contents)
end

-- local stairs = require("stairs")
local mine = require("mine")

mine.run()

