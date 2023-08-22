--Seq(Main)-page parameters
params:add_number("Swng", "Swing",0.0,2.0,0.0) params:add_number("Swdth", "Swidth",0.0,1.0,0.1) 
params:add_number("InMon", "InputMonitor",0,1,1) params:set_action("InMon", function(imon) audio.level_monitor(imon) end) 
for i=1,4 do
  params:add_group("S"..i.."_Grp","S"..i.."_Group",8)
  params:add_number("S"..i.."_Ply", "S"..i.."_Play",0,1,1) params:add_number("S"..i.."_Stt", "S"..i.."_Stutter",0,2,0)
  params:add_number("S"..i.."_Rct", "S"..i.."_RandomCutoff",0,1,0) params:add_number("S"..i.."_Rln", "S"..i.."_RandomLength",0,1,0)
  params:add_number("S"..i.."_Dfl", "S"..i.."_DrunkFileWalk",0,1,0) params:add_number("S"..i.."_Sln", "S"..i.."_SeqLengthDiff",-63,0,0)
  params:add_number("S"..i.."_Svl", "S"..i.."_SeqTrackVolume",0.0,4.0,1.4) 
  params:add_number("S"..i.."_Fil", "S"..i.."_File",0,#files[i],1)
  params:set_action("S"..i.."_Fil", function(fil) selct[i]=fil engine.flex(i-1,fildir[i]..files[i][selct[i]]) end)
end
params:add_group("PtcnFX_Grp","PitchAndFX_Group",8)
params:add_number("S_PRz", "PitchTrackRezonator",0,1,0)
params:add_number("PT1", "PitchTrackLeftIn",0,1,0) params:add_number("PT2", "PitchTrackRightIn",0,1,0)
params:set_action("PT1", function(ptr) if ptr>0 then pchlf:start() else pchlf:stop() end end)
params:set_action("PT2", function(ptr) if ptr>0 then pchrt:start() else pchrt:stop() end end)
params:add_number("ATr","AmpTrigThresh",0.0,1.0,0.002)
params:add_number("AT1","AmpTrigLeft",0,1,0)
params:set_action("AT1", function(atr) if atr>0 then pollf:start() else pollf:stop() end end)
params:add_number("AT2","AmpTrigRight",0,1,0)
params:set_action("AT2", function(atr) if atr>0 then pollr:start() else pollr:stop() end end)
params:add_number("Fxvc", "FXVortexCycle",1,64,8) params:add_number("Fxv", "FXVortex",0,1,0)
params:set_action("Fxv", function(fx) if fx<1 then engine.fxrtds(0) engine.fxrtrz(0) engine.fxrtrv(0)end end)

function spwrit(nam)
  local writab={} writab["Tempo"]=params:get("clock_tempo") writab["Swng"]=params:get("Swng") writab["Swdth"]=params:get("Swdth")
  writab["S_PRz"]=params:get("S_PRz") writab["PT1"]=params:get("PT1") writab["PT2"]=params:get("PT2")
  writab["AT1"]=params:get("AT1") writab["AT2"]=params:get("AT2") writab["ATr"]=params:get("ATr")
  writab["Fxvc"]=params:get("Fxvc") writab["Fxv"]=params:get("Fxv") writab["InMon"]=params:get("InMon")
  writab["RezPitchz"]=rezpitchz
  for i=1,4 do
    writab["S"..i.."_Ply"]=params:get("S"..i.."_Ply") writab["S"..i.."_Stt"]=params:get("S"..i.."_Stt")
    writab["S"..i.."_Rct"]=params:get("S"..i.."_Rct") writab["S"..i.."_Rln"]=params:get("S"..i.."_Rln")
    writab["S"..i.."_Dfl"]=params:get("S"..i.."_Dfl") writab["S"..i.."_Sln"]=params:get("S"..i.."_Sln")
    writab["S"..i.."_Svl"]=params:get("S"..i.."_Svl")
  end
  writab["seq"]=seq writab["selct"]=selct writab["fildir"]=fildir writab["files"]=files writab["swuiflag"]=swuiflag
  tab.save(writab,_path.data.."loki/"..nam)
end

function spread(nam)
  local err local readtab={} readtab,err=tab.load(_path.data.."loki/"..nam)
  if err==nil then
    seq=readtab["seq"]  
    if prmfreez<1 then 
      swuiflag=readtab["swuiflag"] params:set("clock_tempo", readtab["Tempo"]) 
      params:set("Swng",readtab["Swng"]) params:set("Swdth",readtab["Swdth"]) 
      params:set("S_PRz",readtab["S_PRz"]) params:set("PT1",readtab["PT1"]) params:set("PT2",readtab["PT2"])
      params:set("Fxvc", readtab["Fxvc"]) params:set("Fxv", readtab["Fxv"]) params:set("InMon", readtab["InMon"])
      params:set("ATr", readtab["ATr"]) params:set("AT1", readtab["AT1"]) params:set("AT2", readtab["AT2"])
      rezpitchz=readtab["RezPitchz"] selct=readtab["selct"] fildir=readtab["fildir"] files=readtab["files"]
    end
    for i=1,4 do 
      params:set("S"..i.."_Ply", readtab["S"..i.."_Ply"]) params:set("S"..i.."_Stt", readtab["S"..i.."_Stt"])
      params:set("S"..i.."_Rct", readtab["S"..i.."_Rct"]) params:set("S"..i.."_Rln", readtab["S"..i.."_Rln"])
      params:set("S"..i.."_Dfl", readtab["S"..i.."_Dfl"]) params:set("S"..i.."_Sln", readtab["S"..i.."_Sln"])
      params:set("S"..i.."_Svl", readtab["S"..i.."_Svl"])
      engine.flex(i-1,readtab["fildir"][i]..readtab["files"][i][readtab["selct"][i]])
end end end
