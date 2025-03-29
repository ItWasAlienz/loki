--            loki
--        summoned by 
--   raja (ItWasAlienz)
-- see github for manual:
-- https://github.com
--   /ItWasAlienz
--     /loki_doc
--
-- few hints...
--  enc1 - select pages
--  enc2 - select params
--  enc3 - change params
--  k3 - activates things
--  k2 - most volatile..
-- ..can trigger rec/edit..
-- ..or save over presets.
-- there's also combos of
-- double-k press, make sure
-- to release in same order:
-- k1, then k2 = -1 preset#
-- k1, then k3 = +1 preset#
-- k3, then k2 = echo/rev
-- k2, then k3 = ...
--  ...contextual randomize... 
-- ..loki will play w/ yer mind..
-- ..loki will heart w/ yer play..
-- o_O.thanx for yer mischief.O_o
engine.name='Loki'
spdvalz={-2,-1.5,-1.2,-1,-0.8,-0.75 -0.5,0,0.333333,0.5,0.75,0.8,1,1.2,1.5,2}
rezpitchz={44,46,47,49,51,52,55,56,58,59,61,63,64,67,68,70,71,73,75,76}
fileselect=require('fileselect') scrn=include 'lib/scrn' 
mutil=require("musicutil") vox=include("loki/lib/voic") grd=include 'lib/grd'
fildir={_path.audio.."loki/BD/",_path.audio.."loki/SN/",_path.audio.."loki/CY/",_path.audio.."loki/XX/"}
fildrsel=1 filsel=0 sel=-1 sl=1 spel=1 vsel=1 hsel=-1 edit=0 page=1 uipag=0 spr=0 vpr=0 mpr=0 rdr=0 rdrw=0
pollf=0 pollr=0 go=0 tix=0 tixx=0 keytog=0 fil=0 tempo=0 sprenum=1 vprenum=1 lrn=0 strb=0 rndmidi=127
swuiflag=0 swim=0.0 swflag=0 lfprmult=0.5 prmfreez=0 voices={} for i=1,6 do table.insert(voices,Voic:new(i)) end 
gridbd={4,4} gridsn={12,4} gridhh={8,8} gridxx={8,12} --1st grid page sizes and starting positions
selct={1,1,1,1} pause={0,0,0,0} oone=0 onne=0 two=0 twoo=0 --file-'sel'(index), stutter-busy('pause's) and double-press flags
files = {} seq =        --files/sequencer vals for 4-piece kit(4 voices of 'PlayBuf' in supercollider layer)
{{1,0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,1,0,2,0,1,0,0,0,2,1,0,1,0,1,0,0,3,0,1,0,1,0,2,0,0,1,0,0,0,1,0,0,5,0,4,2}, 
  {0,0,1,0,0,0,1,0,0,0,0,1,0,2,0,0,0,0,1,0,0,0,1,0,0,0,0,3,0,1,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,2,0,0,0,0,1,0,0,0,1,0,2,0,1,0,0,1,0,0}, 
  {1,0,2,0,1,3,1,0,1,0,1,2,1,0,1,0,1,0,2,0,2,3,1,0,1,0,8,2,1,0,1,0,1,0,2,0,1,3,1,0,1,0,1,2,1,0,1,0,1,0,2,0,5,3,1,0,8,0,1,2,7,0,1,0},
  {0,0,0,1,0,1,0,0,1,0,1,0,0,1,1,0,0,0,0,1,0,3,0,0,1,0,1,0,0,5,2,0,0,0,0,1,0,1,0,0,3,0,1,0,0,1,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,1,1,0}}

