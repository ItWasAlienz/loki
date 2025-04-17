                                          ------------
function enc(n,d)                         --ENCODERS--
  if n==1 then                                --enc1 switches pages(unless softcut page's 'cycles' param is selected)
    if page==3 and hsel==14 then params:set("V"..vsel.."_Ofst", params:get("V"..vsel.."_Ofst")+d)
    elseif page==3 and lfop>0 then lsel = util.wrap(lsel+d,1,7)
      else page=util.wrap(page+d,1,3) end         
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
        else if lfop>0 then psel=util.wrap(psel+d,1,2) 
          else hsel=util.wrap(hsel+d,-1,16) end end --on softcut page, enc2 selects params
      --if hsel==0 then ply.active=true else ply.active=false end
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
          if fildir[((spel)%4)+1]~=0 then
          selct[((spel)%4)+1] = util.clamp(selct[((spel)%4)+1]+d,1,#files[((spel)%4)+1])
          engine.flex(((spel)%4),fildir[((spel)%4)+1]..files[((spel)%4)+1][selct[((spel)%4)+1]]) end
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
      elseif hsel==16 then
        if lfop>0 then
          if lsel==1 then 
            if psel==1 then params:set("V"..vsel.."_PLFO",util.wrap(params:get("V"..vsel.."_PLFO")+d,1,7))
              else poslfoz[vsel]:set('period',util.round(poslfoz[vsel]:get('period')+(d*0.125),0.125)) end
          elseif lsel==2 then
            if psel==1 then params:set("V"..vsel.."_LLFO",util.wrap(params:get("V"..vsel.."_LLFO")+d,1,7))
              else lenlfoz[vsel]:set('period',util.round(lenlfoz[vsel]:get('period')+(d*0.125),0.125)) end
          elseif lsel==3 then
            if psel==1 then params:set("V"..vsel.."_SLFO",util.wrap(params:get("V"..vsel.."_SLFO")+d,1,7))
              else spdlfoz[vsel]:set('period',util.round(spdlfoz[vsel]:get('period')+(d*0.125),0.125)) end
          elseif lsel==4 then
            if psel==1 then params:set("V"..vsel.."_FLFO",util.wrap(params:get("V"..vsel.."_FLFO")+d,1,7))
              else fbklfoz[vsel]:set('period',util.round(fbklfoz[vsel]:get('period')+(d*0.125),0.125)) end
          elseif lsel==5 then
            if psel==1 then params:set("V"..vsel.."_CLFO",util.wrap(params:get("V"..vsel.."_CLFO")+d,1,7))
              else flclfoz[vsel]:set('period',util.round(flclfoz[vsel]:get('period')+(d*0.125),0.125)) end
          elseif lsel==6 then
            if psel==1 then params:set("V"..vsel.."_QLFO",util.wrap(params:get("V"..vsel.."_QLFO")+d,1,7))
              else flqlfoz[vsel]:set('period',util.round(flqlfoz[vsel]:get('period')+(d*0.125),0.125)) end
          end
        else lfop = util.wrap(lfop+d,0,1)
        end
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
          elseif hsel==16 then
            if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
              if go>0 then clock.transport.stop() else clock.transport.start() end
            elseif params:string("clock_source")=="link" then 
              if go>0 then clock.link.stop() else clock.link.start() end
            end 
            tix=0 tixx=0 for i=1,6 do voices[i]:rsync() end
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
              for i=1,4 do if fildir[i]~=0 then selct[i] = math.random(#files[i]) engine.flex(i-1,fildir[i]..files[i][selct[i]]) end end
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
            end 
            tix=0 tixx=0 for i=1,6 do voices[i]:rsync() end
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
          elseif hsel==16 then lfop = 1-lfop
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
  params:lookup_param("S"..fildrsel.."_Fil").controlspec.maxval = #files[fildrsel]
end
