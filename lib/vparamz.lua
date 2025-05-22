--Vox(softcut)-page parameters

for i=1,6 do
  local itbl={} local indx=1 local modez={"St","Dl","Lp"} local lfostatz={"Off","Sin","Tri","Up","Dwn","Sqr","Rnd"}

  params:add_group("V"..i.."_Grp","V"..i.."_Group",28)
  params:add_number("V"..i.."_Go","V"..i.."_Play",0,1,0)
  params:set_action("V"..i.."_Go", 
    function(ply) voices[i]:go(ply) if ((ply<1) and (grd ~= nil)) then sprklz[i]:go(0) end end
  )
  params:add_number("V"..i.."_Rc","V"..i.."_Rec",0,1,0)
  params:set_action("V"..i.."_Rc", function(rc) voices[i]:rec(rc) end)
  params:add{type = "option", id = "V"..i.."_Mod", name = "V"..i.."_Mode", options = modez, default = 1,
    action = function(mdz) voices[i]:mode(mdz) end}
  params:add_number("V"..i.."_Len","V"..i.."_Length",0.0,48.0,1.0)
  params:set_action("V"..i.."_Len", function(lnth) voices[i]:length(lnth) end)
  params:add_number("V"..i.."_Lns","V"..i.."_LengthInSec",0.0,24.0,1.0)
  params:set_action("V"..i.."_Lns", function(lnth) voices[i]:lninsec(lnth) end)
  params:add_number("V"..i.."_LpNum", "V"..i.."_LoopNumber",1,8,1)
  params:set_action("V"..i.."_LpNum", function(lpno) voices[i]:lpnum(lpno) end)
  params:add_number("V"..i.."_Impatnz","V"..i.."_Impatienz",-1,32,3)
  params:set_action("V"..i.."_Impatnz", function(impat) voices[i]:ipatnz(impat) end)
  params:add_number("V"..i.."_Fbk","V"..i.."_Feedback",0.0,1.0,0.0)
  params:set_action("V"..i.."_Fbk", function(fbk) voices[i]:fdbk(fbk) end)
  params:add_number("V"..i.."_Phase","V"..i.."_PhasePosition",0.0,1.0,0.0)
  params:set_action("V"..i.."_Phase", function(phase) voices[i]:phas(util.wrap(phase,0.0,1.0)) end)
  params:add_number("V"..i.."_Spd","V"..i.."_Speed",-2.0,2.0,1.0)
  params:set_action("V"..i.."_Spd", function(spd) voices[i]:speed(spd) end)
  params:add_number("V"..i.."_Pn","V"..i.."_Pan",0.0,1.0,0.5)
  params:set_action("V"..i.."_Pn", function(pan) voices[i]:pnabausch(pan) end)
  params:add_number("V"..i.."_Vol","V"..i.."_Volume",0.0,2.0,1.0)
  params:set_action("V"..i.."_Vol", function(vol) voices[i]:gain(vol) end)
  params:add_number("V"..i.."_Ofst","V"..i.."_LoopOffset",0,31,0)
  params:set_action("V"..i.."_Ofst", function(ofst) voices[i]:offset(ofst) end)
  params:add_number("V"..i.."_Cyc","V"..i.."_CycleLength",1,32,8)
  params:set_action("V"..i.."_Cyc", function(cycbtz) voices[i]:cybtz(cycbtz) end)
  params:add_control("V"..i.."_CtOff","V"..i.."_CutOff",controlspec.new(20,20000,'log',10,1000,'freq',10))
  params:set_action("V"..i.."_CtOff", function(ctoff) voices[i]:cutoff(ctoff) end)
  params:add_number("V"..i.."_BndWdt","V"..i.."_BandWidth",0.02,14,10)
  params:set_action("V"..i.."_BndWdt", function(rq) voices[i]:bndwidth(rq) end)
  params:add_number("V"..i.."_ARc","V"..i.."AmpTrigRec",0,1,1)
  params:add_number("V"..i.."_ALn","V"..i.."AmpTrigLen",0,1,0)
  params:add_number("V"..i.."_PLn","V"..i.."PitchTrigLen",0,1,0)
  params:add_number("V"..i.."_APs","V"..i.."AmpTrigPos",0,1,0)
  params:add_number("V"..i.."_ASp","V"..i.."AmpTrigSpd",0,1,0)
  
  params:add_control("V"..i.."_FDry", "V"..i.."FilterDry",controlspec.new(0.0,1.0,'lin',0.001,1,'amp',0.001))
  params:set_action("V"..i.."_FDry", function(fdr) voices[i]:fdry(fdr) end)
  params:add_control("V"..i.."_FLoP", "V"..i.."FilterLowPass",controlspec.new(0.0,1.0,'lin',0.001,0,'amp',0.001))
  params:set_action("V"..i.."_FLoP", function(flp) voices[i]:flowp(flp) end)
  params:add_control("V"..i.."_FHiP", "V"..i.."FilterHighPass",controlspec.new(0.0,1.0,'lin',0.001,0,'amp',0.001))
  params:set_action("V"..i.."_FHiP", function(fhp) voices[i]:fhighp(fhp) end)
  params:add_control("V"..i.."_FBnP", "V"..i.."FilterBandPass",controlspec.new(0.0,1.0,'lin',0.001,0,'amp',0.001))
  params:set_action("V"..i.."_FBnP", function(fbp) voices[i]:fbandp(fbp) end)
  params:add_control("V"..i.."_FBnR", "V"..i.."FilterBandReject",controlspec.new(0.0,1.0,'lin',0.001,0,'amp',0.001))
  params:set_action("V"..i.."_FBnR", function(fbr) voices[i]:fbandr(fbr) end)
  
  params:add{type = "option", id = "V"..i.."_PLFO", name = "V"..i.."_PositionLFO", options = lfostatz, default = 1,
    action = function(stat) voices[i]:poslfo(stat) end}
  params:add_number("V"..i.."_PLFMin","V"..i.."PosLFOMin",0.0,1.0,0.0)
  params:set_action("V"..i.."_PLFMin", function(mn) poslfoz[i]:set('min',(mn*0.1)) end)
  params:add_number("V"..i.."_PLFMax","V"..i.."PosLFOMax",0.0,1.0,0.0)
  params:set_action("V"..i.."_PLFMax", function(mx) poslfoz[i]:set('max',mx) end)
  params:add{type = "option", id = "V"..i.."_LLFO", name = "V"..i.."_LengthLFO", options = lfostatz, default = 1,
    action = function(stat) voices[i]:lenlfo(stat) end}
  params:add_number("V"..i.."_LLFMin","V"..i.."LenLFOMin",0.0,1.0,0.0)
  params:set_action("V"..i.."_LLFMin", function(mn) lenlfoz[i]:set('min',(mn*48)) end)
  params:add_number("V"..i.."_LLFMax","V"..i.."LenLFOMax",0.0,1.0,0.0)
  params:set_action("V"..i.."_LLFMax", function(mx) lenlfoz[i]:set('max',(mx*48)) end)
  params:add{type = "option", id = "V"..i.."_SLFO", name = "V"..i.."_SpeedLFO", options = lfostatz, default = 1,
    action = function(stat) voices[i]:spdlfo(stat) end}
  params:add_number("V"..i.."_SLFMin","V"..i.."SpdLFOMin",0.0,1.0,0.0)
  params:set_action("V"..i.."_SLFMin", function(mn) spdlfoz[i]:set('min',(mn*4)-2) end)
  params:add_number("V"..i.."_SLFMax","V"..i.."SpdLFOMax",0.0,1.0,0.0)
  params:set_action("V"..i.."_SLFMax", function(mx) spdlfoz[i]:set('max',(mx*4)-2) end)
  params:add{type = "option", id = "V"..i.."_FLFO", name = "V"..i.."_FeedbackLFO", options = lfostatz, default = 1,
    action = function(stat) voices[i]:fbklfo(stat) end}
  params:add_number("V"..i.."_FLFMin","V"..i.."FbkLFOMin",0.0,1.0,0.0)
  params:set_action("V"..i.."_FLFMin", function(mn) fbklfoz[i]:set('min',mn) end)
  params:add_number("V"..i.."_FLFMax","V"..i.."FbkLFOMax",0.0,1.0,0.0)
  params:set_action("V"..i.."_FLFMax", function(mx) fbklfoz[i]:set('max',mx) end)
  params:add{type = "option", id = "V"..i.."_CLFO", name = "V"..i.."_CutoffLFO", options = lfostatz, default = 1,
    action = function(stat) voices[i]:flclfo(stat) end}
  params:add_number("V"..i.."_CLFMin","V"..i.."FlCLFOMin",0.0,1.0,0.0)
  params:set_action("V"..i.."_CLFMin", function(mn) flclfoz[i]:set('min',(mn*20000)+20) end)
  params:add_number("V"..i.."_CLFMax","V"..i.."FlCLFOMax",0.0,1.0,0.0)
  params:set_action("V"..i.."_CLFMax", function(mx) flclfoz[i]:set('max',(mx*20000)+20) end)
  params:add{type = "option", id = "V"..i.."_QLFO", name = "V"..i.."_BandWidthLFO", options = lfostatz, default = 1,
    action = function(stat) voices[i]:flqlfo(stat) end}
  params:add_number("V"..i.."_QLFMin","V"..i.."FlQLFOMin",0.0,1.0,0.0)
  params:set_action("V"..i.."_QLFMin", function(mn) flqlfoz[i]:set('min',(mn*13.5)+0.5) end)
  params:add_number("V"..i.."_QLFMax","V"..i.."FlQLFOMax",0.0,1.0,0.0)
  params:set_action("V"..i.."_QLFMax", function(mx) flqlfoz[i]:set('max',(mx*13.5)+0.5) end)
  
  for j=1,6 do if i~=j then itbl[indx]=j indx=indx+1 end end
  params:add{type = "option", id = "V"..i.."_In", name = "V"..i.."_Input",
  options = {"I1","I2","V"..itbl[1],"V"..itbl[2],"V"..itbl[3],"V"..itbl[4],"V"..itbl[5],"En"}, default = 1,
  action = function(inz) voices[i]:inputselect(inz, itbl) end}

  poslfoz[i]:add_params('pos_lfo'..i, 'position'..i, 'PosLFO'..i)
  lenlfoz[i]:add_params('len_lfo'..i, 'length'..i, 'LenLFO'..i)
  spdlfoz[i]:add_params('spd_lfo'..i, 'speed'..i, 'SpdLFO'..i)
  fbklfoz[i]:add_params('fbk_lfo'..i, 'feedback'..i, 'FbkLFO'..i)
  flclfoz[i]:add_params('flc_lfo'..i, 'filtcutoff'..i, 'FCLFO'..i)
  flqlfoz[i]:add_params('flq_lfo'..i, 'filtwidth'..i, 'FQLFO'..i)
