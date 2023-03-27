function getQuery(queryStr, reason, _callback) 
    local queryFrame = vgui.Create("DFrame")
    queryFrame:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    queryFrame:Center()
    queryFrame:SetVisible( false )

    local query = vgui.Create("DHTML", queryFrame)
    query:Dock(FILL)
    query:OpenURL("https://www.youtube.com/results?search_query="..queryStr)
    query:AddFunction( "console", "hide_queryComplete", function( str, err )
        queryFrame:Remove()
        if (err) then
            notification.AddLegacy("Query Failed", 1, 2)
            return
        end
        _callback(str)
    end)

    function query:OnFinishLoadingDocument( str )
        query:RunJavascript([[
            try {
                setTimeout(function() {
                    var element = document.getElementsByTagName('ytd-video-renderer')
                    var vidTable = {}
                    for (var i = 0; i < element.length; i++) {

                        let vidContainer = element[i].children[0]

                        //let thumbnailSrc = (vidContainer.children[0].children[0].children[0].children[0].currentSrc) // Thumbnail Link
                        let title = (vidContainer.children[1].children[0].children[0].children[0].children[1].innerText) // Title
                        //let vidLength = (vidContainer.children[0].children[0].children[1].children[1].children[1].innerText) // Length
                        let artist = (vidContainer.children[1].children[1].children[1].children[0].innerText) // Artist
                        let url = (vidContainer.children[1].children[0].children[0].children[0].children[1].href) // Title

                        let retTable = {
                            //"thumbnailSrc": thumbnailSrc.toString(),
                            "title": title.toString(),
                            //"vidLength": vidLength.toString(),
                            "artist": artist.toString(),
                            "url": url,
                        } 

                        vidTable[i] = retTable;
                        if((i + 1) == (element.length)){
                            console.log("Last iteration with item");
                            console.hide_queryComplete(JSON.stringify(vidTable))
                        }
                    }
                }, 2500)
            } catch (err) {
                console.hide_queryComplete("", err)
            }
        ]])
    end
end
-- https://gist.github.com/mattkrins/5455b96631cc2ebdf0e577a71d1a3d54
local WebMaterials = {}
function surface.GetURL(url, w, h, time)
	if !url or !w or !h then return Material("error") end
	if WebMaterials[url] then return WebMaterials[url] end
	local WebPanel = vgui.Create( "HTML" )
	WebPanel:SetAlpha( 0 )
	WebPanel:SetSize( tonumber(w), tonumber(h) )
	WebPanel:OpenURL( url )
	WebPanel.Paint = function(self)
		if !WebMaterials[url] and self:GetHTMLMaterial() then
			WebMaterials[url] = self:GetHTMLMaterial()
			self:Remove()
		end
	end
	timer.Simple( 1 or tonumber(time), function() if IsValid(WebPanel) then WebPanel:Remove() end end ) // In case we do not render
	return Material("error")
end