function init()
  out_midi = midi.connect(1)
  pollf = poll.set("amp_in_l") pollr = poll.set("amp_in_r")   --setup polls
  pchlf = poll.set("pitch_in_l") pchrt = poll.set("pitch_in_r")
  for i=1,4 do files[i]=util.scandir(fildir[i])  engine.flex(i-1,fildir[i]..files[i][1]) end--register file directories & load files
  sparm=include 'lib/sparamz' vparm=include 'lib/vparamz' miid=include 'lib/miid' --params(these first for dependencies) + MIDI PgCh
  tempo=params:get("clock_tempo")  
  pollf.callback = function(val)                                          --poll left                    
    for i=1,6 do                                                    
      if params:get("AT1")>0 then              --"ampll" is an attempt to extend 'hysteresis'..  
        if val>params:get("ATr") and ampll<1 then
          if params:get("V"..i.."_ARc")>0 then          --..for less chance of false-retrigger(see voic.lua)
            if params:get("V"..i.."_Mod")==3 then 
              voices[i].prerec=2 params:set("AT1",0) 
            else params:set("V"..i.."_Rc",1) end 
          end
          if params:get("V"..i.."_ALn")>0 then
            if params:get("V"..i.."_Mod")==3 then voices[i].prerec=2 voices[i].lpcount=1 
            else params:set("V"..i.."_Len",(math.random(64)*2)*0.0078125) end 
          end
          if params:get("V"..i.."_APs")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              softcut.position(i,math.random(voices[i].strt[voices[i].lpno],voices[i].ennd[voices[i].lpno]))
            else params:set("V"..i.."_Phase",math.random(1000)*0.001) end
          end
          if params:get("V"..i.."_ASp")>0 then
            params:set("V"..i.."_Spd",params:get("V"..i.."_Spd")+((math.random(8)-4)*2)*0.015625) 
          end 
        elseif val<(params:get("ATr")*0.8) and ampll>0 then pllpset(0) end
  end end end
  pollr.callback = function(val) 
    for i=1,6 do
      if params:get("AT2")>0 then
        if val>params:get("ATr") and ampll<1 then
          if params:get("V"..i.."_ARc")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              voices[i].prerec=2 voices[i].lpcount=1 params:set("AT2",0)
            else params:set("V"..i.."_Rc",1) end
          end
          if params:get("V"..i.."_ALn")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              voices[i].prerec=2 voices[i].lpcount=1 params:set("AT2",0)
            else params:set("V"..i.."_Len",(math.random(64)*2)*0.0078125) end  --minimum of 1/128th note
          end
          if params:get("V"..i.."_APs")>0 then
            if params:get("V"..i.."_Mod")==3 then 
              softcut.position(i,math.random(voices[i].strt[voices[i].lpno],voices[i].ennd[voices[i].lpno]))
            else params:set("V"..i.."_Phase",math.random(1000)*0.001) end 
          end
          if params:get("V"..i.."_ASp")>0 then
            params:set("V"..i.."_Spd",params:get("V"..i.."_Spd")+((math.random(8)-4)*2)*0.015625)
          end
        elseif val<(params:get("ATr")*0.8) and ampll>0 then pllpset(0) end
  end end end
  pchlf.callback = function(val)
    if val>20 then --i cut out below 20Hz because of guitar and mics, but for modular inputs this could be removed
      for i=1,6 do if params:get("V"..i.."_PLn")>0 then params:set("V"..i.."_Lns",1.0/val) end end --1/freq = wavelength in secs
      if params:get("S_PRz")>0 then                                                   --for wavetable-oscillator-like control
        engine.rzset(mutil.freq_to_note_num(val),0.2,0.2) 
        engine.fxrtrz(1) engine.fxrtrv(math.random(2)-1)
      end 
    end
  end
  pchrt.callback = function(val)
    if val>20 then
      for i=1,6 do if params:get("V"..i.."_PLn")>0 then params:set("V"..i.."_Lns",1.0/val) end end
      if params:get("S_PRz")>0 then 
        engine.rzset(mutil.freq_to_note_num(val),0.2,0.2) 
        engine.fxrtrz(1) engine.fxrtrv(math.random(2)-1) 
      end 
    end
  end
  pollf.time = 0.04 pollr.time= 0.04 pchlf.time = 0.04 pchrt.time = 0.04
  engine.flow() engine.rzr(55,0.12,0.2,0,2); engine.dst(tempo,1,1,3) engine.rvrb(2,0) --route fx
  clock.run(uic) clock.run(gic) softcut.event_position(epos)
end

function uic() 
  while true do
    if page>1 then clock.sync(1/4) --if on sequencer page, synchronize visual to clock, otherwise...
    else clock.sleep(0.2) end    --refresh every 1/5th of a second
    if filsel<1 and rdrw>0 then redraw() end --let 'fileselect' have its own redraw(+ only redraw if not already)
  end
end

function gic() 
  while true do clock.sync(0.0625) -- grid display is always synchronized to a 1/16th of quarter-note(64th note)
    if grdpg==1 then
      if grdbdn>=0 then 
        if math.random(2)>1 then gridbd[1]=util.wrap(gridbd[1]+math.random(-1,1),2,6)
        else gridbd[2]=util.wrap(gridbd[2]+math.random(-1,1),2,6) end
        grdbdn=grdbdn-1
      end
      if grdsnn>=0 then 
        if math.random(2)>1 then gridsn[1]=util.wrap(gridsn[1]+math.random(-1,1),9,16)
        else gridsn[2]=util.wrap(gridsn[2]+math.random(-1,1),2,6) end
        grdsnn=grdsnn-1
      end
      if grdhhn>=0 then 
        if math.random(2)>1 then gridhh[1]=util.wrap(gridhh[1]+math.random(-1,1),4,12)
        else gridhh[2]=util.wrap(gridhh[2]+math.random(-1,1),4,12) end
        grdhhn=grdhhn-1 
      end
      if grdxxn>=0 then 
        if math.random(2)>1 then gridxx[1]=util.wrap(gridxx[1]+math.random(-1,1),5,12)
        else gridxx[2]=util.wrap(gridxx[2]+math.random(-1,1),6,16) end
        grdxxn=grdxxn-1 
      end
    else
    end
    grdraw()
  end
end
                                         -------------
                                         --TRANSPORT--
function clock.transport.start() 
  ply.status=1; go=1; id=clock.run(pop) 
  if params:string("clock_source")=="midi" or params:string("clock_source")=="link" then tix=0 tixx=0 end
  if params:string("clock_source")=="link" then clock.link.start() end
end

function clock.transport.stop() ply.status=4; 
  if id~=nil then clock.cancel(id); end go=0; id=nil 
  if params:string("clock_source")=="link" then clock.link.stop() end
end
                                          ------------