end

function vpwrit(nam)
  local wriitab={}
  for i=1,6 do
    wriitab["V"..i.."_Go"]=params:get("V"..i.."_Go") wriitab["V"..i.."_Rc"]=params:get("V"..i.."_Rc")
    wriitab["V"..i.."_Mod"]=params:get("V"..i.."_Mod") wriitab["V"..i.."_Len"]=params:get("V"..i.."_Len")
    wriitab["V"..i.."_Impatnz"]=params:get("V"..i.."_Impatnz") wriitab["V"..i.."_Fbk"]=params:get("V"..i.."_Fbk")
    wriitab["V"..i.."_Phase"]=params:get("V"..i.."_Phase") wriitab["V"..i.."_Spd"]=params:get("V"..i.."_Spd")
    wriitab["V"..i.."_Pn"]=params:get("V"..i.."_Pn") wriitab["V"..i.."_Vol"]=params:get("V"..i.."_Vol")
    wriitab["V"..i.."_Ofst"]=params:get("V"..i.."_Ofst") wriitab["V"..i.."_LpNum"]=params:get("V"..i.."_LpNum")
    wriitab["V"..i.."_Cyc"]=params:get("V"..i.."_Cyc") wriitab["V"..i.."_In"]=params:get("V"..i.."_In")
    wriitab["V"..i.."_ALn"]=params:get("V"..i.."_ALn") wriitab["V"..i.."_PLn"]=params:get("V"..i.."_PLn")
    wriitab["V"..i.."_APs"]=params:get("V"..i.."_APs") wriitab["V"..i.."_ASp"]=params:get("V"..i.."_ASp")
    wriitab["V"..i.."_Lns"]=params:get("V"..i.."_Lns") wriitab["V"..i.."_ARc"]=params:get("V"..i.."_ARc")
    wriitab["V"..i.."_CtOff"]=params:get("V"..i.."_CtOff") wriitab["V"..i.."_BndWdt"]=params:get("V"..i.."_BndWdt")
    wriitab["V"..i.."_FDry"]=params:get("V"..i.."_FDry") wriitab["V"..i.."_FLoP"]=params:get("V"..i.."_FLoP")
    wriitab["V"..i.."_FHiP"]=params:get("V"..i.."_FHiP") wriitab["V"..i.."_FBnP"]=params:get("V"..i.."_FBnP")
    wriitab["V"..i.."_FBnR"]=params:get("V"..i.."_FBnR") 
    wriitab["V"..i.."_PLFMin"]=params:get("V"..i.."_PLFMin") wriitab["V"..i.."_PLFMax"]=params:get("V"..i.."_PLFMax")
    wriitab["V"..i.."_LLFMin"]=params:get("V"..i.."_LLFMin") wriitab["V"..i.."_LLFMax"]=params:get("V"..i.."_LLFMax")
    wriitab["V"..i.."_SLFMin"]=params:get("V"..i.."_SLFMin") wriitab["V"..i.."_SLFMax"]=params:get("V"..i.."_SLFMax")
    wriitab["V"..i.."_FLFMin"]=params:get("V"..i.."_FLFMin") wriitab["V"..i.."_FLFMax"]=params:get("V"..i.."_FLFMax")
    wriitab["V"..i.."_CLFMin"]=params:get("V"..i.."_CLFMin") wriitab["V"..i.."_CLFMax"]=params:get("V"..i.."_CLFMax")
    wriitab["V"..i.."_QLFMin"]=params:get("V"..i.."_QLFMin") wriitab["V"..i.."_QLFMax"]=params:get("V"..i.."_QLFMax")
    wriitab["V"..i.."_PLFO"]=params:get("V"..i.."_PLFO") wriitab["PosLFORate"..i]=poslfoz[i]:get('period') 
    wriitab["V"..i.."_LLFO"]=params:get("V"..i.."_LLFO") wriitab["LenLFORate"..i]=lenlfoz[i]:get('period')
    wriitab["V"..i.."_SLFO"]=params:get("V"..i.."_SLFO") wriitab["SpdLFORate"..i]=spdlfoz[i]:get('period') 
    wriitab["V"..i.."_FLFO"]=params:get("V"..i.."_FLFO") wriitab["FbkLFORate"..i]=fbklfoz[i]:get('period')
    wriitab["V"..i.."_CLFO"]=params:get("V"..i.."_CLFO") wriitab["FltCLFORate"..i]=flclfoz[i]:get('period') 
    wriitab["V"..i.."_QLFO"]=params:get("V"..i.."_QLFO") wriitab["FltQLFORate"..i]=flqlfoz[i]:get('period')
  end
  tab.save(wriitab,_path.data.."loki/"..nam)
