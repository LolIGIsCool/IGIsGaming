/************************
	PanelHook by Shendow
	http://steamcommunity.com/id/shendow/

	Copyright (c) 2018

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
************************/

local base_table = SH_POINTSHOP
local prefix = "SH_POINTSHOP."

if (SERVER) then
	util.AddNetworkString(prefix .. "PanelHook")

	function base_table:CallPanelHook(ply, hn, ...)
		net.Start(prefix .. "PanelHook")
			net.WriteString(hn)
			net.WriteTable({...})
		net.Send(ply)
	end
else
	base_table.PanelHooks = base_table.PanelHooks or {}
	base_table.PanelHooksID = base_table.PanelHooksID or 0

	function base_table:AddPanelHook(name, pnl, func, autocall)
		if (!self.PanelHooks[name]) then
			self.PanelHooks[name] = {}
		end

		local pnlname
		if (!pnl.m_iHookID) then
			self.PanelHooksID = self.PanelHooksID + 1
			pnl.m_iHookID = self.PanelHooksID
		end
		pnlname = tostring(pnl) .. pnl.m_iHookID

		self.PanelHooks[name][pnlname] = {pnl, func}

		if (autocall) then
			func(pnl)
		end
	end

	function base_table:CallPanelHook(name, ...)
		for pnl, d in pairs (self.PanelHooks[name] or {}) do
			if (!IsValid(d[1])) then
				self.PanelHooks[pnl] = nil
				continue
			end

			d[2](d[1], ...)
		end
	end

	net.Receive(prefix .. "PanelHook", function()
		base_table:CallPanelHook(net.ReadString(), unpack(net.ReadTable()))
	end)
end