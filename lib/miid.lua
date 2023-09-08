--Master preset stuff(MIDI Program Changes)
m=midi.connect(2)
function mpwrit(nam)                                 --Master preset write
  local mwritab={} mwritab["SPre"]=params:get("SPre") 
  mwritab["VPre"]=params:get("VPre") --get current 'S'equencer & softcut-'V'oice preset#s
  mwritab["SPrePgChD"]=params:get("SPrePgChD") 
  mwritab["SPrePgChU"]=params:get("SPrePgChU") --'..PgChD'=Program Change Down,'..PgChU'=Prog Ch Up
  mwritab["SPreActivePgCh"]=params:get("SPreActivePgCh") 
  mwritab["VPrePgChD"]=params:get("VPrePgChD")--'..PgCh'=Prog Ch applied as toggles
  mwritab["VPrePgChU"]=params:get("VPrePgChU") 
  mwritab["VPreActivePgCh"]=params:get("VPreActivePgCh")--(i.e.'activate'/'deactivate' function) 
  mwritab["InputPgCh"]=params:get("InputPgCh") mwritab["FreezePgCh"]=params:get("FreezePgCh")
  mwritab["TransprtPgCh"]=params:get("TransprtPgCh")                                                      
  mwritab["RestartPgCh"]=params:get("RestartPgCh") mwritab["DelRevPgCh"]=params:get("DelRevPgCh") 
  mwritab["FXVPgCh"]=params:get("FXVPgCh") mwritab["PtchPLPgCh"]=params:get("PtchPLPgCh") 
  mwritab["PtchPRPgCh"]=params:get("PtchPRPgCh") mwritab["PtchPRzPgCh"]=params:get("PtchPRzPgCh")
  for i=1,4 do
    mwritab["S"..i.."_PlyPgCh"]=params:get("S"..i.."_PlyPgCh") mwritab["S"..i.."_RlnPgCh"]=params:get("S"..i.."_RlnPgCh")
    mwritab["S"..i.."_DflPgCh"]=params:get("S"..i.."_DflPgCh")
  end
  for i=1,6 do
    mwritab["V"..i.."PreFreezePgCh"]=params:get("V"..i.."PreFreezePgCh") 
    mwritab["V"..i.."GoPgCh"]=params:get("V"..i.."GoPgCh")
    mwritab["V"..i.."RecPgCh"]=params:get("V"..i.."RecPgCh")
    mwritab["V"..i.."Amp2LnPgCh"]=params:get("V"..i.."Amp2LnPgCh")
    mwritab["V"..i.."Ptch2LnPgCh"]=params:get("V"..i.."Ptch2LnPgCh")
    mwritab["V"..i.."_LpNumPgChU"]=params:get("V"..i.."_LpNumPgChU")
    mwritab["V"..i.."_LpNumPgChD"]=params:get("V"..i.."_LpNumPgChD")
    mwritab["V"..i.."Amp2PosPgCh"]=params:get("V"..i.."Amp2PosPgCh")
    mwritab["V"..i.."Amp2SpdPgCh"]=params:get("V"..i.."Amp2SpdPgCh")
    mwritab["V"..i.."AmpRecPgCh"]=params:get("V"..i.."AmpRecPgCh")
  end
  tab.save(mwritab,_path.data.."loki/"..nam)
end

