--grid stuff
local grd = grid.connect(); 
grdbdn=0 grdsnn=0 grdhhn=0 grdxxn=0 grdpg=1 valslx=1 valslv=1 
sqslctd=0 maxlen=0 prevlen=-64 lenslct=0 keycount=0 lnm={0,0,0,0,0,0} --softcut-page beats-per-bar-modifier-key flags
vmod=1 rmod=0 smod=0 omod=0 xmod=0 --vmod = games; rmod = record-modifier-key; smod = softcut paramview
                                --omod = offset playback position mode; xmod = xtra-modifier-key
if grd.device then 
  rw=grd.device.rows; cl=grd.device.cols
  sparkly=include 'lib/sparkly' sprklz={}
  for i=1,6 do table.insert(sprklz,Sparkly:new(i,1,rw,cl,grd)) end
end

function grdraw()
  local countitup=0
  grd:all(0) grd:led(1,1,go*11+4) grd:led(15,1,params:get("InMon")*11+4)
  if grdpg==1 then
    for w=1,4 do countitup=countitup + params:get("S"..w.."_Ply") end 
    if countitup==0 then
      local cfst,rfst
      if cl>8 then cfst=4 else cfst=1 end
      if rw>8 then rfst=4 else rfst=1 end 
      if (tix%4)<=1 then
        for i=1,8 do for j=1,8 do 
          if i==1 then if ((j>3) and (j<6)) then grd:led(j+cfst,i+rfst,(1-(tix%2))*10+5) end 
          elseif i==2 then if ((j>1) and (j<8)) then grd:led(j+cfst,i+rfst,(1-(tix%2))*10+5) end
          elseif ((i>2) and (i<5)) then grd:led(j+cfst,i+rfst,(1-(tix%2))*10+5) 
          elseif ((i>4) and (i<7)) then if ((j>1) and (j<8)) then grd:led(j+cfst,i+rfst,(1-(tix%2))*10+5) end
          elseif i==7 then if ((j>2) and (j<7)) then grd:led(j+cfst,i+rfst,(1-(tix%2))*10+5) end
          elseif i==8 then if ((j>3) and (j<6)) then grd:led(j+cfst,i+rfst,(1-(tix%2))*10+5) end
          end
        end end
        --[[for ex=1,cl do
          grd:led(util.clamp(ex+1,2,15), util.clamp(ex%rw,2,15), (1-(tix%2))*6+9) --<-in case you'd prefer:..
          grd:led(util.clamp(cl-ex,2,15),util.clamp(ex%rw,2,15),(1-(tix%2))*6+9)    --..draws a big square
        end]]--
      else 
        for i=1,8 do for j=1,8 do
          if i==1 then if ((j>3) and (j<6)) then grd:led(j+cfst,i+rfst,0) end 
          elseif i==2 then if ((j>1) and (j<8)) then grd:led(j+cfst,i+rfst,0) end
          elseif ((i>2) and (i<5)) then grd:led(j+cfst,i+rfst,0) 
          elseif ((i>4) and (i<7)) then if ((j>1) and (j<8)) then grd:led(j+cfst,i+rfst,0) end
          elseif i==7 then if ((j>2) and (j<7)) then grd:led(j+cfst,i+rfst,0) end
          elseif i==8 then if ((j>3) and (j<6)) then grd:led(j+cfst,i+rfst,0) end
          end 
        end end
      end
    else
      if grdbdn>=14 then for i=-1,1 do for j=-1,1 do grd:led(gridbd[1]+i,gridbd[2]+j,15) end end end
      grd:led(gridbd[1],gridbd[2],util.clamp(grdbdn,0,15))
      if grdsnn>=14 then for i=-2,2 do for j=-2,2 do grd:led(gridsn[1]+i,gridsn[2]+j,15) end end end
      grd:led(gridsn[1],gridsn[2],util.clamp(grdsnn,0,15))
      grd:led(gridhh[1],gridhh[2],util.clamp(grdhhn,0,15))
      if grdxxn>=14 then for i=-1,1 do for j=-2,2 do grd:led(gridxx[1]+i,gridxx[2]+j,15) end end end
      grd:led(gridxx[1],gridxx[2],util.clamp(grdxxn,0,15))
    end
  elseif grdpg==2 then pag2(0) if rw>8 then pag3(8) end
  else pag3(0) if rw>8 then pag2(8) end end
  grd:refresh()
end

