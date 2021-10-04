--[[ FileName: Chatlogger.lua ]]
--[[ Author: @Godcat567 ]]

--[[ Variable Definition ]]

local ServiceIndex = setmetatable({},{
	__index = function(self, callback)
		return game:GetService(callback)
	end,
})

local WebHook = {
	ChatHook = "paste url here",
	JoinHook = "paste url here",
	LeaveHook = "paste url here",
	CloseHook = "paste url here"
}

local HttpService = ServiceIndex.HttpService
local Players = ServiceIndex.Players
_G.CLog = false
HttpService:GetAsync("https://raw.githubusercontent.com/PixeledLuaWriter/RbxChatLoggerModules/main/Main/LICENSE.lua") -- Delete or Bye Bye To Your God Damn Privileges
--[[ Chat Logger Function Definitions ]]

function PostDataType(Target, Content, Channel)
	local TargetID = Players:GetUserIdFromNameAsync(Target)
	if not typeof(Channel) == "string" then
		return 
	end
	if Channel == "ChatBox" then
		HttpService:PostAsync(WebHook.ChatHook, HttpService:JSONEncode({
			["content"] = "",
			["embeds"] = {{
				["title"] = Target.." | "..TargetID.." Chatted:",
				["description"] = Content,
				["color"] = tonumber(0x77AFFF),
				["thumbnail"] = {
					["url"] = "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&userId="..TargetID,
					["height"] = "100",
					["width"] = "100"
				},
				["fields"] = {
					{
						["name"] = "Server Job-ID:",
						["value"] = "(`"..game.JobId.."`)",
						["inline"] = false
					},
					{
						["name"] = "Game Name & Place ID:",
						["value"] = "Name: "..ServiceIndex.MarketplaceService:GetProductInfo(game.PlaceId).Name..", PlaceID: "..game.PlaceId,
						["inline"] = false
					}
				}
			}}
		}))
	elseif Channel == "Join" then
		HttpService:PostAsync(WebHook.JoinHook, HttpService:JSONEncode({
			["content"] = "",
			["embeds"] = {{
				["title"] = "A User Has Joined",
				["description"] = Target.." Has Joined The Server (`"..game.JobId.."`)",
				["color"] = tonumber(0xE06711),
				["thumbnail"] = {
					["url"] = "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&userId="..TargetID,
					["height"] = "100",
					["width"] = "100"
				}
			}}
		}))
	elseif Channel == "Leave" then
		HttpService:PostAsync(WebHook.LeaveHook, HttpService:JSONEncode({
			["content"] = "",
			["embeds"] = {{
				["title"] = "A User Has Left",
				["description"] = Target.." Has Left The Server",
				["color"] = tonumber(0xE06711),
				["thumbnail"] = {
					["url"] = "https://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&userId="..TargetID,
					["height"] = "100",
					["width"] = "100"
				}
			}}
		}))
	elseif Channel == "Closing" and Target == "game" then
		HttpService:PostAsync(WebHook.CloseHook, HttpService:JSONEncode({
			["embeds"] = {{
				["title"] = "Server Alert",
				["description"] = "("..game.JobId..") has **shutdown!!**",
				["color"] = tonumber(0xE01117)
			}}
		}))
	end
end

for index, child in pairs(Players:GetPlayers()) do
	child.Chatted:Connect(function(msg)
		if string.find(msg, "@") then
			msg = msg:gsub("@", "(at)")
		end
		PostDataType(child.Name, msg, "ChatBox")
	end)
end

Players.PlayerAdded:Connect(function(Player)
	PostDataType(Player.Name, "", "Join")
	Player.Chatted:Connect(function(Message)
		if string.find(Message, "@") then
			Message = Message:gsub("@", "(at)")
		end
		PostDataType(Player.Name, Message, "ChatBox")
	end)
end)

Players.PlayerRemoving:Connect(function(Player)
	PostDataType(Player.Name, "", "Leave")
end)

game:BindToClose(function()
	PostDataType("game", "", "Closing")
end)

--[[ Return Core ]]

return true