function mpread(nam)                                  --Master preset read
  local err local mreadtab={} mreadtab,err=tab.load(_path.data.."loki/"..nam)
  if err==nil then
      params:set("SPre", mreadtab["SPre"]) params:set("VPre", mreadtab["VPre"])
      params:set("SPrePgChD",mreadtab["SPrePgChD"]) params:set("SPrePgChU",mreadtab["SPrePgChU"])
      params:set("SPreActivePgCh",mreadtab["SPreActivePgCh"]) params:set("VPrePgChD",mreadtab["VPrePgChD"]) 
      params:set("VPrePgChU",mreadtab["VPrePgChU"]) params:set("VPreActivePgCh",mreadtab["VPreActivePgCh"])
      params:set("InputPgCh", mreadtab["InputPgCh"]) params:set("FreezePgCh", mreadtab["FreezePgCh"]) 
      params:set("TransprtPgCh", mreadtab["TransprtPgCh"])
      params:set("RestartPgCh", mreadtab["RestartPgCh"]) params:set("DelRevPgCh", mreadtab["DelRevPgCh"])
      params:set("FXVPgCh", mreadtab["FXVPgCh"]) params:set("PtchPLPgCh", mreadtab["PtchPLPgCh"])
      params:set("PtchPRPgCh", mreadtab["PtchPRPgCh"]) params:set("PtchPRzPgCh", mreadtab["PtchPRzPgCh"])
  
    for i=1,4 do
      params:set("S"..i.."_PlyPgCh",mreadtab["S"..i.."_PlyPgCh"]) params:set("S"..i.."_RlnPgCh",mreadtab["S"..i.."_RlnPgCh"])
      params:set("S"..i.."_DflPgCh",mreadtab["S"..i.."_DflPgCh"])
    end
    
    for i=1,6 do 
      params:set("V"..i.."PreFreezePgCh", mreadtab["V"..i.."PreFreezePgCh"]) 
      params:set("V"..i.."RecPgCh", mreadtab["V"..i.."RecPgCh"])
      params:set("V"..i.."GoPgCh", mreadtab["V"..i.."GoPgCh"])
      params:set("V"..i.."Amp2LnPgCh", mreadtab["V"..i.."Amp2LnPgCh"])
      params:set("V"..i.."Ptch2LnPgCh", mreadtab["V"..i.."Ptch2LnPgCh"])
      params:set("V"..i.."_LpNumPgChU", mreadtab["V"..i.."_LpNumPgChU"])
      params:set("V"..i.."_LpNumPgChD", mreadtab["V"..i.."_LpNumPgChD"])
      params:set("V"..i.."Amp2PosPgCh", mreadtab["V"..i.."Amp2PosPgCh"])
      params:set("V"..i.."Amp2SpdPgCh", mreadtab["V"..i.."Amp2SpdPgCh"])
      params:set("V"..i.."AmpRecPgCh", mreadtab["V"..i.."AmpRecPgCh"])
    end
  end
end
-- *****IF YOU'D PREFER: you can edit the default MIDI-program-change assignments, manually/directly just below:***** --
  -- (you can text-edit any of the three presets like this: rewrite the defaults how you want, save, then restart the script...
  --    then from within the app, save to a newer preset number, come back to the preset.lua file, rinse-and-repeat... )
