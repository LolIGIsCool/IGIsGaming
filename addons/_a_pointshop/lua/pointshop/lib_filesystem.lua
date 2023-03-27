/************************
	filesystem by Shendow
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

function base_table:DataPath(fil)
	return self.FolderName .. "/" .. fil
end

function base_table:Read(fil)
	return file.Read(self:DataPath(fil), "DATA") or ""
end

function base_table:Write(fil, s)
	file.Write(self:DataPath(fil), s)
end

function base_table:Delete(fil, s)
	file.Delete(self:DataPath(fil), s)
end

function base_table:Append(fil, s)
	file.Append(self:DataPath(fil), s)
end

function base_table:ReadJSON(fil)
	return util.JSONToTable(self:Read(fil)) or {}
end

function base_table:SaveJSON(fil, tbl)
	file.Write(self:DataPath(fil), util.TableToJSON(tbl))
end

function base_table:CreateFolder(fol)
	local p = self:DataPath(fol)
	if (!file.IsDir(p, "DATA")) then
		file.CreateDir(p)
	end
end

function base_table:FileExists(fil)
	return file.Exists(self:DataPath(fil), "DATA")
end

function base_table:FileList(fil)
	local fil, fol = file.Find(self:DataPath(fil), "DATA")
	return fil, fol
end

function base_table:SetWorkFolder(fn)
	self.FolderName = fn

	if (!file.Exists(fn, "DATA")) then
		file.CreateDir(fn)
	end
end

base_table:SetWorkFolder(base_table.DataFolderName)