local function Chinese()
    hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.ITABC")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- app to expected ime config
local app2Ime = {
    {'/Applications/iTerm.app', 'English'},
    {'/System/Library/CoreServices/Finder.app', 'English'},
    {'/System/Library/CoreServices/Spotlight.app', 'English'},
    {'/Applications/System Preferences.app', 'English'},
    {'/Applications/Visual Studio Code.app', 'English'},
    {'/Applications/Notion.app', 'English'},
    {'/Applications/网易有道词典.app', 'English'},
    {'/Applications/PyCharm.app', 'English'},
    {'/Users/zli/installed/Qt5.14.2/Qt Creator.app', 'English'},
    {'/Appliactions/Android Studio.app', 'English'},
    {'/Users/zli/Library/Application Support/JetBrains/Toolbox/apps/IDEA-U/ch-0/211.6693.111/IntelliJ IDEA.app', 'English'},
    {'/Applications/DingTalk.app', 'Chinese'},
    {'/Applications/NeteaseMusic.app', 'Chinese'},
    -- {'/Applications/WeChat.app', 'Chinese'},
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            if expectedIme == 'English' then
                English()
            else
                Chinese()
            end
            break
        end
    end
end

-- helper hotkey to figure out the app path and name of current focused window
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