-- *****just as an alternate way to create presets if you ever find it faster after getting to know param names ***** --
params:add_number("MPre", "MasterPreset",1,500,1) --Master Preset ('MPre'/'SPre'/'VPre' don't need midimap; just for recall)
params:set_action("MPre", function(mpre) mpread("M_"..mpre..".lki") end) --load the preset/file
params:add_number("SPre", "SPreset",1,500,1)
params:set_action("SPre", function(spre) spread("S_"..spre..".lki") end) --    ""
params:add_number("VPre", "VPreset",1,500,1)
params:set_action("VPre", function(vpre) vpread("V_"..vpre..".lki") end) --    ""
params:add_group("PgCh_Grp","MIDIProgChAssign_Group",77)  --
params:add_number("MPrePgChD", "MPrePrgChDown", 0, 127, 12) -- Master-pre program change up
params:add_number("MPrePgChU", "MPrePrgChUp", 0, 127, 13) -- Master-pre program change up
params:add_number("SPrePgChD", "SPrePrgChDown", 0, 127, 10) -- S-Pag-pre program change down
params:add_number("SPrePgChU", "SPrePrgChUp", 0, 127, 11)  -- S-Page-pre program change up
params:add_number("SPreActivePgCh", "SPreActivePrgCh", 0, 127, 15)  --make S-page program changes active
params:add_number("VPrePgChD", "VPrePrgChDown", 0, 127, 20)  -- etc...
params:add_number("VPrePgChU", "VPrePrgChUp", 0, 127, 21)
params:add_number("VPreActivePgCh", "VPreActivePrgCh", 0, 127, 17)  
params:add_number("InputPgCh", "InputMonitorPrgCh", 0, 127, 18)     --input-monitor toggle
params:add_number("FreezePgCh", "FreezePrgCh", 0, 127, 19)          --freeze tempo-related params(S-Page)
params:add_number("TransprtPgCh", "TransportPrgCh", 0, 127, 14)              --transport play on/off
params:add_number("RestartPgCh", "RestartPrgCh", 0, 127, 30)        --restart transport(w/out off)
params:add_number("DelRevPgCh", "DelayReverbPrgCh", 0, 127, 4)      --toggle random delay/reverb
params:add_number("FXVPgCh", "FXVortexPrgCh", 0, 127, 5)            --toggle FX Vortex on/off
params:add_number("PtchPLPgCh", "PitchPollLeftPrgCh", 0, 127, 6)    --activate left-input pitch-poll
params:add_number("PtchPRPgCh", "PitchPollRightPrgCh", 0, 127, 7)   --activate right-input pitch-poll
params:add_number("PtchPRzPgCh", "PitchPollRezPrgCh", 0, 127, 8) --apply pitch-poll(whichever's active) to rezon8r pitch

for i=1,4 do
  params:add_number("S"..i.."_PlyPgCh", "S"..i.."_PlayPrgCh",0,127,22+i) 
  params:add_number("S"..i.."_RlnPgCh", "S"..i.."_RandomLengthPrgCh",0,127,109+i)
  params:add_number("S"..i.."_DflPgCh", "S"..i.."_DrunkFileWalkPrgCh",0,127,114+i)
end

for i=1,6 do                                                                                        --SoftCut Voices 1 thru 6
  params:add_number("V"..i.."PreFreezePgCh", "V"..i.."PreFreezePrgCh", 0, 127, (10*i)+29)  --freeze params per-voice
  params:add_number("V"..i.."RecPgCh", "V"..i.."RecPrgCh", 0, 127, (10*i)+30)                --
  params:add_number("V"..i.."GoPgCh", "V"..i.."GoPrgCh", 0, 127, (10*i)+31)
  params:add_number("V"..i.."Amp2LnPgCh", "V"..i.."Amp2LengthPrgCh", 0, 127, (10*i)+33)     --applying polls...
  params:add_number("V"..i.."Ptch2LnPgCh", "V"..i.."Pitch2LengthPrgCh", 0, 127, (10*i)+34)
  params:add_number("V"..i.."_LpNumPgChU", "V"..i.."_LoopNumPrgChUp",0,127,(10*i)+37)
  params:add_number("V"..i.."_LpNumPgChD", "V"..i.."_LoopNumPrgChDown",0,127,(10*i)+38)
  params:add_number("V"..i.."Amp2PosPgCh", "V"..i.."Amp2PositionPrgCh", 0, 127, (10*i)+35)
  params:add_number("V"..i.."Amp2SpdPgCh", "V"..i.."Amp2SpeedPrgCh", 0, 127, (10*i)+36)
  params:add_number("V"..i.."AmpRecPgCh", "V"..i.."Amp2RecPrgCh", 0, 127, (10*i)+39)
end

params:bang() --other params exist in other files, but are instantiated first, bang here at the end

--MIDI stuff

m.event = function(data)
  local d = midi.to_msg(data)
  if d.type == "program_change" then
    if lrn>0 then            --MIDI-learn of program change
      if page==1 then
        if sel==25 then if lrn==2 then params:set("MPrePgChU",d.val) else params:set("MPrePgChD",d.val) end
        elseif sel==24 then if lrn==2 then params:set("SPrePgChU",d.val) else params:set("SPrePgChD",d.val) end
        elseif sel==-7 then params:set("SPreActivePgCh",1-params:get("SPreActivePgCh")) --while 'thresh:' is selected
        elseif sel==0 then params:set("RestartPgCh",d.val)  --while tempo is selected, map to transport-restart(no stop)
        elseif sel==2 then params:set("FXVPgCh",d.val)
        elseif sel==-1 then params:set("TransprtPgCh",d.val) --(regular transport start/stop)
        elseif sel==-2 then params:set("InputPgCh",d.val)    --while midilearn is selected... = map to 'input monitor'
        elseif sel==1 then params:set("DelRevPgCh",d.val)    --while swing is selected..map to delay/reverb toggle
        elseif sel==-3 then params:set("FreezePgCh",d.val)
        elseif sel==-6 then params:set("PtchPLPgCh",d.val)
        elseif sel==-5 then params:set("PtchPRPgCh",d.val)
        elseif sel==-4 then params:set("PtchPRzPgCh",d.val)
        elseif sel==-9 then params:set("AT1PgCh",d.val)
        elseif sel==-8 then params:set("AT2PgCh",d.val)
        elseif ((sel>3) and (sel<8)) then params:set("S"..(sel-3).."_PlyPgCh",d.val)
        elseif ((sel>7) and (sel<12)) then params:set("S"..(sel-7).."_DflPgCh",d.val)
        elseif ((sel>11) and (sel<16)) then params:set("S"..(sel-11).."_RlnPgCh",d.val)
        end
      elseif page==3 then
        if hsel==-1 then if lrn==2 then params:set("VPrePgChU",d.val) else params:set("VPrePgChD",d.val) end
        elseif hsel==5 then params:set("VPreActivePgCh",d.val) --while mode is selected
        elseif hsel==2 then params:set("V"..vsel.."PreFreezePgCh",d.val) 
        elseif hsel==3 then params:set("V"..vsel.."RecPgCh",d.val) --select the voice-playback UI toggle(just right of voice#)
        elseif hsel==0 then params:set("V"..vsel.."GoPgCh",d.val)   --select the transport button
        elseif hsel==6 then params:set("V"..vsel.."Amp2LnPgCh",d.val)
        elseif hsel==7 then params:set("V"..vsel.."Ptch2LnPgCh",d.val)
        elseif hsel==9 then 
          if params:get("V"..vsel.."_Mod")==3 then 
            if lrn==2 then params:set("V"..vsel.."_LpNumPgChU",d.val) else params:set("V"..vsel.."_LpNumPgChD",d.val) end
          else params:set("V"..vsel.."Amp2PosPgCh",d.val) end
        elseif hsel==11 then params:set("V"..vsel.."Amp2SpdPgCh",d.val)
        elseif hsel==15 then params:set("V"..vsel.."AmpRecPgCh",d.val)
        end
      end
    else                     --ProgramChange assignments/functions
      for i=1,6 do  --softcut page (used more often, so checking these 1st might be slightly faster)
        if d.val == params:get("V"..i.."PreFreezePgCh") then voices[i].pfreez=1-voices[i].pfreez
        elseif d.val == params:get("V"..i.."RecPgCh") then
          if params:get("V"..i.."_Mod")==1 then              --Mode 1 = stutter(k2 turns stutter on/off)
            params:set("V"..i.."_Go",1-params:get("V"..i.."_Go"))  --clock turns rec off after 2-4beats
            if params:get("V"..i.."_Go")>0 then params:set("V"..i.."_Rc",1) end
          elseif params:get("V"..i.."_Mod")==2 then                          --Mode 2 = Delay
            params:set("V"..i.."_Go",1-params:get("V"..i.."_Go"))   --k2 turns delay on/off
          else      --Mode 3 = Live Looper; k2 sets recording to start at beginning of next cycle...
            voice[i].prerec=2                     --..then stop-recording and start-play at cycle after that
          end
        elseif d.val == params:get("V"..i.."GoPgCh") then params:set("V"..i.."_Go",1-params:get("V"..i.."_Go"))
        elseif d.val == params:get("V"..i.."Amp2LnPgCh") then params:set("V"..i.."_ALn",1-params:get("V"..i.."_ALn"))
        elseif d.val == params:get("V"..i.."Ptch2LnPgCh") then params:set("V"..i.."_PLn",1-params:get("V"..i.."_PLn"))
        elseif d.val == params:get("V"..i.."_LpNumPgChU") then params:set("V"..i.."_LpNum",params:get("V"..i.."_LpNum")+1)
        elseif d.val == params:get("V"..i.."_LpNumPgChD") then params:set("V"..i.."_LpNum",params:get("V"..i.."_LpNum")-1)
        elseif d.val == params:get("V"..i.."Amp2PosPgCh") then params:set("V"..i.."_APs",1-params:get("V"..i.."_APs"))
        elseif d.val == params:get("V"..i.."Amp2SpdPgCh") then params:set("V"..i.."_ASp",1-params:get("V"..i.."_ASp"))
        elseif d.val == params:get("V"..i.."AmpRecPgCh") then params:set("V"..i.."_ARc",1-params:get("V"..i.."_ARc"))
        end
      end
                                              --main page--
      for i=1,4 do
        if d.val==params:get("S"..i.."_PlyPgCh") then params:set("S"..i.."_Ply",1-params:get("S"..i.."_Ply"))
        elseif d.val==params:get("S"..i.."_RlnPgCh") then params:set("S"..i.."_Rln",1-params:get("S"..i.."_Rln"))
        elseif d.val==params:get("S"..i.."_DflPgCh") then params:set("S"..i.."_Dfl",1-params:get("S"..i.."_Dfl")) end
      end
                                                          
      if d.val == params:get("MPrePgChD") then
        --if spr>0 then params:set("MPre", util.wrap(params:get("MPre")-1,1,500)) sprenum = params:get("MPre")
          --else sprenum = util.wrap(sprenum-1,1,500) end
      elseif d.val == params:get("SPrePgChU") then
        if spr>0 then params:set("SPre", util.wrap(params:get("SPre")+1,1,500)) sprenum = params:get("SPre")
          else sprenum = util.wrap(sprenum+1,1,500) end
      elseif d.val == params:get("SPrePgChD") then
        if spr>0 then params:set("SPre", util.wrap(params:get("SPre")-1,1,500)) sprenum = params:get("SPre")
          else sprenum = util.wrap(sprenum-1,1,500) end
      elseif d.val == params:get("SPrePgChU") then
        if spr>0 then params:set("SPre", util.wrap(params:get("SPre")+1,1,500)) sprenum = params:get("SPre")
          else sprenum = util.wrap(sprenum+1,1,500) end
      elseif d.val == params:get("SPreActivePgCh") then spr=1-spr if spr>0 then params:set("SPre",sprenum) end
      elseif d.val == params:get("VPrePgChD") then
        if vpr>0 then params:set("VPre", util.wrap(params:get("VPre")-1,1,500)) vprenum = params:get("VPre")
          else vprenum = util.wrap(vprenum-1,1,500) end
      elseif d.val == params:get("VPrePgChU") then
        if vpr>0 then params:set("VPre", util.wrap(params:get("VPre")+1,1,500)) vprenum = params:get("VPre")
          else vprenum = util.wrap(vprenum+1,1,500) end
      elseif d.val == params:get("VPreActivePgCh") then vpr=1-vpr if vpr>0 then params:set("VPre",vprenum) end
      elseif d.val == params:get("InputPgCh") then params:set("InMon", 1-params:get("InMon"))
      elseif d.val == params:get("FreezePgCh") then prmfreez=1-prmfreez
      elseif d.val == params:get("RestartPgCh") then tix=0 tixx=-1
      elseif d.val == params:get("FXVPgCh") then params:set("Fxv", 1-params:get("Fxv"))
      elseif d.val == params:get("TransprtPgCh") then
        if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
            if go>0 then clock.transport.stop() else clock.transport.start() end 
        elseif params:string("clock_source")=="link" then 
            if go>0 then clock.link.stop() else clock.link.start() end
        end tix=0 tixx=-1
      elseif d.val == params:get("PtchPLPgCh") then params:set("PT1",1-params:get("PT1")) 
      elseif d.val == params:get("PtchPRPgCh") then params:set("PT2",1-params:get("PT2")) 
      elseif d.val == params:get("PtchPRzPgCh") then params:set("S_PRz",1-params:get("S_PRz"))
      end
      if(rdrw<1) then rdrw=1 end
    end
  end
end