function grd.key(x,y,z)
  if z==1 then
    if y==1 then
      if x==1 then
        if params:string("clock_source")=="internal" or params:string("clock_source")=="crow" then
          if go>0 then clock.transport.stop() else clock.transport.start() end 
        elseif params:string("clock_source")=="link" then 
          if go>0 then clock.link.stop() else clock.link.start() end
        end tix=0 tixx=-1
          for i=1,6 do voices[i]:rsync() sprklz[i]:go(0) end
      elseif x==(cl-1) then params:set("InMon",1-params:get("InMon"))
      elseif x==cl then
        grdpg=util.wrap(grdpg+1,1,3); page=grdpg
      end
    end
    if grdpg==1 then
      if (((y~=1) and (x~=1)) or ((y~=1) and (x~=15))) then
        if x<9 then keytog=1-keytog
          if keytog>0 then engine.dstset(x*((tempo/60.)*0.03125),1) engine.fxrtrv(math.random(0,1))
          else engine.fxrtrv(0) end engine.fxrtds(keytog*2)
        else engine.rzset(rezpitchz[math.random(20)],0.2,0.2); engine.fxrtrz(math.random(2)-1) end
      end
    elseif grdpg==2 then
      if y<9 then pag2keyz(x,y,z,0) elseif y>8 then pag3keyz(x,y,z,8) end
    elseif grdpg==3 then
      if y<9 then pag3keyz(x,y,z,0) elseif y>8 then pag2keyz(x,y,z,8) end
    end
  else
    if grdpg==2 then
      if y<9 then pag2keyzoff(x,y,z,0) elseif y>8 then pag3keyzoff(x,y,z,8) end
    elseif grdpg==3 then
      if y<9 then pag3keyzoff(x,y,z,0) elseif y>8 then pag2keyzoff(x,y,z,8) end
    end
  end
  grd:led(x,y,z*15) grd:refresh() rdrw=1
end

