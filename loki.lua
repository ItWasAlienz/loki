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
kne=include 'lib/keyz_n_encz' 
if (util.file_exists(_path.audio.."common/808/808-BD.wav") == true) then
fildir={_path.audio.."common/808/",_path.audio.."common/808/",_path.audio.."common/808/",_path.audio.."common/808/"} 
else fildir={0,0,0,0}
end
fildrsel=1 filsel=0 sel=-1 sl=1 spel=1 vsel=1 hsel=-1 lsel=1 psel=1 lfop=0 edit=0 page=1 uipag=0 spr=0 vpr=0 mpr=0 
rdr=0 rdrw=0 go=0 tix=0 tixx=0 keytog=0 fil=0 tempo=0 sprenum=1 vprenum=1 lrn=0 strb=0 rndmidi=127
swuiflag=0 swim=0.0 swflag=0 prmfreez=0 voices={} for i=1,6 do table.insert(voices,Voic:new(i)) end 
gridbd={4,4} gridsn={12,4} gridhh={8,8} gridxx={8,12} --1st grid page sizes and starting positions
selct={1,1,1,1} pause={0,0,0,0} oone=0 onne=0 two=0 twoo=0 --file-'sel'(index), stutter-busy('pause's) and double-press flags
files = {} seq =        --files/sequencer vals for 4-piece kit(4 voices of 'PlayBuf' in supercollider layer)
{{1,0,0,1,0,1,0,0,0,1,0,0,1,0,1,0,1,0,0,1,0,1,0,0,1,0,0,0,1,0,2,0,1,0,0,0,2,1,0,1,0,1,0,0,3,0,1,0,1,0,2,0,0,1,0,0,0,1,0,0,5,0,4,2}, 
  {0,0,1,0,0,0,1,0,0,0,0,1,0,2,0,0,0,0,1,0,0,0,1,0,0,0,0,3,0,1,0,0,0,0,1,0,0,0,1,0,0,0,0,1,0,2,0,0,0,0,1,0,0,0,1,0,2,0,1,0,0,1,0,0}, 
  {1,0,2,0,1,3,1,0,1,0,1,2,1,0,1,0,1,0,2,0,2,3,1,0,1,0,8,2,1,0,1,0,1,0,2,0,1,3,1,0,1,0,1,2,1,0,1,0,1,0,2,0,5,3,1,0,8,0,1,2,7,0,1,0},
  {0,0,0,1,0,1,0,0,1,0,1,0,0,1,1,0,0,0,0,1,0,3,0,0,1,0,1,0,0,5,2,0,0,0,0,1,0,1,0,0,3,0,1,0,0,1,1,0,0,0,0,1,0,1,0,0,1,0,1,0,0,1,1,0}}

function init()
  out_midi = midi.connect(1)
  tempo=params:get("clock_tempo")
  for i=1,4 do                                                              --register file directories & load files
    if (fildir[i] ~= 0) then files[i]=util.scandir(fildir[i]) if (files[i] ~= nil) then engine.flex(i-1,fildir[i]..files[i][1]) end end
  end
  polllz=include 'lib/pllz' --polls(these first for dependencies)
  sparm=include 'lib/sparamz' vparm=include 'lib/vparamz' miid=include 'lib/miid' --params + MIDI PgCh
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
                if (fildir[i]~=0) then
                selct[i] = util.clamp(selct[i]+((math.random(0,1)*2)-1),1,#files[i])
                engine.flex(i-1,fildir[i]..files[i][selct[i]])
            end end end
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
              -- Clocked function for stutters applied (randomly if chosen) on oneshot/engine trigs --
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
                                   -- Softcut voices main trigger function --
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
                  -- Child/Spawned clock function for stutters applied on the softcut/looper voices --
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
