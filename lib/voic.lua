Voic = {} -- class for organizing softcut voice into 'modes' of operation(stutter, echo, looper...)

audio.level_eng_cut(1.0) audio.level_adc_cut(1.0) ampll=0 -- ampll extends 'hysteresis'..
function pllpset(pll) ampll=pll if ampll<1 then clock.run(pollpaus,params:get("ATr")) params:set("ATr",1) end end
function pollpaus(art) clock.sleep(0.1) params:set("ATr",art) end --..by setting amp-detection threshold, for 100ms,..
   --..at a value too high for detection(1), before going back to normal/specified threshold(to reduce false triggers)

function delmap(num) return math.floor((num-1)/2)*116.0 end --'delay map': maps voice numbers to time in buffer for that..
 --..particular voice's delay-specific start of buffer(v1&2=0 v3&4=116 v5&6=232; +58=offset into buffer for stutter/looper)
 
function epos(indx,pstn) 
  voices[indx].ennd[voices[indx].lpno]=pstn if voices[indx].lpno<8 then voices[indx].strt[voices[indx].lpno+1]=pstn end
end

function recstut(num,idx) clock.sync(num) params:set("V"..idx.."_Rc",0) end --4 auto/short-length recording into stutter

function strtnd(num,lnth)
  local strt,nd
  local tmp=params:get("clock_tempo")
  if voices[num].mde==1 then
    local qt=(60.0/tmp)
    local lnthqt=qt*lnth
    local phs=params:get("V"..num.."_Phase")
    strt = voices[num].strt[voices[num].lpno]+(voices[num].prvstp*qt)+(phs*lnthqt) nd = strt+(lnthqt)
  elseif voices[num].mde==3 then strt = voices[num].strt[voices[num].lpno] nd = voices[num].ennd[voices[num].lpno]
  else strt = delmap(num) nd = delmap(num)+(tmp*lnth) end
  return strt,nd
end

function Voic:new(num)
  local v = setmetatable({}, { __index = Voic })
  v.num=num  v.mde=1 v.spd=1 v.vol=1 v.bar=8 v.looplay=0 v.busy=0 v.lpcount=1 v.prerec=0 v.pl=0 v.rc=0 v.pfreez=0 v.pg=0
  v.lpno=1 v.tixx=0 v.prvstp=0 v.plf=0
  v.strt={delmap(num)+58,delmap(num)+58,delmap(num)+58,delmap(num)+58,delmap(num)+58,delmap(num)+58,delmap(num)+58,delmap(num)+58} 
  v.ennd={delmap(num)+116,delmap(num)+116,delmap(num)+116,delmap(num)+116,delmap(num)+116,delmap(num)+116,delmap(num)+116,delmap(num)+116} 
  softcut.enable(v.num,1) softcut.buffer(v.num,((v.num-1)%2)+1) softcut.loop(v.num,1) --setup softcut
  softcut.rec_level(v.num,1.0)  softcut.level(v.num,1.0) softcut.rate(v.num,1.0) softcut.pan(v.num,(v.num%2)*2-1) 
  softcut.level_input_cut(((v.num-1)%2+1),v.num,1.0) softcut.fade_time(v.num,0.002) softcut.pan_slew_time(v.num,0.05)
  softcut.rate_slew_time(v.num,0.01) softcut.level_slew_time(v.num,0.01) softcut.recpre_slew_time(v.num,0.01)
  v.strt[1]=delmap(v.num)+58.0 v.ennd[1]=delmap(v.num)+116.0 
  return v
end

-- Da PFunk (Parameter-based functions *nerd-face*)
function Voic:mode(mde) -- mode1 = stutter, mode2 = delay(echo), mode3 = looper
  local ststrt, stend, lenth; lenth=params:get("V"..self.num.."_Len")
  self.prvmde = self.mde self.lpcount=0 self.mde = mde ststrt,stend=strtnd(self.num,lenth)
  if self.mde==3 then softcut.rec(self.num,0) softcut.loop(self.num,0)
  else
    softcut.loop(self.num,1) 
    if self.mde==1 then self.prvstp=self.tixx params:set("V"..self.num.."_Phase",0.0) end
  end
  softcut.pre_level(self.num,params:get("V"..self.num.."_Fbk")) softcut.position(self.num,ststrt)
  softcut.loop_start(self.num,ststrt) softcut.loop_end(self.num,stend)
end

function Voic:go(ply) -- play
  local ststart=strtnd(self.num,params:get("V"..self.num.."_Len")) self.pl = ply
  if self.mde == 3 then self.looplay=ply self.lpcount=1 end softcut.position(self.num,ststart) 
  if self.mde ~= 2 then softcut.play(self.num,self.pl) else softcut.play(self.num,1) end
end

function Voic:rsync() self.tixx=tixx end