function enc(n,d)                         --ENCODERS--
  if n==1 then                                --enc1 switches pages(unless softcut page's 'cycles' param is selected)
    if page==3 and hsel==14 then params:set("V"..vsel.."_Ofst", params:get("V"..vsel.."_Ofst")+d) else page=util.wrap(page+d,1,3) end         
  elseif n==2 then
    if page==1 then               --page1 = main page(one-shot drums played back from supercollider + timing/presets)
      sel = util.wrap(sel+d,-9,25) --enc2 scrolls parameter selection.
      if sel==-1 then ply.active=true else ply.active=false end
    elseif page==2 then
      if edit==0 then --edit mode applies to editing sequencer (-> k2 while 'vol' is hilited)
        spel = util.wrap(spel+d,-1,5) --enc2 scrolls parameter selection..or..
        if spel==-1 then ply.active=true else ply.active=false end
      else                                        --..scrolls through which step to edit in sequencer
        if spel>-1 and spel<4 then 
          sl = util.wrap(sl+d,1,(#seq[spel+1]+params:get("S"..(spel+1).."_Sln"))) 
          uipag=util.round(math.floor((sl-1)/16),1) end
      end
    elseif page==3 then
      if params:get("V"..vsel.."_Mod")==3 then
        if d>0 then if hsel==5 then hsel=8 else hsel=util.wrap(hsel+d,-1,16) end
          elseif d<0 then if hsel==7 then hsel=5 else hsel=util.wrap(hsel+d,-1,16) end end
        else hsel=util.wrap(hsel+d,-1,16) end --on softcut page, enc2 selects params
      if hsel==0 then ply.active=true else ply.active=false end
    end
  elseif n==3 then              --enc3 changes parameter values(or edits chosen step in sequencer)
    if page==1 then
      if sel==-7 then params:set("ATr",util.clamp(util.round(params:get("ATr")+(d*0.0001),0.00001),0.0,1.0))
      elseif sel==0 then
        params:set("clock_tempo",util.round(params:get("clock_tempo")+(d*0.2),0.1)) 
        tempo=params:get("clock_tempo")
      elseif sel==1 then 
        if swuiflag==1 then params:set("Swdth", util.clamp(params:get("Swdth") + (d*0.01),0.0,1.0))
        else params:set("Swng", util.clamp(params:get("Swng") + (d*0.01),0.0,2.0)) end
      elseif sel==2 then params:set("Fxvc", util.clamp(params:get("Fxvc") + d,0,128))
      elseif sel==3 then fildrsel = util.wrap(fildrsel+d,1,4)
      elseif sel>3 and sel<8 then
        params:set("S"..(sel-3).."_Svl", util.clamp(params:get("S"..(sel-3).."_Svl") + (d*0.2),0,4))
      elseif sel>7 and sel<24 then
        params:set("S"..(((sel-8)%4)+1).."_Sln", util.clamp(params:get("S"..(((sel-8)%4)+1).."_Sln") + d,-63,0))
      elseif sel==24 then
        if spr>0 then params:set("SPre",util.wrap(params:get("SPre")+d,1,500)) sprenum = params:get("SPre")
        else sprenum = util.wrap(sprenum+d,1,500) end
      elseif sel==25 then params:set("MPre",util.wrap(params:get("MPre")+d,1,500)) end
    elseif page==2 then
      if spel>-1 and spel<4 then
        if edit==1 then seq[spel+1][sl]=util.wrap(seq[spel+1][sl]+d,0,11)
        elseif fil==1 then
          selct[((spel)%4)+1] = util.clamp(selct[((spel)%4)+1]+d,1,#files[((spel)%4)+1])
          engine.flex(((spel)%4),fildir[((spel)%4)+1]..files[((spel)%4)+1][selct[((spel)%4)+1]])
        else
          params:set("S"..(((spel)%4)+1).."_Sln", util.clamp(params:get("S"..(((spel)%4)+1).."_Sln") + d,-63,0))
        end
      elseif spel==4 then uipag=util.clamp(uipag+d,0,3) 
      elseif spel==5 then fildrsel = util.wrap(fildrsel+d,1,4) end
    else
      if hsel==-1 then
        if vpr>0 then params:set("VPre",util.wrap(params:get("VPre")+d,1,500)) vprenum = params:get("VPre")
        else vprenum = util.wrap(vprenum+d,1,500) end
      elseif ((hsel==2) or (hsel==3))  then vsel=util.wrap(vsel+d,1,6)      --hsel=2||3 - softcut voice(vsel)
      elseif hsel==4 then                            --hsel=4 - input_select
        params:set("V"..vsel.."_In",util.clamp(params:get("V"..vsel.."_In")+d,1,8))
      elseif hsel==5 then                    --hsel=5 > mode selection(stutter(1),delay(2),loop(3))
        params:set("V"..vsel.."_Mod",util.wrap(params:get("V"..vsel.."_Mod")+d,1,3))
      elseif hsel==8 then
        if params:get("V"..vsel.."_Mod")<3 then
          local vln = params:get("V"..vsel.."_Len")
          if vln>8 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+d,2,24.0),1))
          elseif vln>1 and vln<=8 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.5),0.5,24.0),0.5))
          elseif vln>0.5 and vln<=1 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.25),0.25,24.0),0.25))
          elseif vln>0.25 and vln<=0.5 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.125),0.125,24.0),0.125))
          elseif vln>0.125 and vln<=0.25 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.0625),0.0625,24.0),0.0625))
          elseif vln>0.0625 and vln<=0.125 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.03125),0.03125,24.0),0.03125))
          elseif vln>0.03125 and vln<=0.0625 then
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.015625),0.015625,24.0),0.015625))
          else
            params:set("V"..vsel.."_Len",util.round(util.clamp(vln+(d*0.004),0.004,4.0),0.004))
          end
        else params:set("V"..vsel.."_Impatnz",util.clamp(params:get("V"..vsel.."_Impatnz")+d,-1,64)) end
      elseif hsel==9 then   --> in "St" mode(scrolls phase), in "Lp"(choose loop num)
        if params:get("V"..vsel.."_Mod")==3 then
          params:set("V"..vsel.."_LpNum", util.wrap(params:get("V"..vsel.."_LpNum")+d,1,8))
        elseif params:get("V"..vsel.."_Mod")==1 then
          params:set("V"..vsel.."_Phase",util.round((params:get("V"..vsel.."_Phase")+(d*0.001))%1.0,0.001)) end
      elseif hsel==10 then
        params:set("V"..vsel.."_Fbk",util.clamp(params:get("V"..vsel.."_Fbk")+(d*0.1),0,1))
      elseif hsel==11 then                             --> playback-speed
        params:set("V"..vsel.."_Spd",util.round(util.clamp(params:get("V"..vsel.."_Spd")+(d*0.125),-2,2),0.125))
      elseif hsel==12 then                             --> panning-width
        params:set("V"..vsel.."_Pn",util.round(util.clamp(params:get("V"..vsel.."_Pn")+(d*0.05),0.0,1.0),0.01))
      elseif hsel==13 then                             --> softcut-voice volume
        params:set("V"..vsel.."_Vol",util.round(util.clamp(params:get("V"..vsel.."_Vol")+(d*0.05),0.0,2.0),0.01))
      elseif hsel==14 then                             --> live-looper cycle-length
        params:set("V"..vsel.."_Cyc",util.clamp(params:get("V"..vsel.."_Cyc")+d,1,32))
      end
    end
  end
  if(rdrw<1) then rdrw=1 end