function pag2(rwoffst)
  for k=1,4 do
    local slen=params:get("S"..k.."_Sln") maxlen=math.max(slen, prevlen) prevlen=slen
    local coutn = util.wrap(tix,1,64+slen)
    for i=1,util.clamp((#seq[k]+slen),1,16) do
      for g=1,16 do
        if params:get("S"..k.."_Ply")>0 then
          local brt 
          if ((64+slen)<=16) then brt=15
          elseif ((coutn > (uipag*16)) and (coutn <= ((uipag+1)*16))) then 
            brt = 15 else brt = 6 end
          grd:led(util.wrap(coutn,1,16),(k+2)+rwoffst,brt) 
        else grd:led(util.wrap(coutn,1,16),(k+2)+rwoffst,4) end
        if (g+(uipag*16)) <= (#seq[k]+slen) then 
          if seq[k][g+(uipag*16)]>0 then grd:led(g,(k+2)+rwoffst,8) end 
        end
      end
    end
  end
  grd:led(6,1+rwoffst,params:get("PT1")*10+5) grd:led(7,1+rwoffst,params:get("S_PRz")*10+5) 
  grd:led(8,1+rwoffst,params:get("PT2")*10+5) grd:led(9,1+rwoffst,prmfreez*12+3)
  for i=1,4 do 
    grd:led(i,7+rwoffst,params:get("S"..i.."_Dfl")*8+7) 
    grd:led(i+12,7+rwoffst,params:get("S"..i.."_Rct")*8+7)
    grd:led(i+6,7+rwoffst,params:get("S"..i.."_Stt")*4+3)
  end
  grd:led(5,8+rwoffst,params:get("AT1")*10+5) 
  grd:led(6,8+rwoffst,spr*10+5) grd:led(11,8+rwoffst,vpr*10+5) 
  grd:led(12,8+rwoffst,params:get("AT2")*10+5)
  grd:led(util.round((((tix-1)%(64+maxlen))/16)+0.5,1)+1,1+rwoffst,15) prevlen=-64 
  if lenslct>0 then  
    for i=1,4 do 
      if i==lenslct then grd:led(lenslct+9,1+rwoffst,10+(5*params:get("S"..lenslct.."_Ply"))) 
        else grd:led(i+9,1+rwoffst,4+(4*params:get("S"..i.."_Ply"))) end 
    end
  end                          for i=1,4 do grd:led(i+12,8+rwoffst,params:get("S"..i.."_Ply")*15) end
end

function pag3(rwoffst)          -- PAGE 3: SOFTCUT GAMES!! :D (for now, just 'mystical sparkly' sequencer)
  grd:led(15,2+rwoffst,(vmod*3)+3) grd:led(8,1+rwoffst,(rmod*8)+7) grd:led(8,2+rwoffst,(smod*8)+7)
  grd:led(1,2+rwoffst,(omod*5)+5) grd:led(16,2+rwoffst,(xmod*8)+7)
  for i=1,6 do 
    local flg; if ((voices[i].prerec>0) or (voices[i].rc>0)) then flg=1 else flg=0 end
    grd:led(i+8,1+rwoffst,flg*15) grd:led(i+8,2+rwoffst,voices[i].rc*15) grd:led(i+1,2+rwoffst,lnm[i]*4+3)
    grd:led(i+1,math.floor(voices[i].tixx/16)+1+rwoffst,voices[i].pl*11+4)
  end
  if smod>0 then
    grd:led(1+vsel,1+rwoffst,15)
    for i=1,16 do 
      local spd=params:get("V"..vsel.."_Spd")
      if params:get("V"..vsel.."_Mod")<3 then
        if (params:get("V"..vsel.."_Len")*16)>=i then grd:led(i,3+rwoffst,15) end
        if (params:get("V"..vsel.."_Phase")*16+1)>=i then grd:led(i-1,4+rwoffst,0) grd:led(i,4+rwoffst,15) end
      else
        if (params:get("V"..vsel.."_Impatnz")+2)>=i then grd:led(i,3+rwoffst,15) end
        if (params:get("V"..vsel.."_LpNum")*2)>=i then 
          for j=1,14 do grd:led(i-1-j,4+rwoffst,0) end grd:led(i,4+rwoffst,15) end
      end
      if spd>=0 then if ((spd*4) >= (i-8)) then grd:led(i,5+rwoffst,15) for j=1,7 do grd:led(j,5+rwoffst,0) end end
      else 
        if ((spd*4) <= (i-8)) then grd:led(i,5+rwoffst,15) for j=1,8 do grd:led(j+8,5+rwoffst,0) end end 
      end
      if (params:get("V"..vsel.."_Fbk")*16)>=i then grd:led(i,6+rwoffst,15) end
      if params:get("V"..vsel.."_In")>=i then grd:led(i-1,8+rwoffst,0) grd:led(i,8+rwoffst,15) end
    end
  else
    if vmod==1 then for i=1,6 do sprklz[i]:drw(rwoffst,grd) end
    elseif vmod==2 then
    elseif vmod==3 then
    elseif vmod==4 then end
  end
end

function pag2keyz(x,y,z,rwoffst)
  if y==(1+rwoffst) then
    if (x>1) and (x<6) then uipag = x - 2  
    elseif x==(cl-3) then if lenslct==4 then lenslct=0 else lenslct=4 end
    elseif x==(cl-4) then if lenslct==3 then lenslct=0 else lenslct=3 end
    elseif x==(cl-5) then if lenslct==2 then lenslct=0 else lenslct=2 end
    elseif x==(cl-6) then if lenslct==1 then lenslct=0 else lenslct=1 end
    elseif x==6 then
      params:set("PT1",1-params:get("PT1")) 
      if params:get("PT1")>0 then pollf:start() else pollf:stop() end
    elseif x==7 then params:set("S_PRz",1-params:get("S_PRz"))
    elseif x==8 then
      params:set("PT2",1-params:get("PT2")) 
      if params:get("PT2")>0 then pollr:start() else pollr:stop() end
    elseif x==9 then prmfreez=1-prmfreez end
  elseif y==(2+rwoffst) then
    if lenslct>0 then params:set("S"..lenslct.."_Sln",(64-(x+(uipag*16)))*-1) 
      else tix=(x+(uipag*16))-1 end
  elseif (y>(2+rwoffst)) and (y<(7+rwoffst)) then
    local stepvalue=seq[y-rwoffst-2][x+(uipag*16)]
    if ((stepvalue>0) and (sqslctd<1)) then 
      seq[y-rwoffst-2][x+(uipag*16)]=math.random(2,11) sqslctd=1
    elseif ((stepvalue>0) and (sqslctd>0)) then 
      seq[y-rwoffst-2][x+(uipag*16)]=0 sqslctd=0
    elseif stepvalue<1 then seq[y-rwoffst-2][x+(uipag*16)]=1 end
  elseif y==(7+rwoffst) then
    if x<5 then params:set("S"..x.."_Dfl",1-params:get("S"..x.."_Dfl"))
    elseif x==5 then
      if spr>0 then params:set("SPre",util.wrap(params:get("SPre")-1,1,500)) 
        sprenum = params:get("SPre")
      else sprenum = util.wrap(sprenum-1,1,500) end
    elseif x==6 then
      if spr>0 then params:set("SPre",util.wrap(params:get("SPre")+1,1,500)) sprenum = params:get("SPre")
      else sprenum = util.wrap(sprenum+1,1,500) end
    elseif x>6 and x<11 then
      params:set("S"..(x-6).."_Stt",util.wrap(params:get("S"..(x-6).."_Stt")+1,0,2))
    elseif x==11 then
      if vpr>0 then 
        params:set("VPre",util.wrap(params:get("VPre")-1,1,500)) vprenum = params:get("VPre")
     else vprenum = util.wrap(vprenum-1,1,500) end
    elseif x==12 then
      if vpr>0 then 
        params:set("VPre",util.wrap(params:get("VPre")+1,1,500)) vprenum = params:get("VPre")
      else vprenum = util.wrap(vprenum+1,1,500) end
    elseif x>12 then
      params:set("S"..(x-12).."_Rct",1-params:get("S"..(x-12).."_Rct"))
    end
  elseif y==(8+rwoffst) then
    if x==5 then params:set("AT1",1-params:get("AT1"))
    elseif x==6 then spr=1-spr if spr>0 then params:set("SPre",sprenum) end 
    elseif x==11 then vpr=1-vpr if vpr>0 then params:set("VPre",vprenum) end 
    elseif x==12 then params:set("AT2",1-params:get("AT2")) 
    elseif x>=13 then params:set("S"..(x-12).."_Ply",1-params:get("S"..(x-12).."_Ply")) end
  end
end

function pag3keyz(x,y,z,rwoffst)
  if (y==(1+rwoffst)) and ((x>1) and (x<16)) then keycount=keycount+((x-1)<<2) end
  if (y==(2+rwoffst)) and ((x>1) and (x<16)) then keycount=keycount+((x-1)*100) end
  if y>(2+rwoffst) then
    if keycount==0 then
      if smod>0 then
        local md=params:get("V"..vsel.."_Mod")
        if md<3 then
          if y==(3+rwoffst) then params:set("V"..vsel.."_Len",x/16) end
          if md==1 then if y==(4+rwoffst) then params:set("V"..vsel.."_Phase",(x-1)/16) end 
            else if y==(4+rwoffst) then params:set("V"..vsel.."_Vol",(x-1)/16) end end 
        else
          if y==(3+rwoffst) then params:set("V"..vsel.."_Impatnz",x-2) end
          if y==(4+rwoffst) then 
            if (x%2)==0 then params:set("V"..vsel.."_LpNum",(((x-1)*2) >> 2)+1) 
              else for i=1,6 do params:set("V"..i.."_LpNum",(((x-1)*2) >> 2)+1) end end
          end 
        end
        if y==(5+rwoffst) then
          if x==1 then params:set("V"..vsel.."_Spd",-2) else params:set("V"..vsel.."_Spd",(x-8)/4) end
        end
        if y==(6+rwoffst) then params:set("V"..vsel.."_Fbk",(x-1)/16) end
        if y==(7+rwoffst) then
          poslfoz[vsel]:set('max', util.round((voices[vsel].ennd[voices[vsel].lpno]%58)/58.0,0.0001))
          poslfoz[vsel]:set('min', util.round((voices[vsel].strt[voices[vsel].lpno]%58)/58.0,0.0001))
          if x<5 then voices[vsel].plf=x-1 else lfprmult=(16-(x-1))/16 end
          poslfoz[vsel]:set('depth', 1.0)                             --previously was necessary to reset..
          if voices[vsel].plf == 0 then poslfoz[vsel]:stop()      --..depth everytime; this may be fixed now(unnecessary?)
          elseif voices[vsel].plf == 1 then poslfoz[vsel]:set('shape', 'random') lfprmult=0.25 poslfoz[vsel]:start()  
          elseif voices[vsel].plf == 2 then poslfoz[vsel]:set('shape', 'saw') lfprmult=0.75 poslfoz[vsel]:start()
          elseif voices[vsel].plf == 3 then poslfoz[vsel]:set('shape', 'sine') lfprmult=0.5 poslfoz[vsel]:start() end
        end
        if (y==(8+rwoffst) and (x<9)) then params:set("V"..vsel.."_In",x) end
      else
        if omod==1 then
          local btsprbar = params:get("V"..(y-rwoffst-2).."_Cyc")
          voices[y-rwoffst-2].tixx = ((x + (voices[y-rwoffst-2].pg*16)) % btsprbar)-1
        elseif omod==2 then tixx=x-1 for i=1,6 do voices[i]:rsync() end
        else
          if lnm[1]>0 then params:set("V"..(y-rwoffst-2).."_Cyc",x+((lnm[1]-1)*16)) --check each btz/bar length modifier 1st..
          elseif lnm[2]>0 then params:set("V"..(y-rwoffst-2).."_Cyc",x+((lnm[2]-1)*16))
          elseif lnm[3]>0 then params:set("V"..(y-rwoffst-2).."_Cyc",x+((lnm[3]-1)*16))
          elseif lnm[4]>0 then params:set("V"..(y-rwoffst-2).."_Cyc",x+((lnm[4]-1)*16))
          elseif lnm[5]>0 then params:set("V"..(y-rwoffst-2).."_Cyc",x+((lnm[5]-1)*16))
          elseif lnm[6]>0 then params:set("V"..(y-rwoffst-2).."_Cyc",x+((lnm[6]-1)*16))
          elseif vmod==1 then                                                       --...if all clear, then go into gameboard
            if sprklz[y-rwoffst-2].busy==0 then sprklz[y-rwoffst-2].xcoord=x sprklz[y-rwoffst-2]:go(1)
              params:set("V"..(y-rwoffst-2).."_Go",1)
            else sprklz[y-rwoffst-2]:go(0) params:set("V"..(y-rwoffst-2).."_Go",0) end
          elseif vmod==2 then
          elseif vmod==3 then
          elseif vmod==4 then
          end
        end
      end
    elseif (keycount==((y-2-rwoffst)<<2)) then params:set("V"..y-2-rwoffst.."_Cyc",x)
    elseif keycount==((y-2-rwoffst)*100) then params:set("V"..y-2-rwoffst.."_Cyc",x+16)
    end  
  end
end           -- [toprow buttons 2-7] + [second-to-toprow 2-4] = grid-shortcut for choose mode(2=st;3=dl;4=lp) 

function pag2keyzoff(x,y,z,rwoffst) keycount=0 end

function pag3keyzoff(x,y,z,rwoffst)
  if keycount==100 then lnm[1]=util.wrap(lnm[1]+1,0,2) elseif keycount==200 then lnm[2]=util.wrap(lnm[2]+1,0,2)
  elseif keycount==300 then lnm[3]=util.wrap(lnm[3]+1,0,2) elseif keycount==400 then lnm[4]=util.wrap(lnm[4]+1,0,2)
  elseif keycount==500 then lnm[5]=util.wrap(lnm[5]+1,0,2) elseif keycount==600 then lnm[6]=util.wrap(lnm[6]+1,0,2)
  elseif ((keycount>100) and (keycount<325)) then params:set("V"..((keycount%100)>>2).."_Mod",math.floor(keycount/100)) 
  elseif ((keycount>600) and (keycount<625)) then 
    params:set("V"..((keycount%100)>>2).."_ARc",1-params:get("V"..((keycount%100)>>2).."_ARc")) end
  if (y==(1+rwoffst)) then 
    if ((x>1) and (x<8)) then
      if smod>0 then if keycount==((x-1)<<2) then vsel = x-1 end
      else
        if keycount==((x-1)<<2) then 
           if sprklz[x-1].busy>0 then sprklz[x-1]:go(0) 
             else params:set("V"..(x-1).."_Go",1-params:get("V"..(x-1).."_Go")) end
        end
      end
    elseif x==8 then rmod=1-rmod
    elseif ((x>8) and (x<15)) then
      if keycount==((x-1)<<2) then 
        if voices[x-8].mde==3 then voices[x-8].prerec=2
         else params:set("V"..(x-8).."_Rc",1-params:get("V"..(x-8).."_Rc")) end
      end
    end
  elseif (y==(2+rwoffst)) then
    if x==1 then omod=util.wrap(omod+1,0,2)
    elseif keycount==700 then smod=1-smod
    elseif keycount==800 then sneakyrec(1) elseif keycount==900 then sneakyrec(2) elseif keycount==1000 then sneakyrec(3)
    elseif keycount==1100 then sneakyrec(4) elseif keycount==1200 then sneakyrec(5) elseif keycount==1300 then sneakyrec(6)
    elseif keycount==1400 then vmod=util.wrap(vmod+1,1,4)
    elseif x==1500 then xmod=1-xmod end
  end keycount=0
end

function sneakyrec(nmbr)
  voices[nmbr].rc=1-voices[nmbr].rc softcut.rec(nmbr,voices[nmbr].rc) softcut.rec_level(nmbr,voices[nmbr].rc)
end
