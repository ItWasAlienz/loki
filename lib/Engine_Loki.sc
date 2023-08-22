// CroneEngine_Loki
// one-shots with dictionary for overlapping stutters + simple fx matrix
// mischief managed
//     - raja
Engine_Loki : CroneEngine {
	classvar maxVoices=11;
	classvar s1=0;
	classvar s2=0;
	classvar s3=0;
	classvar s4=0;
	classvar fxnum=3;
	    var pg;
	    var dg;
	    var fxg;
	    var mg;
	    var sawc1;
	    var sawc2;
	    var sawc3;
	    var sawc4;
	    var smokefx;
	    var fxroute;
	    var mastering;
	    var bfr;
	    var rzr;
	    var dst;
	    var rvrb;
	    var mstr;

	*new { arg context, doneCallback;
		^super.new(context, doneCallback);
	}

	alloc {
		pg = ParGroup.head(context.xg);
		dg = ParGroup.after(pg);
		fxg = ParGroup.after(dg);
		mg = ParGroup.after(fxg);
		sawc1 = IdentityDictionary.new(maxVoices);
		sawc2 = IdentityDictionary.new(maxVoices);
		sawc3 = IdentityDictionary.new(maxVoices);
		sawc4 = IdentityDictionary.new(maxVoices);
		fxroute = fxnum.do.collect({ Bus.control(context.server, 1).set(0) }); //control bus: allows for an easy .asMap(see below)
		smokefx = fxnum.do.collect({ Bus.audio(context.server, 2) }); //...hoping this can apply to more dynamic routing added later
	  mastering = Bus.audio(context.server,2);
		bfr = 4.do.collect({ Buffer.new(context.server) });

		SynthDef("aw",
			{arg out, fxo, bnum, pn=0.0, spd=1.0, fcoff=8888, rls=1.0, lvl=1.0;
			var isrev = spd < 0.0;
			var pos = Select.kr(isrev,[0.0,BufFrames.kr(bnum)-2]);
			var trigz=T2A.ar(\tryg.tr);
			var amp = EnvGen.ar(Env.adsr(0.001,0.3,0.7,rls*(BufDur.kr(bnum)-0.1)),trigz,doneAction:2);
			var awesomeness=LPF.ar(PlayBuf.ar(2,bnum,BufRateScale.kr(bnum)*spd,trigz,pos,0),6969,1.4)*amp;
			Out.ar([fxo,out],Pan2.ar(MoogFF.ar(awesomeness.softclip,fcoff,2.8),pn,lvl));
		}).add;
		
		/*SynthDef("awx",
			{arg out, fxo, div=16, bnum, start=0.0, noff=0.0, sid;
			
			var trigz=T2A.ar(\tryg.tr);
			var stepsize=BufFrames.kr(bnum)/div;
			var pos=start*stepsize;
			var tdel=DelayN.ar(trigz,0.01,0.0025);
			var duckenv=Env.new([1, 0, 0, 1], [0.002, 0.001, 0.002], curve: 'cub');
			var duck=EnvGen.ar(duckenv,trigz);
			var awesomeness=PlayBuf.ar(2,bnum,BufRateScale.kr(bnum),tdel,pos,0)*duck*noff.lag3(0.01);
			Out.ar([fxo,out,sid],awesomeness);
		}).add;*/
		
		SynthDef("Rezor", { arg out, freq=220, amp=0.12, rngz=0.6, fxindx=smokefx[0].index, noff;
		
		      var freqs = Array.fill(4, { arg i; freq*((i*1.618033988749895)+1); });
		      var amps = Array.fill(4, { arg i; (1/((i+1)*3))*amp; });
		      var rings = Array.fill(4, { arg i; (1/(i+1)).pow(0.5)*rngz });
		      var receive = In.ar(fxindx, 2);
		      var send = DynKlank.ar(`[freqs, amps, rings], receive) * Lag.kr(noff, 0.01);
		      send = CompanderD.ar(send,0.6,1,0.25,0.002,0.4);
		      Out.ar(out, LeakDC.ar(send + receive));
		}).add;
		
		SynthDef("DelStereo", {arg out, time, fxindx=smokefx[1].index, noff;

		      var receiveL = In.ar(fxindx, 1);
		      var receiveR = In.ar(fxindx+1, 1);
		      var randdec = TRand.kr(1, 20, \trigr.tr);
		      var timeL = (TIRand.kr(1,8,\trigr.tr)/2);
		      var timeR = (TIRand.kr(1,8,\trigr.tr)/2);
		      var sendL = AllpassN.ar(receiveL * Lag3.kr(noff,0.01), 2.5, Lag3.kr(time * timeL,0.08), randdec);
		      var sendR = AllpassN.ar(receiveR * Lag3.kr(noff,0.01), 2.5, Lag3.kr(time * timeR,0.08), randdec);
		      Out.ar(out, [sendL+receiveL, sendR+receiveR]);
		}).add;
		
		SynthDef("Reverb", { arg out, noff, fxindx=smokefx[2].index;
		
		      var send;
		      var receive = In.ar(fxindx, 2);
		      var input = Mix.ar(Array.fill(2,{ CombC.ar(receive, 0.1, LFNoise1.kr(0.1.rand, 0.01, 0.05), 4, 0.1) }));
		      input = AllpassC.ar(input, 0.050, [0.050.rand, 0.050.rand], 1);
		      input = AllpassC.ar(input, 0.050, [0.050.rand, 0.050.rand], 1);
		      send = receive + (input  * Lag3.kr(noff, 0.01));
		      Out.ar(out, LeakDC.ar(send+receive));
		}).add;
		
		SynthDef("Master", {arg in, out,thresh=0.988,below=1.0,above=0.4,att=0.005,rls=0.2;
		      var receive = In.ar(in, 2);
		      var send = Limiter.ar(CompanderD.ar(receive*1.4,thresh,below,above,att,rls,1.4),0.99,0.008);
		      Out.ar(out, send);
		}).add;

		this.addCommand("flow", "", { arg msg;  
      mstr = Synth.new("Master", [\in,mastering,\out,context.out_b], target: mg);
	  });
		
		this.addCommand("flex","is", { arg msg; bfr[msg[1]].allocRead(msg[2]); });
		
		this.addCommand("awyea1", "fffff", { arg msg; //ps, sp, lv, fc, rl
		  s1=(s1+1)%maxVoices;
			this.addSoice1(msg[1], msg[2], msg[3], msg[4], msg[5], s1);  });
		
		this.addCommand("awyea2", "fffff", { arg msg;
		  s2=(s2+1)%maxVoices;
			this.addSoice2(msg[1], msg[2], msg[3], msg[4], msg[5], s2);  });
		
		this.addCommand("awyea3", "fffff", { arg msg; 
		  s3=(s3+1)%maxVoices;
			this.addSoice3(msg[1], msg[2], msg[3], msg[4], msg[5], s3);  });
		
		this.addCommand("awyea4", "fffff", { arg msg; 
		  s4=(s4+1)%maxVoices;
			this.addSoice4(msg[1], msg[2], msg[3], msg[4], msg[5], s4);  });
		
    this.addCommand("rzr", "iffii", { arg msg,xtra,ot;
			var val = msg[1].midicps, gn = msg[2], md1 = msg[3], md2 = msg[4]; 
			xtra = msg[5]; if(xtra>0, {ot=smokefx[xtra-1];},{ot=mastering;});
      rzr = Synth("Rezor", 
      [\out,ot,\freq,val,\amp,gn,\rngz,md1,\fxindx,smokefx[md2],\noff,fxroute[0].asMap], //eventually, can i change these .asMap..
      target:fxg);                                                                        //...assignments dynamically?
		});
		
		this.addCommand("rzset", "iff", { arg msg;
			var val = msg[1].midicps, gn = msg[2], md1 = msg[3];
      rzr.set(\freq,val,\amp,gn,\rngz,md1);
		});
		
		this.addCommand("dst", "ffii", { arg msg,xtra,ot;
			var val = msg[1], md1 = msg[2], md2 = msg[3];
			xtra = msg[4]; if(xtra>0, {ot=smokefx[xtra-1];},{ot=mastering;});
      dst = Synth("DelStereo", 
      [\out,ot,\time,val,\trigr,md1,\fxindx,smokefx[md2],\noff,fxroute[1].asMap], 
      target:fxg, addAction: \addToTail);
		});
		
		this.addCommand("dstset", "ff", { arg msg;
			var val = msg[1], md1 = msg[2];
      dst.set(\time,val,\trigr,md1);
		});
		
		this.addCommand("rvrb", "ii", { arg msg,xtra,ot;
			var val = msg[1];
			xtra = msg[2]; if(xtra>0, {ot=smokefx[xtra-1];},{ot=mastering;});
      rvrb = Synth("Reverb", 
      [\out,ot,\fxindx,smokefx[val],\noff,fxroute[2].asMap], 
      target:fxg, addAction: \addToTail);
		});
		
		this.addCommand("fxrtrz", "i", { arg msg; fxroute[0].set(msg[1]);});
		
		this.addCommand("fxrtds", "i", { arg msg; fxroute[1].set(msg[1]);});
		
		this.addCommand("fxrtrv", "i", { arg msg; fxroute[2].set(msg[1]);});
		
	
		// free all synths
		this.addCommand("darknez", "", {pg.set(\gate, 0);	dg.set(\gate, 0); mg.set(\gate, 0); this.free; });
	}
	
	
	addSoice1 { arg ps, sp, lv, fc, rl, ss1;
		var params = Array.with(\out,mastering,\fxo,smokefx[0],\bnum,0,\pn,ps,\spd,sp,\lvl,lv,\fcoff,fc,\rls,rl,\tryg,1);
		var numSawces = sawc1.size;

		if(numSawces < maxVoices, 
		{ if((sawc1[ss1].notNil), 
		    { if(sawc1[ss1].isRunning==true){ sawc1[ss1].set(\rls, 0.001); sawc1[ss1].set(\gate, 0); } },
			  { sawc1.add(ss1 -> Synth.new("aw", params, target:dg, addAction: \addToTail));
			    NodeWatcher.register(sawc1[ss1]);
			    sawc1[s1].onFree({ sawc1.removeAt(ss1); }); 
			  });
		});
	}
	
	addSoice2 { arg ps, sp, lv, fc, rl, ss2;
		var params = Array.with(\out,mastering,\fxo,smokefx[0],\bnum,1,\pn,ps,\spd,sp,\lvl,lv,\fcoff,fc,\rls,rl,\tryg,1);
		var numSawces = sawc2.size;

		if(numSawces < maxVoices, 
		{ if((sawc2[ss2].notNil), 
		    { if(sawc2[ss2].isRunning==true){ sawc2[ss2].set(\rls, 0.001); sawc2[ss2].set(\gate, 0); } },
			  { sawc2.add(ss2 -> Synth.new("aw", params, target:dg, addAction: \addToTail));
			    NodeWatcher.register(sawc2[ss2]);
			    sawc2[ss2].onFree({ sawc2.removeAt(ss2); }); 
			  });
		});
	}
	
	addSoice3 { arg ps, sp, lv, fc, rl, ss3;
		var params = Array.with(\out,mastering,\fxo,smokefx[0],\bnum,2,\pn,ps,\spd,sp,\lvl,lv,\fcoff,fc,\rls,rl,\tryg,1);
		var numSawces = sawc3.size;

		if(numSawces < maxVoices, 
		{ if((sawc3[ss3].notNil), 
		    { if(sawc3[ss3].isRunning==true){ sawc3[ss3].set(\rls, 0.001); sawc3[ss3].set(\gate, 0); } },
			  { sawc3.add(ss3 -> Synth.new("aw", params, target:dg, addAction: \addToTail));
			    NodeWatcher.register(sawc3[ss3]);
			    sawc3[ss3].onFree({ sawc3.removeAt(ss3); }); 
			  });
		});
	}
	
	addSoice4 { arg ps, sp, lv, fc, rl, ss4;
		var params = Array.with(\out,mastering,\fxo,smokefx[0],\bnum,3,\pn,ps,\spd,sp,\lvl,lv,\fcoff,fc,\rls,rl,\tryg,1);
		var numSawces = sawc4.size;

		if(numSawces < maxVoices, 
		{ if((sawc4[ss4].notNil), 
		    { if(sawc4[ss4].isRunning==true){ sawc4[ss4].set(\rls, 0.001); sawc4[ss4].set(\gate, 0); } },
			  { sawc4.add(ss4 -> Synth.new("aw", params, target:dg, addAction: \addToTail));
			    NodeWatcher.register(sawc4[ss4]);
			    sawc4[ss4].onFree({ sawc4.removeAt(ss4); }); 
			  });
		});
	}
	
	free { pg.free; dg.free; mg.free; fxg.free; smokefx.free; fxroute.free; mastering.free; Buffer.freeAll; }
}