function Voic:rec(rc) -- record
  local tmp = 60.0/(params:get("clock_tempo")) local lenth = params:get("V"..self.num.."_Len")
  local str,nd = strtnd(self.num,lenth) self.rc = rc
  if self.mde==3 then
    local strtndx=self.strt[self.lpno]
    if rc>0 then 
      pllpset(1) softcut.position(self.num,strtndx) self.lpcount=rc softcut.rec(self.num,rc) softcut.rec_level(self.num,rc)
    else softcut.query_position(self.num) softcut.rec_level(self.num,0) softcut.rec(self.num,0) end
  elseif self.mde==1 then
    if self.rc>0 then
      softcut.rec(self.num,1) softcut.rec_level(self.num,1) clock.run(recstut,lenth*1.2,self.num) pllpset(1)
      softcut.position(self.num,str-0.004) softcut.loop_start(self.num,str-0.004) softcut.loop_end(self.num,nd) 
    else softcut.rec_level(self.num,0) softcut.rec(self.num,0) end
  else if self.rc>0 then pllpset(1) end softcut.rec(self.num,1) softcut.rec_level(self.num,self.rc) end
end

function Voic:length(lnth)   --only applicable to stutter(1) and delay(2) modes
  local str,nd=strtnd(self.num,lnth)
  softcut.loop_start(self.num,str) softcut.loop_end(self.num,nd)
end

function Voic:lninsec(lnth)   --only applicable to stutter(1) and delay(2) modes
  local offst local phs = params:get("V"..self.num.."_Phase")
  if self.mde==2 then offst=delmap(self.num)
  elseif self.mde==1 then offst = delmap(self.num)+58.0+(phs*(self.ennd[self.lpno]-self.strt[self.lpno])) end
  softcut.loop_start(self.num,offst)  softcut.loop_end(self.num,lnth+offst)
end

function Voic:phas(phs)    --only applicable to stutter(1) and looper(3) modes
  local ststart,tmpo,lenth,btsprbr;  qtntsec=60.0/params:get("clock_tempo")
  lenth=(qtntsec)*params:get("V"..self.num.."_Len")  btsprbr=params:get("V"..self.num.."_Bar")
  if self.mde==3 then
    ststart=self.strt[self.lpno]+(qtntsec*btsprbr*phs)
  elseif self.mde==1 then
    local rootphs=self.prvstp
    ststart = self.strt[self.lpno]+(qtntsec*rootphs)+(phs*lenth)
    softcut.loop_start(self.num,ststart)  softcut.loop_end(self.num,ststart+lenth)
  else 
    ststart,btsprbr=delmap(self.num) 
    ststart=ststart+(phs*lenth) 
    softcut.loop_start(self.num,ststart)  
    softcut.loop_end(self.num,ststart+lenth) 
  end
  softcut.position(self.num,ststart)
end

function Voic:speed(spd) self.spd = spd softcut.rate(self.num,self.spd) end

function Voic:gain(vol) self.vol = vol softcut.level(self.num,self.vol) end

function Voic:clear()
  if self.num<3 then softcut.buffer_clear_region_channel(self.num,0,116,0.01,0.0) 
  elseif ((self.num>2) and (self.num<5)) then softcut.buffer_clear_region_channel(self.num-2,116,232,0.01,0.0)
  else softcut.buffer_clear_region_channel(self.num-4,232,348,0.01,0.0) end
end

function Voic:inputselect(inz, itbl)
  local itabl = itbl
  if inz==1 then
    audio.level_eng_cut(1) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[1],self.num,0.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==2 then
    audio.level_eng_cut(0) audio.level_adc_cut(1) 
    softcut.level_input_cut(1,self.num,1.4) softcut.level_input_cut(2,self.num,0.0)
    softcut.level_cut_cut(itabl[1],self.num,0.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==3 then
    audio.level_eng_cut(0) audio.level_adc_cut(1) 
    softcut.level_input_cut(2,self.num,1.4) softcut.level_input_cut(1,self.num,0.0)
    softcut.level_cut_cut(itabl[1],self.num,0.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==4 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[1],self.num,1.0) softcut.level_cut_cut(itabl[2],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==5 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[2],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[3],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0) 
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==6 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[3],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[2],self.num,0.0) softcut.level_cut_cut(itabl[4],self.num,0.0)
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==7 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[4],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[2],self.num,0.0) softcut.level_cut_cut(itabl[3],self.num,0.0)
    softcut.level_cut_cut(itabl[5],self.num,0.0)
  elseif inz==8 then
    audio.level_eng_cut(0) audio.level_adc_cut(0) 
    softcut.level_cut_cut(itabl[5],self.num,1.0) softcut.level_cut_cut(itabl[1],self.num,0.0)
    softcut.level_cut_cut(itabl[2],self.num,0.0) softcut.level_cut_cut(itabl[3],self.num,0.0) 
    softcut.level_cut_cut(itabl[4],self.num,0.0)
  end
end