end
                                                ----------
                                                -- KEYS --
function key(n,z)         --made this flagging system for double-key-combo to provide instantaneous trigger...
  if n==1 and z==1 then --(but makes for harder-to-follow code ;p, and k1-related-double-keyz need slight linger on k1 anyways)..
    oone=1 onne=1             --'onne' helps track for "k1 followed by k2", 'oone' helps track for 'k1 then k3'...
  elseif n==1 and z==0 then                     --'twoo' helps for 'k3 then k2', and 'two' helps for 'k2 then k3'...
    onne=util.clamp(onne-1,0,2) oone=util.clamp(oone-1,0,2)
  elseif n==2 and z==1 then
    if onne==1 then                                               --k1 followed by k2 decrements preset..
      if page<=2 then 
        params:set("SPre", util.wrap(params:get("SPre")-1,1,500)) --..(on page1)..
        sprenum=params:get("SPre")
      else                                                        --..(on page2)
        params:set("VPre", util.wrap(params:get("VPre")-1,1,500))
        vprenum=params:get("VPre")
      end onne=2
    elseif twoo==1 then                               --k3 followed by k2 toggles random echo/reverb
      if page==3 then 
        if hsel==3 then for i=1,6 do params:set("V"..i.."_LpNum",util.wrap(params:get("V"..i.."_LpNum")-1,1,8)) end
        elseif hsel==2 then sneakyrec(vsel) end
      else
        keytog=1-keytog
        if sel==2 then engine.rzset(rezpitchz[math.random(20)],0.22,0.28); engine.fxrtrz(1)
        else
          if keytog>0 then engine.dstset(math.random(1,6)*((tempo/60.)*0.03125),1) engine.fxrtrv(math.random(0,1)) 
          else engine.fxrtrv(0) end
          engine.fxrtds(keytog*2) 
        end 
      end twoo=2
    else two=1 end
  elseif n==2 and z==0 then                
    if onne==0 then
    if twoo==0 then
      if two<2 then
        if page==1 then
          if sel==-1 then --while playbutton is selected k2 can start/stop transport without reset..
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end 
            elseif params:string("clock_source")=="link" then 
              if go>0 then clock.link.stop() else clock.link.start() end
            end
          elseif sel==24 then spwrit("S_"..sprenum..".lki") --WARNING:WITH SEQ-PAGE PRESET SELECTED K2 SAVES TO FILE!!
          elseif sel==25 then mpwrit("M_"..params:get("MPre")..".lki")--WARNING:WITH MASTR PRESET SELECTED, K2 SAVES FILE!
          end
        elseif page==2 then
          if spel==-1 then --while playbutton is selected k2 can start/stop transport without reset..
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end
            elseif params:string("clock_source")=="link" then 
              if go>0 then clock.link.stop() else clock.link.start() end
            end
          elseif spel<4 then edit=1-edit --k2-up switches to edit-sequencer
          else fil=1-fil end
        else                                                        --softcut/alternate page
          if hsel==-1 then
            for i=1,6 do params:set("V"..i.."_Mod", params:get("V"..i.."_Mod")) end --safety measure 2 reset positions, etc. before..
            vpwrit("V_"..vprenum..".lki") --WARNING:WITH SoftCut-PAGE PRESET SELECTED, K2 SAVES FILE!
          elseif hsel==0 then
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end
            elseif params:string("clock_source")=="link" then 
              if go>0 then clock.link.stop() else clock.link.start() end
            end 
            tix=0 tixx=0
              for i=1,6 do voices[i]:rsync() end
          elseif hsel==1 then    --..or clears the buffer region if leftmost dot in top row of voice's screenUI is selected
                voices[vsel]:clear()
          else
            if params:get("V"..vsel.."_Mod")==1 then                              --Mode 1 = stutter
                params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go"))  --k2 turns stutter on/off
                if params:get("V"..vsel.."_Go")>0 then                      --clock turns rec off after 2-4beats
                params:set("V"..vsel.."_Rc",1) end
            elseif params:get("V"..vsel.."_Mod")==2 then                          --Mode 2 = Delay
              params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go"))   --k2 turns delay on/off
            else      --Mode 3 = Live Looper; k2 sets recording to start at beginning of next cycle...
              voices[vsel].prerec=2                     --..then stop-recording and start-play at cycle after that
      end end end end
    two=util.clamp(two-1,0,2)
    else twoo=util.clamp(twoo-1,0,2) end
    else onne=util.clamp(onne-1,0,2) end
  elseif n==3 and z==1 then
    if oone==1 then                       --k1 followed by k3 increments preset..
      if page<=2 then 
        params:set("SPre", util.wrap(params:get("SPre")+1,1,500)) --..(on main page)..
        sprenum=params:get("SPre")
      else                            
        params:set("VPre", util.wrap(params:get("VPre")+1,1,500)) --..(on softcut page)
        vprenum=params:get("VPre")
      end oone=2
    elseif two==1 then
      if page==1 then
        if lrn>0 then
            lrn=util.wrap(lrn+1,0,2)
          else
            if ((sel>=-1) and (sel<2)) then --page1:w/ tempo/transprt/swing selected, k2-down then k3-down(release same order)
              params:set("InMon", 1-params:get("InMon"))  --(un)mutes input monitor
            elseif sel>3 and sel<8 then       --otherwise, appropriate to column of params, chooses random files..
              for i=1,4 do selct[i] = math.random(#files[i]) engine.flex(i-1,fildir[i]..files[i][selct[i]]) end
            elseif sel>7 and sel<12 then  --..or randomly toggles 'drunk-walk thru files' option..
              for i=1,4 do params:set("S"..i.."_Dfl", math.random(2)-1) end
            elseif sel>11 and sel<16 then  --..or randomly toggles 'random sequence length' option..
              for i=1,4 do params:set("S"..i.."_Rln", math.random(2)-1) end
            elseif sel>15 and sel<20 then  --..or randomly toggles 'random cutoff' option..
              for i=1,4 do  params:set("S"..i.."_Stt", math.random(3)-1) end
            elseif sel>19 and sel<24 then  --..or randomly toggles random stutter option..
              for i=1,4 do params:set("S"..i.."_Rct", math.random(2)-1) end
            elseif sel==24 then params:set("VPre", util.wrap(params:get("SPre"),1,500)) end --..or with 'preset' selected,
        end                                                   --can sync the softcut-page preset number to this page's
      elseif page==2 then
        params:set("InMon", 1-params:get("InMon")) --(un)mutes input monitor
      else              --on softcut page, k2-down followed by k3-down switches "mode"(unless '•' is selected then "loop#")
        if hsel<=2 then params:set("InMon", 1-params:get("InMon")) -- or (un)mutes input monitor(with transport/preset selected)
        elseif hsel==3 then for i=1,6 do params:set("V"..i.."_LpNum",util.wrap(params:get("V"..i.."_LpNum")+1,1,8)) end
          else params:set("V"..vsel.."_Mod",util.wrap(params:get("V"..vsel.."_Mod")+1,1,3)) end
      end
      two=2
    else
      if page==1 and sel==3 then filsel=1 fileselect.enter(_path.audio,callback) else twoo=1 end
      if page==2 and spel==5 then filsel=1 fileselect.enter(_path.audio,callback) else twoo=1 end
    end
  elseif n==3 and z==0 then
    if oone==0 then
    if twoo<2 then
      if two==0 then
        if page==1 then                   --on the main page, k3 toggles parameter changes(on/off style)
          if sel==-9 then params:set("AT1",1-params:get("AT1"))
          elseif sel==-8 then params:set("AT2",1-params:get("AT2"))
          elseif sel==-6 then params:set("PT1",1-params:get("PT1")) 
            if params:get("PT1")>0 then pollf:start() else pollf:stop() end
          elseif sel==-5 then params:set("PT2",1-params:get("PT2")) 
            if params:get("PT2")>0 then pollr:start() else pollr:stop() end
          elseif sel==-4 then params:set("S_PRz",1-params:get("S_PRz"))
          elseif sel==-3 then prmfreez=1-prmfreez
          elseif sel==-2 then lrn=util.wrap(lrn+1,0,2)
          elseif sel==-1 then --while playbutton is selected k3 can start/stop transport with reset..
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end
            elseif params:string("clock_source")=="link" then 
              if go>0 then clock.link.stop() else clock.link.start() end
            end tix=0 tixx=0
              for i=1,6 do voices[i]:rsync() end
          elseif sel==1 then swuiflag=util.wrap(swuiflag+1,0,2) if swuiflag==1 then swim=params:get("Swng") end
          elseif sel==2 then 
            params:set("Fxv", 1-params:get("Fxv")) 
            if params:get("Fxv")<1 then engine.fxrtrz(0) engine.fxrtrv(0) engine.fxrtds(0) end
          elseif sel>3 and sel<8 then params:set("S"..(sel-3).."_Ply", 1-params:get("S"..(sel-3).."_Ply"))
          elseif sel>7 and sel<12 then params:set("S"..(sel-7).."_Dfl", 1-params:get("S"..(sel-7).."_Dfl"))
          elseif sel>11 and sel<16 then params:set("S"..(sel-11).."_Rln", 1-params:get("S"..(sel-11).."_Rln"))
          elseif sel>15 and sel<20 then 
            params:set("S"..(sel-15).."_Stt", util.wrap(params:get("S"..(sel-15).."_Stt")+1,0,2))
            if params:get("S"..(sel-15).."_Stt")==0 then pause[sel-15]=0 end
          elseif sel>19 and sel<24 then params:set("S"..(sel-19).."_Rct", 1-params:get("S"..(sel-19).."_Rct"))
          elseif sel==24 then
            spr=1-spr if spr>0 then params:set("SPre",sprenum) end --with preset selected k3 will toggle preset-'activate'
          else 
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go<1 then clock.transport.start() end
            elseif params:string("clock_source")=="link" then 
              if go<1 then clock.link.start() end
            end                                                 --while 'tempo' is selected, k3 can reset transport..
            tix=0 tixx=0 for i=1,6 do voices[i]:rsync() end --..or reset&start transport if stopped
          end
        elseif page==2 then
          if spel==-1 then
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end 
            elseif params:string("clock_source")=="link" then 
              if go>0 then clock.link.stop() else clock.link.start() end
            end tix=0 tixx=0
              for i=1,6 do voices[i]:rsync() end
          elseif spel==0 then params:set("S"..(spel+1).."_Ply", 1-params:get("S"..(spel+1).."_Ply"))
          elseif spel==1 then params:set("S"..(spel+1).."_Ply", 1-params:get("S"..(spel+1).."_Ply"))
          elseif spel==2 then params:set("S"..(spel+1).."_Ply", 1-params:get("S"..(spel+1).."_Ply"))
          elseif spel==3 then params:set("S"..(spel+1).."_Ply", 1-params:get("S"..(spel+1).."_Ply"))
          elseif spel>3 then for y=1,4 do params:set("S"..y.."_Ply", math.random(0,1)) end end
        else                    --on the alternate(softcut) page, k3 can..
          if hsel==-1 then 
            vpr=1-vpr if vpr>0 then params:set("VPre",vprenum) end  --toggle preset-'activate'..
          elseif hsel==0 then 
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end
            elseif params:string("clock_source")=="link" then 
              if go>0 then clock.link.stop() else clock.link.start() end
            end tix=0 tixx=0
              for i=1,6 do voices[i]:rsync() end
          elseif hsel==2 then voices[vsel].pfreez=1-voices[vsel].pfreez --..freeze params of this voice(to isolate preset changes)..
          elseif hsel>=3 and hsel<6 then --..or toggle playback for the softcut voice if the "•" at top of voice-page is selected..
            params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go"))
          elseif hsel==6 then params:set("V"..vsel.."_ALn",1-params:get("V"..vsel.."_ALn"))
          elseif hsel==7 then params:set("V"..vsel.."_PLn",1-params:get("V"..vsel.."_PLn"))
          elseif hsel==8 then params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go"))
          elseif hsel==9 then
            if params:get("V"..vsel.."_Mod")==3 then params:set("V"..vsel.."_Go",1-params:get("V"..vsel.."_Go"))
              else params:set("V"..vsel.."_APs",1-params:get("V"..vsel.."_APs")) end
          elseif hsel==11 then
            params:set("V"..vsel.."_ASp",1-params:get("V"..vsel.."_ASp"))
          elseif hsel==15 then
            params:set("V"..vsel.."_ARc",1-params:get("V"..vsel.."_ARc"))
          elseif hsel==16 then 
                poslfoz[vsel]:set('max', util.round((voices[vsel].ennd[voices[vsel].lpno]%58)/58.0,0.0001))
                poslfoz[vsel]:set('min', util.round((voices[vsel].strt[voices[vsel].lpno]%58)/58.0,0.0001))
                voices[vsel].plf=util.wrap(voices[vsel].plf+1,0,3) poslfoz[vsel]:set('depth', 1.0) --previously was needed to reset..
                if voices[vsel].plf == 0 then poslfoz[vsel]:stop()      --..depth everytime; this may be fixed now(unnecessary?)
                elseif voices[vsel].plf == 1 then poslfoz[vsel]:set('shape', 'random') lfprmult=0.25 poslfoz[vsel]:start()  
                elseif voices[vsel].plf == 2 then poslfoz[vsel]:set('shape', 'saw') lfprmult=0.75 poslfoz[vsel]:start()
                elseif voices[vsel].plf == 3 then poslfoz[vsel]:set('shape', 'sine') lfprmult=0.5 poslfoz[vsel]:start() end
        end end
      else two=util.clamp(two-1,0,2) end
    end
    twoo=util.clamp(twoo-1,0,2)
    else oone=util.clamp(oone-1,0,2) end
  end
  if(rdrw<1) then rdrw=1 end
end
                                            ------------------
                                            -- FILE SELECTA --
function callback(file_path)      --when 'fileselect' returns, process directory accordingly
  fildir[fildrsel]=_path.audio..string.sub(file_path,21,string.match(file_path, "^.*()/")) --store dirs
  files[fildrsel]=util.scandir(fildir[fildrsel]) filsel=0 --load names of files in dir to file-table/vox
end
                                  ------------------------------------
                                  -- Main triggering clock function --
function pop()         
  while true do
    clock.sync(0.25,(0.25*params:get("Swng"))*swflag)
    if (tix%2)==0 then                                                    -- 1/8th note
      out_midi:note_on(40,rndmidi,1)
      sofxvox()                                                           -- sofxvox = function to trigger softcut-voice actions
      if swuiflag==2 then -- if selected to, random-walk 'swing' within range of 'swing width(swidth)'
        local swdth=params:get("Swdth")
        params:set("Swng",util.clamp(params:get("Swng")+(math.random(-5,5)*0.01),swim-swdth,swim+swdth)) 
      end
      swflag = 1-swflag
    else  
      out_midi:note_on(40,0,1) 
      out_midi:note_off(40,127,1) 
    end
    if ((tix%4)==0) then
      rndmidi = math.random(24,127)
      fxv(params:get("Fxvc"),params:get("Fxv")) --random-clocked-changes to the 'FX Vortex'('fxv')
      for i=1,6 do sofxrec(params:get("V"..i.."_Cyc"),i) end  tixx = tixx + 1 -- tixx = 1/4 note
    end
    xox()                                   -- xox = function to trigger oneshot/file-sequencer
                                                              if rdrw<1 then rdrw=1 end
                                                              tix = tix + 1 -- tix = 1/16th NOTE
  end
end
                          ------------------------------------------------
                          -- One-shot/file xox-style sequencer function --
function xox()
  for i=1,4 do                                        
      if params:get("S"..i.."_Ply")>0 then
        local tp=params:get("S"..i.."_Stt") local sln=params:get("S"..i.."_Sln")
        local ntindx = util.wrap(tix,1,#seq[i]+sln) local nt=seq[i][ntindx]
        if pause[i]<1 then                            
          if nt>0 then                                 
            local ranspd=(math.random(-50,50)*0.002+1.0)        
            if nt>7 then ranspd = ranspd * -2.8 end --multiply speed for reverse(sped up for audibility(?))
            clock.run(enginstep,i,nt,ranspd) 
            if tp==2 then 
              if math.random(4)>3 then local rnm=math.random(16) pause[i]=1 clock.run(stutz,rnm,i,2) end
            elseif tp==1 then 
              if math.random(4)>3 then local rnm=math.random(12) pause[i]=1 clock.run(stutz,rnm,i,1) end end
          else
            if params:get("S"..i.."_Dfl")>0 then 
              if math.random(3)>2 then 
                selct[i] = util.clamp(selct[i]+((math.random(0,1)*2)-1),1,#files[i])
                engine.flex(i-1,fildir[i]..files[i][selct[i]])
            end end
          end
          if params:get("S"..i.."_Rln")>0 then 
            if math.random(2)>1 then params:set("S"..i.."_Sln", math.random(63)*-1) end end
  end end end
end
                      -- One-shot/file triggers(sent to the supercollider engine) --
function enginstep(vc,rp,sp)     --vc=voice, rp=repeats
  local ranfreq1=math.random(500,6500) local ranfreq2=math.random(5000)+2800.0 
  local rct=params:get("S"..vc.."_Rct") local vl=params:get("S"..vc.."_Svl") 
  local engins = {        --engine.awyea#(pan, speed, gain, cutoff-freq, release-time(sec))
    function()
      engine.awyea1(0.0,sp,vl, ranfreq1+((1-rct)*8388),1.0) grdbdn=15
    end, --no panning for kick drums
    function()
      engine.awyea2(math.random(-10,10)*0.01,sp,vl, ranfreq1+((1-rct)*8388),1.0) grdsnn=15 
    end,
    function()
      engine.awyea3(math.random(-50,50)*0.02,sp,vl, ranfreq2+((1-rct)*6088),1.0) grdhhn=15
    end,
    function()
      engine.awyea4(math.random(-50,50)*0.02,sp,vl, ranfreq1+((1-rct)*8388),1.0) grdxxn=15
    end }
  engins[vc]()                           --sequencer codes: 1 - 4 = that many hits per sixteenth
  if rp>1 and rp<5 then for i=1,(rp-1) do clock.sync(1/(4*rp)) engins[vc]() end
  elseif rp>4 and rp<8 then                                    --1.5 the repetition(more textural in sound)
    rp=math.random(1,5)+((rp-4)*1.5); for i=1,rp do clock.sync(1/(4*rp)) engins[vc]() end
  elseif rp>7 then                                                            --8-11 = reverse with repetition
    rp=math.random(0,1)+(rp-7); for i=1,(rp-1) do clock.sync(1/(4*rp)) engins[vc]() end
  end
end
              -- Clocked function for stutters applied (randomly if chosen) on oneshot/eng trigs --
function stutz(num,typ,tp)  
  local ranfreq1 = math.random(500,6500) local ranfreq2 = math.random(5000)+2800.0 
  local ranspd = math.random(-50,50)*0.002+1.0
  local geom local rdr=((math.random(2)-1)*2)-1 local rndy=math.random(3) local tmp=math.random(3)
  local vl,rct rct=params:get("S"..typ.."_Rct") vl=params:get("S"..typ.."_Svl") 
  local enginstuts = {
    function() engine.awyea1(0.0,ranspd,vl,ranfreq1+((1-rct)*8388),0.25) end,
    function() engine.awyea2(math.random(-10,10)*0.01,ranspd,vl, ranfreq1+((1-rct)*8388),0.25) end,
    function() engine.awyea3(math.random(-50,50)*0.02,ranspd,vl, ranfreq2+((1-rct)*6088),0.25) end,
    function() engine.awyea4(math.random(-50,50)*0.02,ranspd,vl, ranfreq1+((1-rct)*8388),0.25) end}
  if rdr>0 then geom=0 else geom=num end 
  for i=1,num do
    if tp==2 then
      if num>6 then--if incoming 'num' is greater than 8 do a 'geometric series' style of stutter(accelerando/deccelerando)..
        if rndy==3 then clock.sleep(math.pow(((1/tmp)*15)/tempo,0.09375*i)+0.02)
          elseif rndy==2 then clock.sleep(math.pow(((1/tmp)*15)/tempo,0.09375*(num-(i-1)))+0.01)
          else clock.sleep(1/((num+1)/((num+1)-geom))+0.02) end             
        enginstuts[typ]() geom=geom+(rdr*(1/math.random(4))) 
      else clock.sync(1/(num+2)) enginstuts[typ]() end --..otherwise do a regular stutter
    elseif tp==1 then clock.sync(1/(num+2)) enginstuts[typ]() end --regular stutters only
    if i==num then pause[typ]=0 end
  end
end
                                  ---------------------------------------------
                                  -- Softcut voices stutter trigger function --
function sofxvox()
  for i=1,6 do
    if params:get("V"..i.."_Go")>0 then
      local pnabausch=params:get("V"..i.."_Pn") local btsprbar = params:get("V"..i.."_Cyc") local txx = voices[i].tixx
      local phs=(math.random(0,util.round(btsprbar*0.25,1)) + txx)/btsprbar;
      if pnabausch>0 then softcut.pan(i,(math.random(-50,50)*0.02)*pnabausch) end  --(apply random panning)
      if params:get("V"..i.."_Mod")==3 then                                        -- if in looper mode..
        local imptnz=params:get("V"..i.."_Impatnz")
        if ((params:get("V"..i.."_Rc")==0) and (imptnz~=0) and --..and 'impatient'..
          ((voices[i].lpcount>imptnz) or (voices[i].lpcount<0)) and (voices[i].looplay>0) and (voices[i].busy<1)) then
          local rndy=math.random(2) local tmp=math.random(3,12)*2 local num=math.random(8,24) voices[i].busy=1
          clock.run(vstutz,phs,i,rndy,tmp,num) --..improvise automated/randomized playback/stuttering 
  end end end end
end
                      -- Clocked function for stutters applied on the softcut/looper voices --
function vstutz(phs,vc,rndy,tmp,num)
  local ofst=params:get("V"..vc.."_Ofst") local btsprbr=params:get("V"..vc.."_Cyc")
  local ntlensc=15/params:get("clock_tempo") 
  for i=1,num do
    if i>=(num-1) then voices[vc].busy=0
    else
      local tymex
      if ((num>19) and (num<32)) then     --if incoming 'num'>10 do 'geometric series' style of stutter(accel/deccel)..
        if rndy==2 then tymex = math.pow((1/tmp*2)*ntlensc,1.1) else tymex = math.pow(1/(tmp*3)*ntlensc,0.88) end clock.sleep(tymex)
      elseif num<20 then                          --..otherwise do a regular stutter
        if rndy==2 then tymex = 1/tmp*2 else tymex = 1/(tmp*4) end clock.sync(tymex)
      end
    end
    params:set("V"..vc.."_Phase",phs)
  end
end
                                  -- Softcut voices recording and playback function --
function sofxrec(btsprbar,i)  --automated control over recording/playback progression of live-looper(or over punch in/out of delay)
  voices[i].tixx = (voices[i].tixx%btsprbar) + 1
  if poslfoz[i]:get('enabled') == 1 then if math.random(2)>1 then poslfoz[i]:set('period', math.random(2,16)*lfprmult) end end
  if params:get("V"..i.."_Mod")==3 then                          --if in looper mode..
    if (voices[i].busy<1) then params:set("V"..i.."_Phase",voices[i].tixx/btsprbar) end
    if voices[i].tixx == 1 then  --the 'Cyc'('Bar') param is how many beats-per-bar to capture of loop
      if voices[i].prerec == 2 then params:set("V"..i.."_Rc",1) end   --..count off progression towards loop-capture..
      if params:get("V"..i.."_Rc")>0 then 
        if voices[i].prerec>1 then voices[i].prerec=voices[i].prerec-1  --..finish recording..
        else                                                  
          voices[i].prerec=voices[i].prerec-1               --..then stop rec and start play..
          params:set("V"..i.."_Rc",0) params:set("V"..i.."_Phase",0) params:set("V"..i.."_Go",1) 
        end
      else 
        if params:get("V"..i.."_Impatnz")>0 then voices[i].lpcount=voices[i].lpcount+1 end   --..if playing, countoff 'impatienz'
        if voices[i].looplay>0 then params:set("V"..i.."_Phase",0) params:set("V"..i.."_Go",1) end --restart each new bar
      end
    end
  elseif params:get("V"..i.."_Mod")==2 and params:get("V"..i.."_Go")>0 then   -- elseif in delay mode..
    params:set("V"..i.."_Rc",util.clamp(math.random(5)-2,0,1)) --random chance of 3/5 that delay turns on every bar
  end
end
                                        ------------------------
                                        -- FX Vortex function --
function fxv(fxvc,fxvt)
  if fxvc>0 then            if (tixx%fxvc)==0 then                if fxvt>0 then
    local chs=math.random(1,3); if math.random(2)>1 then keytog=1-keytog end
    if chs==1 then
      engine.dstset(math.random(1,6)*((tempo/60.)*0.03125),1) engine.fxrtds(keytog) --sets random delay, and routes delay
    elseif chs==2 then engine.rzset(rezpitchz[math.random(20)],0.22,0.28); engine.fxrtrz(keytog) --random pitch, routes rezon8r
    elseif chs==3 then engine.fxrtrv(keytog) end --routes reverb
  end end end
end
  
function cleanup() engine.darknez() end
