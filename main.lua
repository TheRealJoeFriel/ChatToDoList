local frame = CreateFrame("Frame"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

function frame:OnEvent(event, arg1)
   if event == "ADDON_LOADED" and arg1 == "ChatToDoList" then -- Addon has been loaded
      if ToDoList == nil then
         ToDoList = {}; -- If there has been no list created then create one
         return;
      end
   end

   if event == "PLAYER_LOGOUT" and arg1 == "ChatToDoList" then -- MIGHT NOT NEED THIS
      ToDoList = ToDoList; -- Save the list to a file when logging out
   end
end

frame:SetScript("OnEvent", frame.OnEvent);

function ToDoListHandler(msg)
   local words = {}

   if (#msg == 0) then
      printTable(ToDoList);
      return;
   end 

   words[1], words[2] = msg:match("(%w+)(.*)")
   words[1] = string.lower(words[1])

   if words[1] == "add" then -- Adding a new item
      if words[2] == "" then
         print("Please add a valid item to add to your list.");
         return;
      elseif (#ToDoList > 20) then
         print("Sorry you can only have 20 items on your list at a time.")
         return;
      end

      -- Add the new item
      print(words[2] .. " has been added to your list.")
      ToDoList[#ToDoList+1] = words[2];
      return;
   
   elseif words[1] == "rm" or words[1] == "remove" then -- Removing an item, want to do it just by having them enter an index of the list
      
      if words[2] == "" then -- If there is no second argument supplied
         print("Please enter an item number to delete.");
         return;
      end

      index = tonumber(words[2])
      if  index == nil then  -- If they do not enter in a number
         print(words[2] .. " is not a valid item number to delete"); 
         return
      else 
         print("Removing " .. ToDoList[index] .. " from your list.");
         table.remove(ToDoList, index);
         return;
      end

   elseif words[1] == "clear" then -- Clear the list
      ToDoList = {};
      print("Your list has been reset.")
      return;
   
   elseif words[1] == "help" then -- List the possible commands
      print("Welcome to ChatToDoList:\nType '/todo' to display your current to do list.\nType '/todo add <item>' to add <item> to your list\nType '/todo remove <index>' to remove item number <index> from your list\nType '/todo clear' to clear your list");
      return;

   else
      print("Can't do anything");
      return;
   end
end

function printTable(table) 
   print("ChatToDoList: number of items = " .. #ToDoList);
   for index, data in ipairs(ToDoList) do
      print(index .. ". " .. data)
   end
   return;
end

SLASH_TODO1 = "/todo";
function SlashCmdList.TODO(msg) -- Set up slash commands
   ToDoListHandler(msg);
   return;
end