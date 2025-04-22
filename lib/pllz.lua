pollf = poll.set("amp_in_l") pollr = poll.set("amp_in_r")   --setup polls
pchlf = poll.set("pitch_in_l") pchrt = poll.set("pitch_in_r")

pollf.callback = function(val)                                          --poll left                    
  for i=1,6 do                                                    
    if params:get("AT1")>0 then                
      if val>params:get("ATr") and ampll<1 then     --"ampll" is an attempt to extend 'hysteresis'..
        if params:get("V"..i.."_ARc")>0 then          --..for less chance of false-retrigger(see voic.lua)
          if params:get("V"..i.."_Mod")==3 then 
            voices[i].prerec=2 params:set("AT1",0) 
          else params:set("V"..i.."_Rc",1) end 
        end
        if params:get("V"..i.."_ALn")>0 then
          if params:get("V"..i.."_Mod")==3 then voices[i].prerec=2 voices[i].lpcount=1 
          else params:set("V"..i.."_Len",(math.random(64)*2)*0.0078125) end             --minimum of 1/128th note
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

pollr.callback = function(val)                                          --poll right
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