end

function vpread(nam)
  local err local reeadtab={} reeadtab,err=tab.load(_path.data.."loki/"..nam)
  if err==nil then
    for i=1,6 do
      if voices[i].pfreez<1 then
      params:set("V"..i.."_Mod", reeadtab["V"..i.."_Mod"]) params:set("V"..i.."_Len", reeadtab["V"..i.."_Len"])
      params:set("V"..i.."_Go", reeadtab["V"..i.."_Go"]) params:set("V"..i.."_Rc", reeadtab["V"..i.."_Rc"])
      params:set("V"..i.."_Impatnz", reeadtab["V"..i.."_Impatnz"]) params:set("V"..i.."_Fbk", reeadtab["V"..i.."_Fbk"])
      params:set("V"..i.."_Phase", reeadtab["V"..i.."_Phase"]) params:set("V"..i.."_Spd", reeadtab["V"..i.."_Spd"])
      params:set("V"..i.."_Pn", reeadtab["V"..i.."_Pn"]) params:set("V"..i.."_Vol", reeadtab["V"..i.."_Vol"])
      params:set("V"..i.."_Ofst", reeadtab["V"..i.."_Ofst"]) params:set("V"..i.."_LpNum", reeadtab["V"..i.."_LpNum"])
      params:set("V"..i.."_CtOff", reeadtab["V"..i.."_CtOff"]) params:set("V"..i.."_BndWdt", reeadtab["V"..i.."_BndWdt"])
      params:set("V"..i.."_Cyc", reeadtab["V"..i.."_Cyc"]) params:set("V"..i.."_In", reeadtab["V"..i.."_In"])
      params:set("V"..i.."_ALn", reeadtab["V"..i.."_ALn"]) params:set("V"..i.."_PLn", reeadtab["V"..i.."_PLn"])
      params:set("V"..i.."_APs", reeadtab["V"..i.."_APs"]) params:set("V"..i.."_ASp", reeadtab["V"..i.."_ASp"])
      params:set("V"..i.."_Lns", reeadtab["V"..i.."_Lns"]) params:set("V"..i.."_ARc", reeadtab["V"..i.."_ARc"])
      params:set("V"..i.."_FDry", reeadtab["V"..i.."_FDry"]) params:set("V"..i.."_FLoP", reeadtab["V"..i.."_FLoP"])
      params:set("V"..i.."_FHiP", reeadtab["V"..i.."_FHiP"]) params:set("V"..i.."_FBnP", reeadtab["V"..i.."_FBnP"])
      params:set("V"..i.."_FBnR", reeadtab["V"..i.."_FBnR"])
      params:set("V"..i.."_PLFMin", reeadtab["V"..i.."_PLFMin"]) params:set("V"..i.."_PLFMax", reeadtab["V"..i.."_PLFMax"])
      params:set("V"..i.."_LLFMin", reeadtab["V"..i.."_LLFMin"]) params:set("V"..i.."_LLFMax", reeadtab["V"..i.."_LLFMax"])
      params:set("V"..i.."_SLFMin", reeadtab["V"..i.."_SLFMin"]) params:set("V"..i.."_SLFMax", reeadtab["V"..i.."_SLFMax"])
      params:set("V"..i.."_FLFMin", reeadtab["V"..i.."_FLFMin"]) params:set("V"..i.."_FLFMax", reeadtab["V"..i.."_FLFMax"])
      params:set("V"..i.."_CLFMin", reeadtab["V"..i.."_CLFMin"]) params:set("V"..i.."_CLFMax", reeadtab["V"..i.."_CLFMax"])
      params:set("V"..i.."_QLFMin", reeadtab["V"..i.."_QLFMin"]) params:set("V"..i.."_QLFMax", reeadtab["V"..i.."_QLFMax"])
      params:set("V"..i.."_PLFO", reeadtab["V"..i.."_PLFO"]) poslfoz[i]:set('period', reeadtab["PosLFORate"..i]) 
      params:set("V"..i.."_LLFO", reeadtab["V"..i.."_LLFO"]) lenlfoz[i]:set('period', reeadtab["LenLFORate"..i])
      params:set("V"..i.."_SLFO", reeadtab["V"..i.."_SLFO"]) spdlfoz[i]:set('period', reeadtab["SpdLFORate"..i]) 
      params:set("V"..i.."_FLFO", reeadtab["V"..i.."_FLFO"]) fbklfoz[i]:set('period', reeadtab["FbkLFORate"..i])
      params:set("V"..i.."_CLFO", reeadtab["V"..i.."_CLFO"]) flclfoz[i]:set('period', reeadtab["FltCLFORate"..i]) 
      params:set("V"..i.."_QLFO", reeadtab["V"..i.."_QLFO"]) flqlfoz[i]:set('period', reeadtab["FltQLFORate"..i])
      end
end end end
