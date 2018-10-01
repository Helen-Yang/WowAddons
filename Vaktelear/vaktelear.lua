--
-- Date: 8/22/18
-- Time: 2:24 PM
--

print('hello world!')
-- frame setup
function vaktelearRegisterEvents(self)
    print("registering events")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("AUCTION_HOUSE_SHOW")
    print("finished registering events")
end

function vaktelearEventHandler(self, event, ...)
    print("event: "..event)

    if (event == "PLAYER_ENTERING_WORLD") then
        print('welcome to vaktelear')
    end

    if (event == "AUCTION_HOUSE_SHOW") then
        -- register AUCTION_HOUSE_CLOSED here to handle it firing twice
        self:RegisterEvent("AUCTION_HOUSE_CLOSED")
    end

    if (event == "AUCTION_HOUSE_CLOSED") then
        -- AUCTION_HOUSE_CLOSED sometimes fires twice
        self:UnregisterEvent("AUCTION_HOUSE_CLOSED")
    end
end
